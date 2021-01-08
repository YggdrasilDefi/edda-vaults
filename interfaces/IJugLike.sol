pragma solidity ^0.6.6;

interface IJugLike {
  function drip(bytes32) external returns (uint256);
}
