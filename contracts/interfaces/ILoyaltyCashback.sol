// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface ILoyaltyReferral {

    /// Add referrer profit
    /// @param _refererAddress address  Referrer address
    function addRefererProfit(address _refererAddress) external payable;
}
