pragma solidity ^0.5.16;

interface IInterestRateModel {
  function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);
}
