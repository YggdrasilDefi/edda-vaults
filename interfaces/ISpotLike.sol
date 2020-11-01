pragma solidity ^0.5.16;

interface ISpotLike {
    function ilks(bytes32) external view returns (address, uint);
}
