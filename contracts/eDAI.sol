pragma solidity ^0.6.6;

import "./eVault.sol";

contract eDAI is eVault {
  address public DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

  constructor(address _token, address _controller) public eVault(_token, _controller) {}
}
