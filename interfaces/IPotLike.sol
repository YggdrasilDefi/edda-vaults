pragma solidity ^0.6.6;

interface IPotLike {
  function pie(address) external view returns (uint256);

  function drip() external returns (uint256);

  function join(uint256) external;

  function exit(uint256) external;
}
