pragma solidity ^0.6.6;

interface IOSMedianizer {
  function read() external view returns (uint256, bool);

  function foresight() external view returns (uint256, bool);
}
