pragma solidity ^0.6.6;
pragma experimental ABIEncoderV2;

import "./Earn2.sol";

contract earnWBTC2 is Earn2 {
  constructor(address token_, address apr_) public Earn2("EDDA earnWBTC", "earnWBTC", 8) {
    token = token_; //// address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
    apr = apr_;
    dydx = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);
    aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    fulcrum = address(0xBA9262578EFef8b3aFf7F60Cd629d6CC8859C8b5);
    aaveToken = address(0xFC4B8ED459e00e5400be803A9BB3954234FD50e3);
    compound = address(0xC11b1268C1A384e55C48c2391d8d480264A3A7F4);
    approveToken();
  }
}
