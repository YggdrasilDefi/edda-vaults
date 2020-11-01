pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import "./IStructs.sol";

contract IDDEX is IStructs {

  function getInterestRates(address token, uint256 extraBorrowAmount)
    external
    view
    returns (uint256 borrowInterestRate, uint256 supplyInterestRate);
  function getIndex(address token)
    external
    view
    returns (uint256 supplyIndex, uint256 borrowIndex);
  function getTotalSupply(address asset)
    external
    view
    returns (uint256 amount);
  function getTotalBorrow(address asset)
    external
    view
    returns (uint256 amount);
  function getAsset(address token)
    external
    view returns (Asset memory asset);
}
