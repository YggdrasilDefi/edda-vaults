pragma solidity ^0.5.16;

interface IGNTJoinLike {
    function bags(address) external view returns (address);
    function make(address) external returns (address);
}
