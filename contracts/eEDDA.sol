pragma solidity ^0.5.16;

import "./eVault.sol";

contract eEDDA is eVault {
    constructor (address _token, address _controller) public eVault(_token, _controller) {}
}