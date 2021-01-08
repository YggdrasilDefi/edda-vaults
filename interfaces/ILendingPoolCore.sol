pragma solidity ^0.6.6;

interface ILendingPoolCore {
  function getReserveCurrentLiquidityRate(address _reserve) external view returns (uint256 liquidityRate);

  function getReserveInterestRateStrategyAddress(address _reserve) external view returns (address);

  function getReserveTotalBorrows(address _reserve) external view returns (uint256);

  function getReserveTotalBorrowsStable(address _reserve) external view returns (uint256);

  function getReserveTotalBorrowsVariable(address _reserve) external view returns (uint256);

  function getReserveCurrentAverageStableBorrowRate(address _reserve) external view returns (uint256);

  function getReserveAvailableLiquidity(address _reserve) external view returns (uint256);
}
