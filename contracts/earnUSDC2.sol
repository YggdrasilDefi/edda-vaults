pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./earnTOKEN2.sol";

contract earnUSDC2 is earnTOKEN2 {
  constructor () public earnTOKEN2("EDDA earnUSDC", "earnUSDC", 18) {
    token = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    apr = address(0xdD6d648C991f7d47454354f4Ef326b04025a48A8);
    dydx = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);
    aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    fulcrum = address(0xF013406A0B1d544238083DF0B93ad0d2cBE0f65f);
    aaveToken = address(0x9bA00D6856a4eDF4665BcA2C2309936572473B7E);
    compound = address(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
    dToken = 2;
    approveToken();
  }

  function invest(uint256 _amount)
      external
      nonReentrant
  {
      require(_amount > 0, "deposit must be greater than 0");
      pool = calcPoolValueInToken();

      IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);

      rebalance();

      // Calculate pool shares
      uint256 shares = 0;
      if (pool == 0) {
        shares = _amount;
        pool = _amount;
      } else {
        shares = (_amount.mul(totalSupply())).div(pool);
      }
      pool = calcPoolValueInToken();
      _mint(msg.sender, shares);
  }

  // Redeem any invested tokens from the pool
  function redeem(uint256 _shares)
      external
      nonReentrant
  {
      require(_shares > 0, "withdraw must be greater than 0");

      uint256 ibalance = balanceOf(msg.sender);
      require(_shares <= ibalance, "insufficient balance");

      // Could have over value from cTokens
      pool = calcPoolValueInToken();
      // Calc to redeem before updating balances
      uint256 r = (pool.mul(_shares)).div(totalSupply());

      _burn(msg.sender, _shares);

      emit Transfer(msg.sender, address(0), _shares);

      // Check ETH balance
      uint256 b = IERC20(token).balanceOf(address(this));
      Lender newProvider = provider;
      if (b < r) {
        newProvider = recommend();
        if (newProvider != provider) {
          _withdrawAll();
        } else {
          _withdrawSome(r.sub(b));
        }
      }

      IERC20(token).safeTransfer(msg.sender, r);

      if (newProvider != provider) {
        _rebalance(newProvider);
      }
      pool = calcPoolValueInToken();
  }
}
