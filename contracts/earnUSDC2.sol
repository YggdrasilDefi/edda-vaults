pragma solidity ^0.6.6;
pragma experimental ABIEncoderV2;

import "./Earn2.sol";

contract earnUSDC2 is Earn2 {
  constructor(address token_, address apr_) public Earn2("EDDA earnUSDC", "earnUSDC", 6) {
    token = token_; //// address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    apr = apr_; //// address(0xdD6d648C991f7d47454354f4Ef326b04025a48A8);
    dydx = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);
    aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    fulcrum = address(0xF013406A0B1d544238083DF0B93ad0d2cBE0f65f);
    aaveToken = address(0x9bA00D6856a4eDF4665BcA2C2309936572473B7E);
    compound = address(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
    dToken = 2;
    approveToken();
  }
}
