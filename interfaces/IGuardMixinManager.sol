// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import {IGuard} from "./IGuard.sol";

/**
 * Interface for `GuardMixinManager`, a Guard aggregating modular transaction
 * requirements ("Mixins").
 */
interface IGuardMixinManager is IGuard {
    event DefaultMixinsUpdated(address indexed token, address[] mixins);
    event ModuleDefaultMixinsUpdated(
        address indexed token,
        address indexed module,
        bool allowed
    );
    event ModuleCustomMixinsUpdated(
        address indexed token,
        address indexed module,
        address[] mixins
    );

    /**
     * @return Address of the Mixin in the `index` position of the list of
     * default Mixins for the token.
     * @param token Address of the token
     * @param index Index in the list of default Mixins
     * @dev The Solidity compiler generates an automatic getter for this
     * `address => address[]` mapping (token address => array of default Mixin
     * addresses) that takes the _index_ of the address array as a second
     * parameter. Use `defaultMixins[token]` to access the whole array of
     * default Mixin addresses.
     */
    function defaultMixins(address token, uint256 index)
        external
        view
        returns (address);

    /**
     * @return True iff the module is allowed for a given token AND subject to
     * default Mixins
     * @param token Address of the token
     * @param module Address of the module
     */
    function modulesDefaultMixins(address token, address module)
        external
        view
        returns (bool);

    /**
     * @return Address of the Mixin in the `index` position of the list of
     * Mixins applied to a particular module given a particular token
     * @param token Address of the token
     * @param module Address of the module
     * @param index Index in the list of Mixins applied to the module
     * @dev The Solidity compiler generates an automatic getter for this
     * `address => address => address[]` mapping (token address => module
     * address => array of Mixin addresses customized for that module) that
     * takes the _index_ of the address array as a third parameter. Use
     * `modulesCustomMixins[token][module]` to access the whole array of Mixin
     * addresses applied to the module.
     */
    function modulesCustomMixins(
        address token,
        address module,
        uint256 index
    ) external view returns (address);

    /**
     * @return An array of the addresses of the Mixins to be applied to
     * transactions of a particular token originating from a particular module.
     * If an empty array is returned, then the module is not allowed to call
     * transactions for that token.
     * @param token Address of the token
     * @param module Address of the module
     */
    function moduleRequirements(address token, address module)
        external
        view
        returns (address[] memory);

    /**
     * Updates whether a module is allowed to call transactions for a given
     * token, subject to the token's default Mixins.
     *
     * Emits a `ModuleDefaultMixinsUpdated` event iff a change was made.
     *
     * Requirements:
     * - The caller must be the token owner.
     * - The GuardMixinManager's settings must be unlocked.
     * @param token Address of the token
     * @param module Address of the module
     * @param allowed True if the module should be allowed to call token
     * transactions subject to the conditions in the token's default Mixins.
     * False if the module should not be allowed, or if the module should
     * instead be subject to the conditions of a custom list of Mixins.
     */
    function updateModule(
        address token,
        address module,
        bool allowed
    ) external;

    /**
     * Updates the list of Mixins expressing the conditions to be applied to any allowed module by default.
     *
     * Emits a `DefaultMixinsUpdated` event.
     *
     * Requirements:
     * - The caller must be the token owner.
     * - The GuardMixinManager's settings must be unlocked.
     * @param token Address of the token
     * @param mixins_ Array of addresses of the Mixins to be applied by
     * default. This replaces the current list of default Mixins (instead of
     * adding to it).
     */
    function updateDefaultMixins(address token, address[] calldata mixins_)
        external;

    /**
     * Updates the list of Mixins to apply to the specific module (instead of
     * the default Mixins).
     *
     * Emits a `ModuleCustomMixinsUpdated` event.
     *
     * Requirements:
     * - The caller must be the token owner.
     * - The GuardMixinManager's settings must be unlocked.
     * @param token Address of the token
     * @param module Address of the module
     * @param mixins_ Array of addresses of the Mixins to be applied to the
     * specific module (instead of the default mixins). This replaces the
     * current list of default Mixins (instead of adding to it). Passing in an
     * empty array will cause the module to use the default Mixins if
     * `modulesDefaultMixins` is true, or will disallow the module if
     * `modulesDefaultMixins` is false.
     */
    function updateModuleMixins(
        address token,
        address module,
        address[] calldata mixins_
    ) external;
}
