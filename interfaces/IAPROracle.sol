pragma solidity ^0.6.6;

interface IAPROracle {
  function getCompoundAPR(address token) external view returns (uint256);

  function getFulcrumAPR(address token) external view returns (uint256);

  function getDyDxAPR(uint256 marketId) external view returns (uint256);

  function getAaveAPR(address token) external view returns (uint256);
}
