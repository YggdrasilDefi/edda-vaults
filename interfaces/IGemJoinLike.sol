pragma solidity ^0.6.6;

import "./IGemLike.sol";

interface IGemJoinLike {
  function dec() external returns (uint256);

  function gem() external returns (IGemLike);

  function join(address, uint256) external payable;

  function exit(address, uint256) external;
}
