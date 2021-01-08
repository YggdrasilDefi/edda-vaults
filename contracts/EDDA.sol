pragma solidity ^0.6.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

// Development EDDA, not for production use
contract EDDA is ERC20 {
  constructor() public ERC20("Yggdrasil", "EDDA") {
    // Mint total supply to Governance during contract creation.
    // _mint is internal funciton of Openzeppelin ERC20 contract used to create all supply.
    // After contract creation, there is no way to call _mint() function on deployed contract.
    _mint(_msgSender(), uint256(5000 * 10**uint256(decimals())));
  }
}
