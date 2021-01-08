pragma solidity ^0.6.6;

interface IUniswapFactory {
  function getExchange(address token) external view returns (address exchange);
}
