//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
@title Contract Airdrop for the KVK token
 */

contract Airdrop {
    address public admin;
    mapping(address => bool) public processedClaims; //prevent people clam the airdrop more than one time
    IERC20 public token;
    uint256 public currentAirdropAmount;
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

    /**@notice give the admin rights to another account */
    function updateAdmin(address _newAdmin) external onlyAdmin() {
        admin = _newAdmin;
    }

    // function claimTokens(
    //     address recipient,
    //     uint256 amount,
    //     bytes calldata signature
    // ) external {
    //     bytes32 message =
    //         prefixed(keccak266(abi.encodePacked(recipient, amount)));
    // }
}
