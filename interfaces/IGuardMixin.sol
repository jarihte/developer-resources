// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

/**
 * Interface for a Mixin expressing a modular requirement to be used by the
 * `GuardMixinManager`, determining whether a token can be minted, burned, or
 * transferred by a particular operator, from a particular sender (`from` is
 * address 0 iff the token is being minted), to a particular recipient (`to` is
 * address 0 iff the token is being burned).
 */
interface IGuardMixin {
    /**
     * @return True iff the transaction is allowed
     * @param token Address of the token being minted/burned/transferred
     * @param operator Transaction msg.sender
     * @param from Token sender
     * @param to Token recipient
     * @param value amount (ERC20) or tokenId (ERC721)
     */
    function isAllowed(
        address token,
        address operator,
        address from,
        address to,
        uint256 value // amount (ERC20) or tokenId (ERC721)
    ) external view returns (bool);
}
