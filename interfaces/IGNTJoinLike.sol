pragma solidity ^0.6.6;

interface IGNTJoinLike {
  function bags(address) external view returns (address);

  function make(address) external returns (address);
}
