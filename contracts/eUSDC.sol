pragma solidity ^0.5.16;

import "./eVault.sol";

contract eUSDC is eVault {

    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    constructor (address _token, address _controller) public eVault(_token, _controller) {}
}