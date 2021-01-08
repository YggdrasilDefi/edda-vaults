pragma solidity ^0.6.6;
pragma experimental ABIEncoderV2;

import "./IStructs.sol";

abstract contract IDyDx is IStructs {
  struct val {
    uint256 value;
  }

  struct set {
    uint128 borrow;
    uint128 supply;
  }

  function getAccountWei(Info memory account, uint256 marketId) public view virtual returns (Wei memory);

  function operate(Info[] memory, ActionArgs[] memory) public virtual;

  function getEarningsRate() external view virtual returns (val memory);

  function getMarketInterestRate(uint256 marketId) external view virtual returns (val memory);

  function getMarketTotalPar(uint256 marketId) external view virtual returns (set memory);
}
