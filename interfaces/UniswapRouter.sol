pragma solidity ^0.5.16;

interface UniswapRouter {
    function swapExactTokensForTokens(uint, uint, address[] calldata, address, uint) external;
}