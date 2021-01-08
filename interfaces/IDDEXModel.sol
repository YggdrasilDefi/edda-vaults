pragma solidity ^0.6.6;

interface IDDEXModel {
  function polynomialInterestModel(uint256 borrowRatio) external view returns (uint256);
}
