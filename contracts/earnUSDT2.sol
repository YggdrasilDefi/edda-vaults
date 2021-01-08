pragma solidity ^0.6.6;
pragma experimental ABIEncoderV2;

import "./Earn2.sol";

contract earnUSDT2 is Earn2 {
  constructor(address token_, address apr_) public Earn2("EDDA earnUSDT", "earnUSDT", 6) {
    token = token_; //// address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    apr = apr_;
    dydx = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);
    aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    fulcrum = address(0xF013406A0B1d544238083DF0B93ad0d2cBE0f65f);
    aaveToken = address(0x71fc860F7D3A592A4a98740e39dB31d25db65ae8);
    compound = address(0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9);
    approveToken();
  }
}
