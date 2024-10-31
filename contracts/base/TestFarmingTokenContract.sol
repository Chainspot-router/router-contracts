// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IVaultToken} from "../interfaces/IVaultToken.sol";
import {ERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestFarmingTokenContract is IVaultToken, ERC20 {

    IERC20 public stakeToken;

    constructor(IERC20 _stakeToken) ERC20("TestFarmingToken", "TFT") {
        stakeToken = _stakeToken;
    }

    receive() external payable {}
    fallback() external payable {}

    function _getPricePerFullShare() internal pure returns (uint256) {
        return 1;
    }

    function getPricePerFullShare() external pure returns (uint256) {
        return _getPricePerFullShare();
    }

    function _deposit(uint _value) internal {
        address fromAddress = msg.sender;
        address selfAddress = address(this);

        uint allowAmount = stakeToken.allowance(fromAddress, selfAddress);
        require(allowAmount >= _value, "ERR901");
        require(stakeToken.transferFrom(fromAddress, selfAddress, _value), "ERR902");
        _mint(fromAddress, _value * _getPricePerFullShare());
    }

    function deposit(uint _value) external {
        _deposit(_value);
    }

    function depositAll() external {
        _deposit(stakeToken.allowance(msg.sender, address(this)));
    }

    function _withdraw(uint _value) internal {
        address fromAddress = msg.sender;
        address selfAddress = address(this);

        _burn(fromAddress, _value);
        require(stakeToken.transferFrom(selfAddress, fromAddress, _value * _getPricePerFullShare()), "ERR903");
    }

    function withdraw(uint _value) external {
        _withdraw(_value);
    }

    function withdrawAll() external {
        _withdraw(this.balanceOf(msg.sender));
    }

    function balance() external view returns (uint256) {
        return this.balanceOf(msg.sender);
    }

    function want() external view returns (IERC20) {
        return this;
    }

    function upgradeStrat() external pure {
        return;
    }
}