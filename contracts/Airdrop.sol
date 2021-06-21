//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
@title Contract Airdrop for the KVK token
 */

contract Airdrop {
    address public admin;
    mapping(address => bool) public processedClaims; //prevent people clam the airdrop more than one time
    IERC20 public token; //pointer to the token
    uint256 public currentAirdropAmount;

    /** the total suply of the airdrop. YES it's al the suply of the token. */
    uint256 public maxAirdropAmount = 100000000 * 10**18;

    event TokensAirdropped(address recipient, uint256 amount, uint256 date);

    modifier onlyAdmin() {
        require(
            msg.sender == admin,
            "Only the admin is awllowed to call this function"
        );
        _;
    }

    /** @notice set token to airdrop and admin
        @param _token the addres of the KVK token
        @param _admin the address of the admi of the airdrop
    */
    constructor(address _token, address _admin) {
        admin = _admin; ///@dev we dont set msg.sender to add more flexibility
        token = IERC20(_token);
    }

    /**@notice give the admin rights to another account. this is added for flexibility */
    function updateAdmin(address _newAdmin) external onlyAdmin() {
        admin = _newAdmin;
    }

    /**
     *@notice allows recipients to claims their tokens
     *@param amount specifies the amounts of tokens to claim
     *@param signature signature provided by the backend in order to verified that is the correct recipient
     @dev this function compute the message that was signed in the backend
     */

    function claimTokens(
        address recipient,
        uint256 amount,
        bytes calldata signature
    ) external {

        bytes32 message =
            _prefixed(keccak256(abi.encodePacked(recipient, amount)));

        //ensures that the signature is valid
        require(_recoverSigner(message, signature) == admin, "wrong signature");

        require(
            processedClaims[recipient] == false,
            "already has claimed tokens"
        );

        require(
            currentAirdropAmount + amount <= maxAirdropAmount,
            "airdropped 100% of the tokens"
        );

        processedClaims[recipient] = true;

        currentAirdropAmount += amount;

        token.transfer(recipient, amount);

        emit TokensAirdropped(recipient, amount, block.timestamp);
    }

    ///@notice add prefixes to the signing function
    ///@dev when you signed someting in ethereum this have this prefixeed
    function _prefixed(bytes32 hash) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
            );
    }


    //
    function _recoverSigner(bytes32 message, bytes memory sig)
        internal
        pure
        returns (address)
    {
        uint8 v;
        bytes32 r;
        bytes32 s;

        (v,r,s) = splitSignature(sig);

        return ecrecover(message, v, r, s);

    }

    //split the signature to recovery, to stract the signature elements in ehtereum
    function splitSignature(bytes memory sig)
        internal
        pure
        returns (
            uint8,
            bytes32,
            bytes32
        )
    {
        require(sig.length == 65);
        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(sig, 32))

            s := mload(add(sig, 64))

            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }
}
