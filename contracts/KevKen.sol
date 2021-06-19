//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

///@title ERC20 basic implementation contract
///@dev this contract follows the ERC20 OpenZeppelin Implementation
contract KevKen is ERC20 {


// ading the name and the symbol of the token
constructor() ERC20("KevKen", "KVK"){

  //creating the total suply of the token and asigning to the deployer of the contract
  _mint(msg.sender, 100000000  * 10 ** 18);
}
}

