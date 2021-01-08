// https://etherscan.io/address/0xd04ca0ae1cd8085438fdd8c22a76246f315c2687#code

pragma solidity ^0.6.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "../interfaces/IUniswapFactory.sol";
import "../interfaces/IUniswapExchange.sol";

contract UniswapROI is Ownable {
  using SafeMath for uint256;
  using Address for address;

  address public UNI;

  // Ease of use functions, can also use generic lookups for new tokens
  address public CDAI;
  address public CBAT;
  address public CETH;
  address public CREP;
  address public CSAI;
  address public CUSDC;
  address public CWBTC;
  address public CZRX;

  address public IZRX;
  address public IREP;
  address public IKNC;
  address public IBAT;
  address public IWBTC;
  address public IUSDC;
  address public IETH;
  address public ISAI;
  address public IDAI;
  address public ILINK;
  address public ISUSD;

  address public ADAI;
  address public ATUSD;
  address public AUSDC;
  address public AUSDT;
  address public ASUSD;
  address public ALEND;
  address public ABAT;
  address public AETH;
  address public ALINK;
  address public AKNC;
  address public AREP;
  address public AMKR;
  address public AMANA;
  address public AZRX;
  address public ASNX;
  address public AWBTC;

  address public DAI;
  address public TUSD;
  address public USDC;
  address public USDT;
  address public SUSD;
  address public LEND;
  address public BAT;
  address public ETH;
  address public LINK;
  address public KNC;
  address public REP;
  address public MKR;
  address public MANA;
  address public ZRX;
  address public SNX;
  address public WBTC;

  constructor() public {
    UNI = address(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);

    CDAI = address(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    CBAT = address(0x6C8c6b02E7b2BE14d4fA6022Dfd6d75921D90E4E);
    CETH = address(0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5);
    CREP = address(0x158079Ee67Fce2f58472A96584A73C7Ab9AC95c1);
    CSAI = address(0xF5DCe57282A584D2746FaF1593d3121Fcac444dC);
    CUSDC = address(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
    CWBTC = address(0xC11b1268C1A384e55C48c2391d8d480264A3A7F4);
    CZRX = address(0xB3319f5D18Bc0D84dD1b4825Dcde5d5f7266d407);

    IZRX = address(0xA7Eb2bc82df18013ecC2A6C533fc29446442EDEe);
    IREP = address(0xBd56E9477Fc6997609Cf45F84795eFbDAC642Ff1);
    IKNC = address(0x1cC9567EA2eB740824a45F8026cCF8e46973234D);
    IWBTC = address(0xBA9262578EFef8b3aFf7F60Cd629d6CC8859C8b5);
    IUSDC = address(0xF013406A0B1d544238083DF0B93ad0d2cBE0f65f);
    IETH = address(0x77f973FCaF871459aa58cd81881Ce453759281bC);
    ISAI = address(0x14094949152EDDBFcd073717200DA82fEd8dC960);
    IDAI = address(0x493C57C4763932315A328269E1ADaD09653B9081);
    ILINK = address(0x1D496da96caf6b518b133736beca85D5C4F9cBc5);
    ISUSD = address(0x49f4592E641820e928F9919Ef4aBd92a719B4b49);

    ADAI = address(0xfC1E690f61EFd961294b3e1Ce3313fBD8aa4f85d);
    ATUSD = address(0x4DA9b813057D04BAef4e5800E36083717b4a0341);
    AUSDC = address(0x9bA00D6856a4eDF4665BcA2C2309936572473B7E);
    AUSDT = address(0x71fc860F7D3A592A4a98740e39dB31d25db65ae8);
    ASUSD = address(0x625aE63000f46200499120B906716420bd059240);
    ALEND = address(0x7D2D3688Df45Ce7C552E19c27e007673da9204B8);
    ABAT = address(0xE1BA0FB44CCb0D11b80F92f4f8Ed94CA3fF51D00);
    AETH = address(0x3a3A65aAb0dd2A17E3F1947bA16138cd37d08c04);
    ALINK = address(0xA64BD6C70Cb9051F6A9ba1F163Fdc07E0DfB5F84);
    AKNC = address(0x9D91BE44C06d373a8a226E1f3b146956083803eB);
    AREP = address(0x71010A9D003445aC60C4e6A7017c1E89A477B438);
    AMKR = address(0x7deB5e830be29F91E298ba5FF1356BB7f8146998);
    AMANA = address(0x6FCE4A401B6B80ACe52baAefE4421Bd188e76F6f);
    AZRX = address(0x6Fb0855c404E09c47C3fBCA25f08d4E41f9F062f);
    ASNX = address(0x328C4c80BC7aCa0834Db37e6600A6c49E12Da4DE);
    AWBTC = address(0xFC4B8ED459e00e5400be803A9BB3954234FD50e3);

    DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    TUSD = address(0x0000000000085d4780B73119b644AE5ecd22b376);
    USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    USDT = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    SUSD = address(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);
    LEND = address(0x80fB784B7eD66730e8b1DBd9820aFD29931aab03);
    BAT = address(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
    ETH = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
    LINK = address(0x514910771AF9Ca656af840dff83E8264EcF986CA);
    KNC = address(0xdd974D5C2e2928deA5F71b9825b8b646686BD200);
    REP = address(0x1985365e9f78359a9B6AD760e32412f4a445E862);
    MKR = address(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2);
    MANA = address(0x0F5D2fB29fb7d3CFeE444a200298f468908cC942);
    ZRX = address(0xE41d2489571d322189246DaFA5ebDe1F4699F498);
    SNX = address(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F);
    WBTC = address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
  }

  function getCDAIUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(CDAI);
  }

  function getCBATUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(CBAT);
  }

  function getCETHUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(CETH);
  }

  function getCREPUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(CREP);
  }

  function getCSAIUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(CSAI);
  }

  function getCUSDCUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(CUSDC);
  }

  function getCWBTCUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(CWBTC);
  }

  function getCZRXUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(CZRX);
  }

  function getIZRXUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(IZRX);
  }

  function getIREPUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(IREP);
  }

  function getIKNCUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(IKNC);
  }

  function getIWBTCUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(IWBTC);
  }

  function getIUSDCUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(IUSDC);
  }

  function getIETHUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(IETH);
  }

  function getISAIUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(ISAI);
  }

  function getIDAIUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(IDAI);
  }

  function getILINKUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(ILINK);
  }

  function getISUSDUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(ISUSD);
  }

  function getADAIUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(ADAI);
  }

  function getATUSDUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(ATUSD);
  }

  function getAUSDCUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(AUSDC);
  }

  function getAUSDTUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(AUSDT);
  }

  function getASUSDUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(ASUSD);
  }

  function getALENDUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(ALEND);
  }

  function getABATUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(ABAT);
  }

  function getAETHUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(AETH);
  }

  function getALINKUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(ALINK);
  }

  function getAKNCUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(AKNC);
  }

  function getAREPUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(AREP);
  }

  function getAMKRUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(AMKR);
  }

  function getAMANAUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(AMANA);
  }

  function getAZRXUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(AZRX);
  }

  function getASNXUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(ASNX);
  }

  function getAWBTCUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(AWBTC);
  }

  function getDAIUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(DAI);
  }

  function getTUSDUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(TUSD);
  }

  function getUSDCUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(USDC);
  }

  function getUSDTUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(USDT);
  }

  function getSUSDUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(SUSD);
  }

  function getLENDUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(LEND);
  }

  function getBATUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(BAT);
  }

  function getETHUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(ETH);
  }

  function getLINKUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(LINK);
  }

  function getKNCUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(KNC);
  }

  function getREPUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(REP);
  }

  function getMKRUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(MKR);
  }

  function getMANAUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(MANA);
  }

  function getZRXUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(ZRX);
  }

  function getSNXUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(SNX);
  }

  function getWBTCUniROI() public view returns (uint256, uint256) {
    return calcUniswapROI(WBTC);
  }

  function calcUniswapROI(address token) public view returns (uint256, uint256) {
    IUniswapFactory factory = IUniswapFactory(UNI);
    IUniswapExchange exchange = IUniswapExchange(factory.getExchange(token));

    uint256 totalShares = exchange.totalSupply();
    uint256 ethBalance = address(exchange).balance;
    uint256 ret = 0;
    if (ethBalance > 10) {
      ret = ethBalance.mul(1000).div(totalShares);
    }
    return (ret, ethBalance);
  }

  // incase of half-way error
  function inCaseTokenGetsStuck(IERC20 _TokenAddress) public onlyOwner {
    uint256 qty = _TokenAddress.balanceOf(address(this));
    _TokenAddress.transfer(msg.sender, qty);
  }

  // incase of half-way error
  function inCaseETHGetsStuck() public onlyOwner {
    (bool result, ) = msg.sender.call{value: address(this).balance}("");
    require(result, "transfer of ETH failed");
  }
}
