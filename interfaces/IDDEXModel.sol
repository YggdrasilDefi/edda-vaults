pragma solidity ^0.5.16;

interface IDDEXModel {
  function polynomialInterestModel(uint256 borrowRatio) external view returns (uint256);
}
