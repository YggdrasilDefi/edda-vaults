// SPDX-License-Identifier: MIT

pragma solidity ^0.5.16;

interface IConverter {
    function convert(address) external returns (uint);
}
