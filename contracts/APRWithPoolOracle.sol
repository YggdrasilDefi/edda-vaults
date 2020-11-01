/**
 *Submitted for verification at Etherscan.io on 2020-02-07
*/

pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "../interfaces/ICompound.sol";
import "../interfaces/IFulcrum.sol";
import "../interfaces/IDyDx.sol";
import "../interfaces/ILendingPoolAddressesProvider.sol";
import "../interfaces/ILendingPoolCore.sol";
import "../interfaces/IReserveInterestRateStrategy.sol";
import "../interfaces/IInterestRateModel.sol";
import "../interfaces/IStructs.sol";
import "../interfaces/IDDEX.sol";
import "../interfaces/IDDEXModel.sol";
import "../interfaces/ILendF.sol";
import "../interfaces/ICurveFi.sol";
import "../interfaces/ILendFModel.sol";

import "./Decimal.sol";

contract APRWithPoolOracle is Ownable, IStructs {
  using SafeMath for uint256;
  using Address for address;

  uint256 DECIMAL = 10 ** 18;

  address public DYDX;
  address public AAVE;
  address public DDEX;
  address public LENDF;
  address public CURVEFI;

  uint256 public liquidationRatio;
  uint256 public dydxModifier;
  uint256 public blocksPerYear;

  constructor() public {
    DYDX = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);
    AAVE = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    DDEX = address(0x241e82C79452F51fbfc89Fac6d912e021dB1a3B7);
    LENDF = address(0x0eEe3E3828A45f7601D5F54bF49bB01d1A9dF5ea);
    CURVEFI = address(0x2e60CF74d81ac34eB21eEff58Db4D385920ef419);
    liquidationRatio = 50000000000000000;
    dydxModifier = 20;
    // 3153600 seconds div 13 second blocks
    blocksPerYear = 242584;
  }

  function set_new_AAVE(address _new_AAVE) public onlyOwner {
      AAVE = _new_AAVE;
  }
  function set_new_CURVEFI(address _new_CURVEFI) public onlyOwner {
      CURVEFI = _new_CURVEFI;
  }
  function set_new_DDEX(address _new_DDEX) public onlyOwner {
      DDEX = _new_DDEX;
  }
  function set_new_DYDX(address _new_DYDX) public onlyOwner {
      DYDX = _new_DYDX;
  }
  function set_new_LENDF(address _new_LENDF) public onlyOwner {
      LENDF = _new_LENDF;
  }
  function set_new_Ratio(uint256 _new_Ratio) public onlyOwner {
      liquidationRatio = _new_Ratio;
  }
  function set_new_Modifier(uint256 _new_Modifier) public onlyOwner {
      dydxModifier = _new_Modifier;
  }
  function set_new_blocksPerYear(uint256 _new_blocksPerYear) public onlyOwner {
      blocksPerYear = _new_blocksPerYear;
  }

  function getLENDFAPR(address token) public view returns (uint256) {
    (,,,,uint256 supplyRateMantissa,,,,) = ILendF(LENDF).markets(token);
    return supplyRateMantissa.mul(blocksPerYear);
  }

  function getLENDFAPRAdjusted(address token, uint256 supply) public view returns (uint256) {
    if (token == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)) {
      return 0;
    }
    uint256 totalCash = IERC20(token).balanceOf(LENDF).add(supply);
    (,, address interestRateModel,,,, uint256 totalBorrows,,) = ILendF(LENDF).markets(token);
    if (interestRateModel == address(0)) {
      return 0;
    }
    (, uint256 supplyRateMantissa) = ILendFModel(interestRateModel).getSupplyRate(token, totalCash, totalBorrows);
    return supplyRateMantissa.mul(blocksPerYear);
  }

  function getDDEXAPR(address token) public view returns (uint256) {
    if (token == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)) {
      token = address(0x000000000000000000000000000000000000000E);
    }
    (uint256 supplyIndex,) = IDDEX(DDEX).getIndex(token);
    if (supplyIndex == 0) {
      return 0;
    }
    (,uint256 supplyRate) = IDDEX(DDEX).getInterestRates(token, 0);
    return supplyRate;
  }

  function getDDEXAPRAdjusted(address token, uint256 _supply) public view returns (uint256) {
    if (token == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)) {
      token = address(0x000000000000000000000000000000000000000E);
    }
    (uint256 supplyIndex,) = IDDEX(DDEX).getIndex(token);
    if (supplyIndex == 0) {
      return 0;
    }
    uint256 supply = IDDEX(DDEX).getTotalSupply(token).add(_supply);
    uint256 borrow = IDDEX(DDEX).getTotalBorrow(token);
    uint256 borrowRatio = borrow.mul(Decimal.one()).div(supply);
    address interestRateModel = IDDEX(DDEX).getAsset(token).interestModel;
    uint256 borrowRate = IDDEXModel(interestRateModel).polynomialInterestModel(borrowRatio);
    uint256 borrowInterest = Decimal.mulCeil(borrow, borrowRate);
    uint256 supplyInterest = Decimal.mulFloor(borrowInterest, Decimal.one().sub(liquidationRatio));
    return Decimal.divFloor(supplyInterest, supply);
  }

  function getCompoundAPR(address token) public view returns (uint256) {
    return ICompound(token).supplyRatePerBlock().mul(blocksPerYear);
  }

  function getCompoundAPRAdjusted(address token, uint256 _supply) public view returns (uint256) {
    ICompound c = ICompound(token);
    address model = ICompound(token).interestRateModel();
    if (model == address(0)) {
      return c.supplyRatePerBlock().mul(blocksPerYear);
    }
    IInterestRateModel i = IInterestRateModel(model);
    uint256 cashPrior = c.getCash().add(_supply);
    return i.getSupplyRate(cashPrior, c.totalBorrows(), c.totalReserves().add(_supply), c.reserveFactorMantissa()).mul(blocksPerYear);
  }

  function getFulcrumAPR(address token) public view returns(uint256) {
    return IFulcrum(token).supplyInterestRate().div(100);
  }

  function getFulcrumAPRAdjusted(address token, uint256 _supply) public view returns(uint256) {
    return IFulcrum(token).nextSupplyInterestRate(_supply).div(100);
  }

  function getDyDxAPR(uint256 marketId) public view returns(uint256) {
    uint256 rate      = IDyDx(DYDX).getMarketInterestRate(marketId).value;
    uint256 aprBorrow = rate * 31622400;
    uint256 borrow    = IDyDx(DYDX).getMarketTotalPar(marketId).borrow;
    uint256 supply    = IDyDx(DYDX).getMarketTotalPar(marketId).supply;
    uint256 usage     = (borrow * DECIMAL) / supply;
    uint256 apr       = (((aprBorrow * usage) / DECIMAL) * IDyDx(DYDX).getEarningsRate().value) / DECIMAL;
    return apr;
  }

  function getCurveAPR(address curve) public view returns (uint256) {
    uint256 blocks = block.number.sub(9325883);
    uint256 price = ICurveFi(curve).get_virtual_price().sub(1e18);
    return price.mul(blocksPerYear).div(blocks);
  }

  function getDyDxAPRAdjusted(uint256 marketId, uint256 _supply) public view returns(uint256) {
    uint256 rate      = IDyDx(DYDX).getMarketInterestRate(marketId).value;
    // Arbitrary value to offset calculations
    _supply = _supply.mul(dydxModifier);
    uint256 aprBorrow = rate * 31622400;
    uint256 borrow    = IDyDx(DYDX).getMarketTotalPar(marketId).borrow;
    uint256 supply    = IDyDx(DYDX).getMarketTotalPar(marketId).supply;
    supply = supply.add(_supply);
    uint256 usage     = (borrow * DECIMAL) / supply;
    uint256 apr       = (((aprBorrow * usage) / DECIMAL) * IDyDx(DYDX).getEarningsRate().value) / DECIMAL;
    return apr;
  }

  function getAaveCore() public view returns (address) {
    return address(ILendingPoolAddressesProvider(AAVE).getLendingPoolCore());
  }

  function getAaveAPR(address token) public view returns (uint256) {
    ILendingPoolCore core = ILendingPoolCore(ILendingPoolAddressesProvider(AAVE).getLendingPoolCore());
    return core.getReserveCurrentLiquidityRate(token).div(1e9);
  }

  function getAaveAPRAdjusted(address token, uint256 _supply) public view returns (uint256) {
    ILendingPoolCore core = ILendingPoolCore(ILendingPoolAddressesProvider(AAVE).getLendingPoolCore());
    IReserveInterestRateStrategy apr = IReserveInterestRateStrategy(core.getReserveInterestRateStrategyAddress(token));
    (uint256 newLiquidityRate,,) = apr.calculateInterestRates(
      token,
      core.getReserveAvailableLiquidity(token).add(_supply),
      core.getReserveTotalBorrowsStable(token),
      core.getReserveTotalBorrowsVariable(token),
      core.getReserveCurrentAverageStableBorrowRate(token)
    );
    return newLiquidityRate.div(1e9);
  }

  // incase of half-way error
  function inCaseTokenGetsStuck(IERC20 _TokenAddress) onlyOwner public {
      uint qty = _TokenAddress.balanceOf(address(this));
      _TokenAddress.transfer(msg.sender, qty);
  }
  // incase of half-way error
  function inCaseETHGetsStuck() onlyOwner public{
      (bool result, ) = msg.sender.call.value(address(this).balance)("");
      require(result, "transfer of ETH failed");
  }
}