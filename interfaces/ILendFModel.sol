pragma solidity ^0.5.16;

interface ILendFModel {
    function getSupplyRate(address asset, uint cash, uint borrows) external view returns (uint, uint);
}
