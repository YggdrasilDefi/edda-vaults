pragma solidity ^0.6.6;

interface IEndLike {
  function fix(bytes32) external view returns (uint256);

  function cash(bytes32, uint256) external;

  function free(bytes32) external;

  function pack(uint256) external;

  function skim(bytes32, address) external;
}
