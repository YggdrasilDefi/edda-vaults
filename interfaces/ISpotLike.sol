pragma solidity ^0.6.6;

interface ISpotLike {
  function ilks(bytes32) external view returns (address, uint256);
}
