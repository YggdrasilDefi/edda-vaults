pragma solidity ^0.6.6;

interface IIEarnManager {
  function recommend(address _token)
    external
    view
    returns (
      string memory choice,
      uint256 capr,
      uint256 iapr,
      uint256 aapr,
      uint256 dapr
    );
}
