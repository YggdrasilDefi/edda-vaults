pragma solidity ^0.6.6;
pragma experimental ABIEncoderV2;

import "./Earn2.sol";

contract earnDAI2 is Earn2 {
  constructor(address token_, address apr_) public Earn2("EDDA earnDAI", "earnDAI", 18) {
    token = token_; //// address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    apr = apr_;
    dydx = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);
    aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    fulcrum = address(0x493C57C4763932315A328269E1ADaD09653B9081);
    aaveToken = address(0xfC1E690f61EFd961294b3e1Ce3313fBD8aa4f85d);
    compound = address(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    dToken = 3;
    approveToken();
  }
}
