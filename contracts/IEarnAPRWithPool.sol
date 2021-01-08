pragma solidity ^0.6.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "../interfaces/IUniswapROI.sol";
import "../interfaces/IUniswapAPR.sol";
import "../interfaces/IAPRWithPoolOracle.sol";
import "../interfaces/IUniswapFactory.sol";
import "../interfaces/IYToken.sol";

contract IEarnAPRWithPool is Ownable {
  using SafeMath for uint256;
  using Address for address;

  mapping(address => uint256) public pools;
  mapping(address => address) public compound;
  mapping(address => address) public fulcrum;
  mapping(address => address) public aave;
  mapping(address => address) public aaveUni;
  mapping(address => uint256) public dydx;
  mapping(address => address) public yTokens;

  address public UNI;
  address public UNIROI;
  address public UNIAPR;
  address public APR;

  constructor() public {
    UNI = address(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);
    //// UNIROI = address(0xD04cA0Ae1cd8085438FDd8c22A76246F315c2687); //// TODO: set to OUR contract - UniswapROI
    //// UNIAPR = address(0x4c70D89A4681b2151F56Dc2c3FD751aBb9CE3D95); //// TODO: set to OUR contract - UniswapAPR
    //// Actual impl set here: https://etherscan.io/tx/0x03b13ee047a68dcb3e80a0259e011c4407878335923b01dd4db64ff4aad76505
    //// APR = address(0xAE8F37F0e8AD690486bFA2495113d7E94B7a7Ba6); //// TODO: set to OUR contract - APRWithPoolOracle

    //// Old:
    ////   addPool(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643, 9000629); //// cDAI
    //// New:
    ////   https://etherscan.io/tx/0x1b260d20c9d002ba7bc6b1612e35dc3657a37813dd474c11e495bc0ed6f05d7c
    addPool(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643, 0); //// cDAI
    addPool(0xF5DCe57282A584D2746FaF1593d3121Fcac444dC, 7723867); //// cSAI
    addPool(0x6B175474E89094C44Da98b954EedeAC495271d0F, 8939330); //// DAI
    addPool(0x0000000000085d4780B73119b644AE5ecd22b376, 7794100); //// TUSD
    addPool(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 6783192); //// USDC
    addPool(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51, 8623684); //// sUSD
    addPool(0x0D8775F648430679A709E98d2b0Cb6250d2887EF, 6660894); //// BAT
    addPool(0x514910771AF9Ca656af840dff83E8264EcF986CA, 6627987); //// LINK
    addPool(0xdd974D5C2e2928deA5F71b9825b8b646686BD200, 6627984); //// KNC
    addPool(0x1985365e9f78359a9B6AD760e32412f4a445E862, 6627994); //// REP
    addPool(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2, 6627956); //// MKR
    addPool(0xE41d2489571d322189246DaFA5ebDe1F4699F498, 6627972); //// ZRX
    addPool(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F, 8314762); //// SNX
    addPool(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, 7004537); //// WBTC

    addCToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643); //// cDAI
    addCToken(0x0D8775F648430679A709E98d2b0Cb6250d2887EF, 0x6C8c6b02E7b2BE14d4fA6022Dfd6d75921D90E4E); //// cBAT
    addCToken(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5); //// cETH
    addCToken(0x1985365e9f78359a9B6AD760e32412f4a445E862, 0x158079Ee67Fce2f58472A96584A73C7Ab9AC95c1); //// cREP
    addCToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 0x39AA39c021dfbaE8faC545936693aC917d5E7563); //// cUSDC
    addCToken(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, 0xC11b1268C1A384e55C48c2391d8d480264A3A7F4); //// cWBTC
    addCToken(0xE41d2489571d322189246DaFA5ebDe1F4699F498, 0xB3319f5D18Bc0D84dD1b4825Dcde5d5f7266d407); //// cZRX

    addAToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, 0x6B175474E89094C44Da98b954EedeAC495271d0F); //// aDAI
    addAToken(0x0000000000085d4780B73119b644AE5ecd22b376, 0x0000000000085d4780B73119b644AE5ecd22b376); //// aTUSD
    addAToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48); //// aUSDC
    addAToken(0xdAC17F958D2ee523a2206206994597C13D831ec7, 0xdAC17F958D2ee523a2206206994597C13D831ec7); //// aUSDT
    addAToken(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51, 0x57Ab1ec28D129707052df4dF418D58a2D46d5f51); //// aSUSD
    addAToken(0x80fB784B7eD66730e8b1DBd9820aFD29931aab03, 0x80fB784B7eD66730e8b1DBd9820aFD29931aab03); //// aLEND
    addAToken(0x0D8775F648430679A709E98d2b0Cb6250d2887EF, 0x0D8775F648430679A709E98d2b0Cb6250d2887EF); //// aBAT
    addAToken(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE); //// aETH
    addAToken(0x514910771AF9Ca656af840dff83E8264EcF986CA, 0x514910771AF9Ca656af840dff83E8264EcF986CA); //// aLINK
    addAToken(0xdd974D5C2e2928deA5F71b9825b8b646686BD200, 0xdd974D5C2e2928deA5F71b9825b8b646686BD200); //// aKNC
    addAToken(0x1985365e9f78359a9B6AD760e32412f4a445E862, 0x1985365e9f78359a9B6AD760e32412f4a445E862); //// aREP
    addAToken(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2, 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2); //// aMKR
    addAToken(0x0F5D2fB29fb7d3CFeE444a200298f468908cC942, 0x0F5D2fB29fb7d3CFeE444a200298f468908cC942); //// aMANA
    addAToken(0xE41d2489571d322189246DaFA5ebDe1F4699F498, 0xE41d2489571d322189246DaFA5ebDe1F4699F498); //// aZRX
    addAToken(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F, 0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F); //// aSNX
    addAToken(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599); //// aWBTC

    addAUniToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, 0xfC1E690f61EFd961294b3e1Ce3313fBD8aa4f85d); //// aDAI
    addAUniToken(0x0000000000085d4780B73119b644AE5ecd22b376, 0x4DA9b813057D04BAef4e5800E36083717b4a0341); //// aTUSD
    addAUniToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 0x9bA00D6856a4eDF4665BcA2C2309936572473B7E); //// aUSDC
    addAUniToken(0xdAC17F958D2ee523a2206206994597C13D831ec7, 0x71fc860F7D3A592A4a98740e39dB31d25db65ae8); //// aUSDT
    addAUniToken(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51, 0x625aE63000f46200499120B906716420bd059240); //// aSUSD
    addAUniToken(0x80fB784B7eD66730e8b1DBd9820aFD29931aab03, 0x7D2D3688Df45Ce7C552E19c27e007673da9204B8); //// aLEND
    addAUniToken(0x0D8775F648430679A709E98d2b0Cb6250d2887EF, 0xE1BA0FB44CCb0D11b80F92f4f8Ed94CA3fF51D00); //// aBAT
    addAUniToken(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, 0x3a3A65aAb0dd2A17E3F1947bA16138cd37d08c04); //// aETH
    addAUniToken(0x514910771AF9Ca656af840dff83E8264EcF986CA, 0xA64BD6C70Cb9051F6A9ba1F163Fdc07E0DfB5F84); //// aLINK
    addAUniToken(0xdd974D5C2e2928deA5F71b9825b8b646686BD200, 0x9D91BE44C06d373a8a226E1f3b146956083803eB); //// aKNC
    addAUniToken(0x1985365e9f78359a9B6AD760e32412f4a445E862, 0x71010A9D003445aC60C4e6A7017c1E89A477B438); //// aREP
    addAUniToken(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2, 0x7deB5e830be29F91E298ba5FF1356BB7f8146998); //// aMKR
    addAUniToken(0x0F5D2fB29fb7d3CFeE444a200298f468908cC942, 0x6FCE4A401B6B80ACe52baAefE4421Bd188e76F6f); //// aMANA
    addAUniToken(0xE41d2489571d322189246DaFA5ebDe1F4699F498, 0x6Fb0855c404E09c47C3fBCA25f08d4E41f9F062f); //// aZRX
    addAUniToken(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F, 0x328C4c80BC7aCa0834Db37e6600A6c49E12Da4DE); //// aSNX
    addAUniToken(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, 0xFC4B8ED459e00e5400be803A9BB3954234FD50e3); //// aWBTC

    addIToken(0xE41d2489571d322189246DaFA5ebDe1F4699F498, 0xA7Eb2bc82df18013ecC2A6C533fc29446442EDEe); //// iZRX
    addIToken(0x1985365e9f78359a9B6AD760e32412f4a445E862, 0xBd56E9477Fc6997609Cf45F84795eFbDAC642Ff1); //// iREP
    addIToken(0xdd974D5C2e2928deA5F71b9825b8b646686BD200, 0x1cC9567EA2eB740824a45F8026cCF8e46973234D); //// iKNC
    addIToken(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, 0xBA9262578EFef8b3aFf7F60Cd629d6CC8859C8b5); //// iWBTC
    addIToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 0xF013406A0B1d544238083DF0B93ad0d2cBE0f65f); //// iUSDC
    addIToken(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, 0x77f973FCaF871459aa58cd81881Ce453759281bC); //// iETH
    addIToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, 0x493C57C4763932315A328269E1ADaD09653B9081); //// iDAI
    addIToken(0x514910771AF9Ca656af840dff83E8264EcF986CA, 0x1D496da96caf6b518b133736beca85D5C4F9cBc5); //// iLINK
    addIToken(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51, 0x49f4592E641820e928F9919Ef4aBd92a719B4b49); //// iSUSD

    addDToken(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, 0); //// dETH
    addDToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 2); //// dUSDC
    addDToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, 3); //// dDAI

    addYToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, 0x9D25057e62939D3408406975aD75Ffe834DA4cDd); //// yDAI
    addYToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 0xa2609B2b43AC0F5EbE27deB944d2a399C201E3dA); //// yUSDC
    addYToken(0xdAC17F958D2ee523a2206206994597C13D831ec7, 0xa1787206d5b1bE0f432C4c4f96Dc4D1257A1Dd14); //// yUSDT
    addYToken(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51, 0x36324b8168f960A12a8fD01406C9C78143d41380); //// ySUSD
    addYToken(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, 0x04EF8121aD039ff41d10029c91EA1694432514e9); //// yWBTC

    //// New:
    ////   https://etherscan.io/tx/0x1f118e648461860d04280dcf85c325e6dc5c0357c175f12fca6359703d1de5b3
    addYToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, 0x16de59092dAE5CcF4A1E6439D611fd0653f0Bd01);
    ////   https://etherscan.io/tx/0xcd5f77007823e9ed117eff02e91db5bc4a803abdc324255e0dfc4a63c1f9a1d5
    addIToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, address(0));
    addIToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, address(0));
    ////   https://etherscan.io/tx/0x08cb6cd41b13a681ca24a9af32c3b19629af91a31a80a17adf6e413f59d1bfd5
    addIToken(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51, address(0));
    ////   https://etherscan.io/tx/0x77173065b0b95f469a42c8a3424214185ff070b9171e183949e72b66d26b658f    
    addIToken(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, address(0));
    ////   https://etherscan.io/tx/0xc68a90cf218be3bdc1308a1f8d36bccb73561eae7feb91e1b831389059a40a37
    addCToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, address(0));
    ////   https://etherscan.io/tx/0xc766528e6a63703202cd2ef2d804c581249d25f4815a828547b55872588f6007
    addCToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, address(0));
    ////   https://etherscan.io/tx/0xbc6e6511f3cc95b44e9ab53f4d147a53a907c89a2472ca4db5d28be22642e89c
    addCToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    ////   https://etherscan.io/tx/0xc9df1610ab16ec36731f796efeb92b46284706fface06016d46175ff6d5d6474
    addCToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 0x39AA39c021dfbaE8faC545936693aC917d5E7563);
    ////   https://etherscan.io/tx/0x72a59f4a82248cd178e20cfbb84a95151c491765555b3ac47bf665175d63b147
    addAToken(0x4Fabb145d64652a948d72533023f6E7A623C7C53, 0x4Fabb145d64652a948d72533023f6E7A623C7C53);
    ////   https://etherscan.io/tx/0xbc346d617eedeafe2ac19e7b9bf69c77b815e26ab1b4daf3f49ab434e31501ea
    addYToken(0x4Fabb145d64652a948d72533023f6E7A623C7C53, 0x04bC0Ab673d88aE9dbC9DA2380cB6B79C4BCa9aE);
    ////   https://etherscan.io/tx/0xe4825db0188628c4aac79987ede953777a7a5e2da351130026e559f01593ed2c
    addCToken(0xdAC17F958D2ee523a2206206994597C13D831ec7, 0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9);
    ////   https://etherscan.io/tx/0xff3948e83910ab80fe90ce5dfae2fe74df365117f771c1bed4b750f0fef8ceb2
    addCToken(0xdAC17F958D2ee523a2206206994597C13D831ec7, 0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9);
    ////   https://etherscan.io/tx/0x3a3c9332b88037c9a5cd2919a54a400eb4aa5661b5d95c2b65eecff1a71b3c23
    addCToken(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, address(0));
    ////   https://etherscan.io/tx/0x03e76473042f97e3e132c0d79772982319a90b214c04cebde949b3bd2ca46d40
    addCToken(0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9, address(0));
    ////   https://etherscan.io/tx/0xb89e2142981f1797c66992f23014d7f294e3ad966c0044193c2f7802b9d9be9d
    addCToken(0xdAC17F958D2ee523a2206206994597C13D831ec7, address(0));
    ////   https://etherscan.io/tx/0x7fb8994cef6bbc10fe6212e8b83a4156bc699b1dfdde427abe91708d35df8995
    addCToken(0x6B175474E89094C44Da98b954EedeAC495271d0F, address(0));
  }

  // Wrapper for legacy v1 token support
  function recommend(address _token)
    public
    view
    returns (
      string memory choice,
      uint256 capr,
      uint256 iapr,
      uint256 aapr,
      uint256 dapr
    )
  {
    (, capr, , iapr, , aapr, , dapr, , ) = getAPROptionsInc(_token);
    return (choice, capr, iapr, aapr, dapr);
  }

  function getAPROptionsInc(address _token)
    public
    view
    returns (
      uint256 _uniswap,
      uint256 _compound,
      uint256 _unicompound,
      uint256 _fulcrum,
      uint256 _unifulcrum,
      uint256 _aave,
      uint256 _uniaave,
      uint256 _dydx,
      uint256 _ddex,
      uint256 _lendf
    )
  {
    address yToken = yTokens[_token];
    uint256 _supply = 0;
    if (yToken != address(0)) {
      _supply = IYToken(yToken).calcPoolValueInToken();
    }
    return getAPROptionsAdjusted(_token, _supply);
  }

  function getAPROptions(address _token)
    public
    view
    returns (
      uint256 _uniswap,
      uint256 _compound,
      uint256 _unicompound,
      uint256 _fulcrum,
      uint256 _unifulcrum,
      uint256 _aave,
      uint256 _uniaave,
      uint256 _dydx,
      uint256 _ddex,
      uint256 _lendf
    )
  {
    return getAPROptionsAdjusted(_token, 0);
  }

  function getAPROptionsAdjusted(address _token, uint256 _supply)
    public
    view
    returns (
      uint256 _uniswap,
      uint256 _compound,
      uint256 _unicompound,
      uint256 _fulcrum,
      uint256 _unifulcrum,
      uint256 _aave,
      uint256 _uniaave,
      uint256 _dydx,
      uint256 _ddex,
      uint256 _lendf
    )
  {
    uint256 created = pools[_token];

    if (created > 0) {
      _uniswap = IUniswapAPR(UNIAPR).calcUniswapAPR(_token, created);
    }
    address addr = compound[_token];
    if (addr != address(0)) {
      _compound = IAPRWithPoolOracle(APR).getCompoundAPR(addr);
      created = pools[addr];
      if (created > 0) {
        _unicompound = IUniswapAPR(UNIAPR).calcUniswapAPR(addr, created);
      }
    }
    addr = fulcrum[_token];
    if (addr != address(0)) {
      _fulcrum = IAPRWithPoolOracle(APR).getFulcrumAPRAdjusted(addr, _supply);
      created = pools[addr];
      if (created > 0) {
        _unifulcrum = IUniswapAPR(UNIAPR).calcUniswapAPR(addr, created);
      }
    }
    addr = aave[_token];
    if (addr != address(0)) {
      _aave = IAPRWithPoolOracle(APR).getAaveAPRAdjusted(addr, _supply);
      addr = aaveUni[_token];
      created = pools[addr];
      if (created > 0) {
        _uniaave = IUniswapAPR(UNIAPR).calcUniswapAPR(addr, created);
      }
    }

    _dydx = dydx[_token];
    if (_dydx > 0 || _token == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)) {
      _dydx = IAPRWithPoolOracle(APR).getDyDxAPRAdjusted(_dydx, _supply);
    }

    _ddex = IAPRWithPoolOracle(APR).getDDEXAPRAdjusted(_token, _supply);
    _lendf = IAPRWithPoolOracle(APR).getLENDFAPRAdjusted(_token, _supply);

    return (_uniswap, _compound, _unicompound, _fulcrum, _unifulcrum, _aave, _uniaave, _dydx, _ddex, _lendf);
  }

  function viewPool(address _token)
    public
    view
    returns (
      address token,
      address unipool,
      uint256 created,
      string memory name,
      string memory symbol
    )
  {
    token = _token;
    unipool = IUniswapFactory(UNI).getExchange(_token);
    created = pools[_token];
    name = ERC20(_token).name();
    symbol = ERC20(_token).symbol();
    return (token, unipool, created, name, symbol);
  }

  function addPool(address token, uint256 created) public onlyOwner {
    pools[token] = created;
  }

  function addCToken(address token, address cToken) public onlyOwner {
    compound[token] = cToken;
  }

  function addIToken(address token, address iToken) public onlyOwner {
    fulcrum[token] = iToken;
  }

  function addAToken(address token, address aToken) public onlyOwner {
    aave[token] = aToken;
  }

  function addAUniToken(address token, address aToken) public onlyOwner {
    aaveUni[token] = aToken;
  }

  function addYToken(address token, address yToken) public onlyOwner {
    yTokens[token] = yToken;
  }

  function addDToken(address token, uint256 dToken) public onlyOwner {
    dydx[token] = dToken;
  }

  function set_new_UNIROI(address _new_UNIROI) public onlyOwner {
    UNIROI = _new_UNIROI;
  }

  function set_new_UNI(address _new_UNI) public onlyOwner {
    UNI = _new_UNI;
  }

  function set_new_UNIAPR(address _new_UNIAPR) public onlyOwner {
    UNIAPR = _new_UNIAPR;
  }

  function set_new_APR(address _new_APR) public onlyOwner {
    APR = _new_APR;
  }

  // incase of half-way error
  function inCaseTokenGetsStuck(IERC20 _TokenAddress) public onlyOwner {
    uint256 qty = _TokenAddress.balanceOf(address(this));
    _TokenAddress.transfer(msg.sender, qty);
  }

  // incase of half-way error
  function inCaseETHGetsStuck() public onlyOwner {
    (bool result, ) = msg.sender.call{value: (address(this).balance)}("");
    require(result, "transfer of ETH failed");
  }
}
