pragma solidity ^0.5.16;

import "./IGemLike.sol";

interface IGemJoinLike {
    function dec() external returns (uint);
    function gem() external returns (IGemLike);
    function join(address, uint) external payable;
    function exit(address, uint) external;
}
