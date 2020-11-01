pragma solidity ^0.5.16;

interface IPotLike {
    function pie(address) external view returns (uint);
    function drip() external returns (uint);
    function join(uint) external;
    function exit(uint) external;
}
