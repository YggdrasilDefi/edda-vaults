pragma solidity ^0.6.6;

interface IGemLike {
  function approve(address, uint256) external;

  function transfer(address, uint256) external;

  function transferFrom(
    address,
    address,
    uint256
  ) external;

  function deposit() external payable;

  function withdraw(uint256) external;
}
