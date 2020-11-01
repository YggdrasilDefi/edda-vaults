pragma solidity ^0.5.0;

contract IUniswapAPR {
    function getBlocksPerYear() external view returns (uint256);
    function calcUniswapAPRFromROI(uint256 roi, uint256 createdAt) external view returns (uint256);
    function calcUniswapAPR(address token, uint256 createdAt) external view returns (uint256);
}
