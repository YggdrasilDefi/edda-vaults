pragma solidity ^0.5.16;

interface IJugLike {
    function drip(bytes32) external returns (uint);
}
