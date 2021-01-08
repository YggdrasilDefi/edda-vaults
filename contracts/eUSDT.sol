pragma solidity ^0.6.6;

import "./eVault.sol";

contract eUSDT is eVault {
  address public constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;

  constructor(address _token, address _controller) public eVault(_token, _controller) {}
}
