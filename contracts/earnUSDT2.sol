pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./earnTOKEN2.sol";

contract earnUSDT2 is earnTOKEN2 {
  constructor () public earnTOKEN2("EDDA earnUSDT", "earnUSDT", 18) {
    token = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    apr = address(0xdD6d648C991f7d47454354f4Ef326b04025a48A8);
    dydx = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);
    aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    fulcrum = address(0xF013406A0B1d544238083DF0B93ad0d2cBE0f65f);
    aaveToken = address(0x71fc860F7D3A592A4a98740e39dB31d25db65ae8);
    compound = address(0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9);
    approveToken();
  }
}
