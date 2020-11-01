pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./earnTOKEN2.sol";

contract earnTUSD2 is earnTOKEN2 {
  constructor () public earnTOKEN2("EDDA earnTUSD", "earnTUSD", 18) {
    token = address(0x0000000000085d4780B73119b644AE5ecd22b376);
    apr = address(0xdD6d648C991f7d47454354f4Ef326b04025a48A8);
    dydx = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);
    aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    fulcrum = address(0x49f4592E641820e928F9919Ef4aBd92a719B4b49);
    aaveToken = address(0x4DA9b813057D04BAef4e5800E36083717b4a0341);
    compound = address(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
    approveToken();
  }
}
