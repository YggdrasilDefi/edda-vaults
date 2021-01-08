pragma solidity ^0.6.6;

interface IManagerLike {
  function cdpCan(
    address,
    uint256,
    address
  ) external view returns (uint256);

  function ilks(uint256) external view returns (bytes32);

  function owns(uint256) external view returns (address);

  function urns(uint256) external view returns (address);

  function vat() external view returns (address);

  function open(bytes32, address) external returns (uint256);

  function give(uint256, address) external;

  function cdpAllow(
    uint256,
    address,
    uint256
  ) external;

  function urnAllow(address, uint256) external;

  function frob(
    uint256,
    int256,
    int256
  ) external;

  function flux(
    uint256,
    address,
    uint256
  ) external;

  function move(
    uint256,
    address,
    uint256
  ) external;

  function exit(
    address,
    uint256,
    address,
    uint256
  ) external;

  function quit(uint256, address) external;

  function enter(address, uint256) external;

  function shift(uint256, uint256) external;
}
