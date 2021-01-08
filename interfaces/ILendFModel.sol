pragma solidity ^0.6.6;

interface ILendFModel {
  function getSupplyRate(
    address asset,
    uint256 cash,
    uint256 borrows
  ) external view returns (uint256, uint256);
}
