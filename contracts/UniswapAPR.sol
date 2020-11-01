pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "../interfaces/IUniswapROI.sol";

contract UniswapAPR is Ownable {
    using SafeMath for uint;
    using Address for address;

    uint256 public ADAICreateAt;
    uint256 public CDAICreateAt;
    uint256 public CETHCreateAt;
    uint256 public CSAICreateAt;
    uint256 public CUSDCCreateAt;
    uint256 public DAICreateAt;
    uint256 public IDAICreateAt;
    uint256 public ISAICreateAt;
    uint256 public SUSDCreateAt;
    uint256 public TUSDCreateAt;
    uint256 public USDCCreateAt;
    uint256 public CHAICreateAt;

    address public UNIROI;
    address public CHAI;

    uint256 public blocksPerYear;

    constructor() public {
      ADAICreateAt = 9248529;
      CDAICreateAt = 9000629;
      CETHCreateAt = 7716382;
      CSAICreateAt = 7723867;
      CUSDCCreateAt = 7869920;
      DAICreateAt = 8939330;
      IDAICreateAt = 8975121;
      ISAICreateAt = 8362506;
      SUSDCreateAt = 8623684;
      TUSDCreateAt = 7794100;
      USDCCreateAt = 6783192;
      CHAICreateAt = 9028682;

      UNIROI = address(0xD04cA0Ae1cd8085438FDd8c22A76246F315c2687);
      CHAI = address(0x6C3942B383bc3d0efd3F36eFa1CBE7C8E12C8A2B);
      blocksPerYear = 2102400;
    }


    function set_new_UNIROI(address _new_UNIROI) public onlyOwner {
        UNIROI = _new_UNIROI;
    }
    function set_new_CHAI(address _new_CHAI) public onlyOwner {
        CHAI = _new_CHAI;
    }

    function set_new_blocksPerYear(uint256 _new_blocksPerYear) public onlyOwner {
        blocksPerYear = _new_blocksPerYear;
    }

    function getBlocksPerYear() public view returns (uint256) {
      return blocksPerYear;
    }

    function calcUniswapAPRADAI() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getADAIUniROI();
      return (calcUniswapAPRFromROI(roi, ADAICreateAt), liquidity);
    }
    function calcUniswapAPRCDAI() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getCDAIUniROI();
      return (calcUniswapAPRFromROI(roi, CDAICreateAt), liquidity);
    }
    function calcUniswapAPRCETH() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getCETHUniROI();
      return (calcUniswapAPRFromROI(roi, CETHCreateAt), liquidity);
    }
    function calcUniswapAPRCSAI() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getCSAIUniROI();
      return (calcUniswapAPRFromROI(roi, CSAICreateAt), liquidity);
    }
    function calcUniswapAPRCUSDC() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getCUSDCUniROI();
      return (calcUniswapAPRFromROI(roi, CUSDCCreateAt), liquidity);
    }
    function calcUniswapAPRDAI() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getDAIUniROI();
      return (calcUniswapAPRFromROI(roi, DAICreateAt), liquidity);
    }
    function calcUniswapAPRIDAI() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getIDAIUniROI();
      return (calcUniswapAPRFromROI(roi, IDAICreateAt), liquidity);
    }
    function calcUniswapAPRISAI() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getISAIUniROI();
      return (calcUniswapAPRFromROI(roi, ISAICreateAt), liquidity);
    }
    function calcUniswapAPRSUSD() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getSUSDUniROI();
      return (calcUniswapAPRFromROI(roi, SUSDCreateAt), liquidity);
    }
    function calcUniswapAPRTUSD() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getTUSDUniROI();
      return (calcUniswapAPRFromROI(roi, TUSDCreateAt), liquidity);
    }
    function calcUniswapAPRUSDC() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).getUSDCUniROI();
      return (calcUniswapAPRFromROI(roi, USDCCreateAt), liquidity);
    }
    function calcUniswapAPRCHAI() public view returns (uint256, uint256) {
      (uint256 roi,uint256 liquidity) = IUniswapROI(UNIROI).calcUniswapROI(CHAI);
      return (calcUniswapAPRFromROI(roi, CHAICreateAt), liquidity);
    }

    function calcUniswapAPRFromROI(uint256 roi, uint256 createdAt) public view returns (uint256) {
      require(createdAt < block.number, "invalid createAt block");
      uint256 roiFrom = block.number.sub(createdAt);
      uint256 baseAPR = roi.mul(1e15).mul(blocksPerYear).div(roiFrom);
      uint256 adjusted = blocksPerYear.mul(1e18).div(roiFrom);
      return baseAPR.add(1e18).sub(adjusted);
    }

    function calcUniswapAPR(address token, uint256 createdAt) public view returns (uint256) {
      require(createdAt < block.number, "invalid createAt block");
      // ROI returned as shifted 1e4
      (uint256 roi,) = IUniswapROI(UNIROI).calcUniswapROI(token);
      uint256 roiFrom = block.number.sub(createdAt);
      uint256 baseAPR = roi.mul(1e15).mul(blocksPerYear).div(roiFrom);
      uint256 adjusted = blocksPerYear.mul(1e18).div(roiFrom);
      return baseAPR.add(1e18).sub(adjusted);
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