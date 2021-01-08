pragma solidity ^0.6.6;

interface ILendF {
  function getSupplyBalance(address account, address token) external view returns (uint256);

  function supplyBalances(address account, address token)
    external
    view
    returns (uint256 principal, uint256 interestIndex);

  function supply(address asset, uint256 amount) external;

  function withdraw(address asset, uint256 amount) external;

  function markets(address asset)
    external
    view
    returns (
      bool isSupported,
      uint256 blockNumber,
      address interestRateModel,
      uint256 totalSupply,
      uint256 supplyRateMantissa,
      uint256 supplyIndex,
      uint256 totalBorrows,
      uint256 borrowRateMantissa,
      uint256 borrowIndex
    );
}
