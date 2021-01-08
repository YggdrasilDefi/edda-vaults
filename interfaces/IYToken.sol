pragma solidity ^0.6.6;

interface IYToken {
  function calcPoolValueInToken() external view returns (uint256);

  function decimals() external view returns (uint256);
}
