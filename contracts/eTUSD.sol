pragma solidity ^0.5.16;

import "./eVault.sol";

contract eTUSD is eVault {

    address public constant TUSD = 0x0000000000085d4780B73119b644AE5ecd22b376;

    constructor (address _token, address _controller) public eVault(_token, _controller) {}
}