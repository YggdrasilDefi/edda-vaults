pragma solidity ^0.5.0;

interface IYToken {
  function calcPoolValueInToken() external view returns (uint256);
  function decimals() external view returns (uint256);
}
