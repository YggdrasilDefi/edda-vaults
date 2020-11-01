pragma solidity ^0.5.16;

interface IOSMedianizer {
    function read() external view returns (uint, bool);
    function foresight() external view returns (uint, bool);
}
