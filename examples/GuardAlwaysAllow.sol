// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.15;

import {IGuard} from "../interfaces/IGuard.sol";

/**
 * A guard that allows all (mint, burn, or transfer) requests.
 */
contract GuardAlwaysAllow is IGuard {
    function isAllowed(
        address, // operator
        address, // from
        address, // to
        uint256 // amount or tokenId
    ) external pure returns (bool) {
        return true;
    }
}
