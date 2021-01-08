pragma solidity ^0.6.6;

abstract contract IUniswapAPR {
  function getBlocksPerYear() external view virtual returns (uint256);

  function calcUniswapAPRFromROI(uint256 roi, uint256 createdAt) external view virtual returns (uint256);

  function calcUniswapAPR(address token, uint256 createdAt) external view virtual returns (uint256);
}
