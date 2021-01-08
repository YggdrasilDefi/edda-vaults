// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

interface IConverter {
  function convert(address) external returns (uint256);
}
