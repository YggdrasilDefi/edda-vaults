pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import "./IStructs.sol";

contract IDyDx is IStructs {
  struct val {
       uint256 value;
   }

   struct set {
      uint128 borrow;
      uint128 supply;
  }

  function getAccountWei(Info memory account, uint256 marketId) public view returns (Wei memory);
  function operate(Info[] memory, ActionArgs[] memory) public;

  function getEarningsRate() external view returns (val memory);
  function getMarketInterestRate(uint256 marketId) external view returns (val memory);
  function getMarketTotalPar(uint256 marketId) external view returns (set memory);
}
