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

    modifier onlyAdmin() {
        require(
            msg.sender == admin,
            "Only the admin is awllowed to call this function"
        );
        _;
    }

    /** @notice set token to airdrop and admin*/
    constructor(address _token, address _admin) {
        admin = _admin;
        token = IERC20(_token);
    }

    /**@notice give the admin rights to another account. this is added for flexibility */
    function updateAdmin(address _newAdmin) external onlyAdmin() {
        admin = _newAdmin;
    }

    /** @notice Each recipients have to call this function in order to claim their tokens */

    // function claimTokens(
    //     address recipient,
    //     uint256 amount,
    //     bytes calldata signature
    // ) external {
    //     bytes32 message =
    //         prefixed(keccak266(abi.encodePacked(recipient, amount)));
    // }


    function splitSignature(bytes memory sig)
        internal
        pure
        returns (uint8, bytes32, bytes32)
        {
            require(sig.length == 65);
            bytes32 r;
            bytes32 s;
            uint8 v;

            assembly {
                r:= mload(add(sig,32))

                s:= mload(add(sig,64))

                v := byte(0, mload(add(sig, 96)))
            }

            return (v,r,s);
        }
}
