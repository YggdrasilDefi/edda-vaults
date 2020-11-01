pragma solidity ^0.5.0;

interface IAPROracle {
  function getCompoundAPR(address token) external view returns (uint256);
  function getFulcrumAPR(address token) external view returns(uint256);
  function getDyDxAPR(uint256 marketId) external view returns(uint256);
  function getAaveAPR(address token) external view returns (uint256);
}
