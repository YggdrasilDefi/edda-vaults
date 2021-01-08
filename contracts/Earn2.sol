pragma solidity ^0.6.6;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

import "../interfaces/ICompound.sol";
import "../interfaces/IFulcrum.sol";
import "../interfaces/ILendingPoolAddressesProvider.sol";
import "../interfaces/IAave.sol";
import "../interfaces/IAToken.sol";
import "../interfaces/IIEarnManager.sol";
import "../interfaces/IStructs.sol";
import "../interfaces/IDyDx.sol";

import "./ReentrancyGuard.sol";

contract Earn2 is ERC20, ReentrancyGuard, Ownable, IStructs {
  using SafeERC20 for IERC20;
  using Address for address;
  using SafeMath for uint256;

  uint256 public pool;
  address public token;
  address public compound;
  address public fulcrum;
  address public aave;
  address public aaveToken;
  address public dydx;
  uint256 public dToken;
  address public apr;

  enum Lender {NONE, DYDX, COMPOUND, AAVE, FULCRUM}

  Lender public provider = Lender.NONE;

  constructor(
    string memory name,
    string memory symbol,
    uint8 decimals
  ) public ERC20(name, symbol) {
    _setupDecimals(decimals);
  }

  // Ownable setters incase of support in future for these systems
  function set_new_APR(address _new_APR) public onlyOwner {
    apr = _new_APR;
  }

  function set_new_FULCRUM(address _new_FULCRUM) public onlyOwner {
    fulcrum = _new_FULCRUM;
  }

  function set_new_COMPOUND(address _new_COMPOUND) public onlyOwner {
    compound = _new_COMPOUND;
  }

  function set_new_AAVE_TOKEN(address _new_AAVE_TOKEN) public onlyOwner {
    aaveToken = _new_AAVE_TOKEN;
  }

  function set_new_DTOKEN(uint256 _new_DTOKEN) public onlyOwner {
    dToken = _new_DTOKEN;
  }

  // Quick swap low gas method for pool swaps
  function deposit(uint256 _amount) external nonReentrant {
    _invest(_amount, false);
  }

  // No rebalance implementation for lower fees and faster swaps
  function withdraw(uint256 _shares) external nonReentrant {
    _redeem(_shares, false);
  }

  receive() external payable {}

  function recommend() public view returns (Lender newProvider) {
    // capr is max by default - throw away one variable
    (, uint256 max, uint256 iapr, uint256 aapr, uint256 dapr) = IIEarnManager(apr).recommend(token);
    newProvider = Lender.COMPOUND;
    if (iapr > max) {
      max = iapr;
      newProvider = Lender.FULCRUM;
    }
    if (aapr > max) {
      max = aapr;
      newProvider = Lender.AAVE;
    }
    if (dapr > max) {
      newProvider = Lender.DYDX;
    }
  }

  function supplyDydx(uint256 amount) public returns (uint256) {
    Info[] memory infos = new Info[](1);
    infos[0] = Info(address(this), 0);

    AssetAmount memory amt = AssetAmount(true, AssetDenomination.Wei, AssetReference.Delta, amount);
    ActionArgs memory act;
    act.actionType = ActionType.Deposit;
    act.accountId = 0;
    act.amount = amt;
    act.primaryMarketId = dToken;
    act.otherAddress = address(this);

    ActionArgs[] memory args = new ActionArgs[](1);
    args[0] = act;

    IDyDx(dydx).operate(infos, args);
  }

  function _withdrawDydx(uint256 amount) internal {
    Info[] memory infos = new Info[](1);
    infos[0] = Info(address(this), 0);

    AssetAmount memory amt = AssetAmount(false, AssetDenomination.Wei, AssetReference.Delta, amount);
    ActionArgs memory act;
    act.actionType = ActionType.Withdraw;
    act.accountId = 0;
    act.amount = amt;
    act.primaryMarketId = dToken;
    act.otherAddress = address(this);

    ActionArgs[] memory args = new ActionArgs[](1);
    args[0] = act;

    IDyDx(dydx).operate(infos, args);
  }

  function getAave() public view returns (address) {
    return ILendingPoolAddressesProvider(aave).getLendingPool();
  }

  function getAaveCore() public view returns (address) {
    return ILendingPoolAddressesProvider(aave).getLendingPoolCore();
  }

  function approveToken() public {
    IERC20(token).safeApprove(compound, uint256(-1)); //also add to constructor
    IERC20(token).safeApprove(dydx, uint256(-1));
    IERC20(token).safeApprove(getAaveCore(), uint256(-1));
    IERC20(token).safeApprove(fulcrum, uint256(-1));
  }

  function balance() public view returns (uint256) {
    return IERC20(token).balanceOf(address(this));
  }

  function balanceDydx() public view returns (uint256) {
    Wei memory bal = IDyDx(dydx).getAccountWei(Info(address(this), 0), dToken);
    return bal.value;
  }

  function balanceCompound() public view returns (uint256) {
    return IERC20(compound).balanceOf(address(this));
  }

  function balanceCompoundInToken() public view returns (uint256) {
    // Mantisa 1e18 to decimals
    uint256 b = balanceCompound();
    if (b > 0) {
      b = b.mul(ICompound(compound).exchangeRateStored()).div(1e18);
    }
    return b;
  }

  function balanceFulcrumInToken() public view returns (uint256) {
    uint256 b = balanceFulcrum();
    if (b > 0) {
      b = IFulcrum(fulcrum).assetBalanceOf(address(this));
    }
    return b;
  }

  function balanceFulcrum() public view returns (uint256) {
    return IERC20(fulcrum).balanceOf(address(this));
  }

  function balanceAave() public view returns (uint256) {
    return IERC20(aaveToken).balanceOf(address(this));
  }

  function _withdrawAll() internal {
    uint256 amount = balanceCompound();
    if (amount > 0) {
      _withdrawCompound(amount);
    }
    amount = balanceDydx();
    if (amount > 0) {
      _withdrawDydx(amount);
    }
    amount = balanceFulcrum();
    if (amount > 0) {
      _withdrawFulcrum(amount);
    }
    amount = balanceAave();
    if (amount > 0) {
      _withdrawAave(amount);
    }
  }

  function _withdrawSomeCompound(uint256 _amount) internal {
    uint256 b = balanceCompound();
    uint256 bT = balanceCompoundInToken();
    require(bT >= _amount, "insufficient funds");
    // can have unintentional rounding errors
    uint256 amount = (b.mul(_amount)).div(bT).add(1);
    _withdrawCompound(amount);
  }

  // 1999999614570950845
  function _withdrawSomeFulcrum(uint256 _amount) internal {
    // Balance of fulcrum tokens, 1 iDAI = 1.00x DAI
    uint256 b = balanceFulcrum(); // 1970469086655766652
    // Balance of token in fulcrum
    uint256 bT = balanceFulcrumInToken(); // 2000000803224344406
    require(bT >= _amount, "insufficient funds");
    // can have unintentional rounding errors
    uint256 amount = (b.mul(_amount)).div(bT).add(1);
    _withdrawFulcrum(amount);
  }

  function _withdrawSome(uint256 _amount) internal {
    if (provider == Lender.COMPOUND) {
      _withdrawSomeCompound(_amount);
    }
    if (provider == Lender.AAVE) {
      require(balanceAave() >= _amount, "insufficient funds");
      _withdrawAave(_amount);
    }
    if (provider == Lender.DYDX) {
      require(balanceDydx() >= _amount, "insufficient funds");
      _withdrawDydx(_amount);
    }
    if (provider == Lender.FULCRUM) {
      _withdrawSomeFulcrum(_amount);
    }
  }

  function rebalance() public {
    Lender newProvider = recommend();

    if (newProvider != provider) {
      _withdrawAll();
    }

    _rebalance(newProvider);
  }

  // Internal only rebalance for better gas in redeem
  function _rebalance(Lender newProvider) internal {
    uint256 _balance = balance();
    if (_balance > 0) {
      if (newProvider == Lender.DYDX) {
        supplyDydx(_balance);
      } else if (newProvider == Lender.FULCRUM) {
        supplyFulcrum(_balance);
      } else if (newProvider == Lender.COMPOUND) {
        supplyCompound(_balance);
      } else if (newProvider == Lender.AAVE) {
        supplyAave(_balance);
      }
    }
    provider = newProvider;
  }

  function supplyAave(uint256 amount) public {
    IAave(getAave()).deposit(token, amount, 0);
  }

  function supplyFulcrum(uint256 amount) public {
    require(IFulcrum(fulcrum).mint(address(this), amount) > 0, "FULCRUM: supply failed");
  }

  function supplyCompound(uint256 amount) public {
    require(ICompound(compound).mint(amount) == 0, "COMPOUND: supply failed");
  }

  function _withdrawAave(uint256 amount) internal {
    IAToken(aaveToken).redeem(amount);
  }

  function _withdrawFulcrum(uint256 amount) internal {
    require(IFulcrum(fulcrum).burn(address(this), amount) > 0, "FULCRUM: withdraw failed");
  }

  function _withdrawCompound(uint256 amount) internal {
    require(ICompound(compound).redeem(amount) == 0, "COMPOUND: withdraw failed");
  }

  function calcPoolValueInToken() public view returns (uint256) {
    return balanceCompoundInToken().add(balanceFulcrumInToken()).add(balanceDydx()).add(balanceAave()).add(balance());
  }

  function getPricePerFullShare() public view returns (uint256 result) {
    uint256 _pool = calcPoolValueInToken();
    if (totalSupply() > 0) {
      result = _pool.mul(1e18).div(totalSupply());
    }
  }

  function invest(uint256 _amount) external virtual nonReentrant {
    _invest(_amount, true);
  }

  function _invest(uint256 _amount, bool rebalanceFlag) internal virtual {
    require(_amount > 0, "deposit must be greater than 0");
    pool = calcPoolValueInToken();

    IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);

    if (rebalanceFlag) {
      rebalance();
    }

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
  function redeem(uint256 _shares) external virtual nonReentrant {
    _redeem(_shares, true);
  }

  function _redeem(uint256 _shares, bool rebalanceFlag) internal virtual {
    require(_shares > 0, "withdraw must be greater than 0");

    uint256 ibalance = balanceOf(msg.sender);
    require(_shares <= ibalance, "insufficient balance");

    // Could have over value from cTokens
    pool = calcPoolValueInToken();
    // Calc to redeem before updating balances
    uint256 r = (pool.mul(_shares)).div(totalSupply());

    _burn(msg.sender, _shares);

    // Check ETH balance
    uint256 b = IERC20(token).balanceOf(address(this));
    Lender newProvider = provider;
    if (b < r) {
      if (rebalanceFlag) {
        newProvider = recommend();
        if (newProvider != provider) {
          _withdrawAll();
        } else {
          _withdrawSome(r.sub(b));
        }
      } else {
        _withdrawSome(r.sub(b));
      }
    }

    IERC20(token).safeTransfer(msg.sender, r);

    if (rebalanceFlag && newProvider != provider) {
      _rebalance(newProvider);
    }
    pool = calcPoolValueInToken();
  }
}
