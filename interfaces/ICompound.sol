pragma solidity ^0.6.6;

interface ICompound {
  function mint(uint256 mintAmount) external returns (uint256);

  function redeem(uint256 redeemTokens) external returns (uint256);

  function exchangeRateStored() external view returns (uint256);

  function interestRateModel() external view returns (address);

  function reserveFactorMantissa() external view returns (uint256);

  function totalBorrows() external view returns (uint256);

  function totalReserves() external view returns (uint256);

  function supplyRatePerBlock() external view returns (uint256);

  function getCash() external view returns (uint256);
}
