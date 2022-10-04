// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import {IGuard} from "./IGuard.sol";

/**
 * Interface containing signatures and documentation for all functions and
 * events in `ERC721Collective`.
 *
 * This interface enumerates each function directly instead of inheriting other
 * interfaces, allowing all definitions to be presented in one convenient file.
 */
interface IERC721Collective {
    event Initialized(uint8 version);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event ControlDisabled(address indexed controller);
    event BatcherUpdated(address batcher);
    event RendererUpdated(address indexed implementation);
    event RendererLocked();
    event GuardUpdated(GuardType indexed guard, address indexed implementation);
    event GuardLocked(
        bool mintGuardLocked,
        bool burnGuardLocked,
        bool transferGuardLocked
    );
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );
    event ControllerRedemption(
        address account,
        address indexed from,
        uint256 value
    );
    event ControllerTransfer(
        address controller,
        address indexed from,
        address indexed to,
        uint256 value
    );
    event TokenRecoveredERC20(
        address indexed recipient,
        address indexed erc20,
        uint256 amount
    );
    event TokenRecoveredERC721(
        address indexed recipient,
        address indexed erc721,
        uint256 tokenId
    );

    /**
     * Initializes `ERC721Collective`.
     *
     * Emits an `Initialized` event.
     *
     * @param name_ Name of token
     * @param symbol_ Symbol of token
     * @param mintGuard_ Address of mint guard
     * @param burnGuard_ Address of burn guard
     * @param transferGuard_ Address of transfer guard
     * @param renderer_ Address of renderer
     */
    // solhint-disable-next-line func-name-mixedcase
    function __ERC721Collective_init(
        string memory name_,
        string memory symbol_,
        address mintGuard_,
        address burnGuard_,
        address transferGuard_,
        address renderer_
    ) external;

    /**
     * @return ID of the first token that will be minted.
     */
    function STARTING_TOKEN_ID() external view returns (uint256);

    /**
     * Max consecutive tokenIds of bulk-minted tokens whose owner can be stored
     * as address(0). This number is capped to reduce the cost of owner lookup.
     */
    function OWNER_ID_STAGGER() external view returns (uint256);

    /**
     * @return True iff `interfaceId` matches the `IERC721Collective` interface.
     * @param interfaceId bytes4 ID of interface as defined in EIP-165
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    /**
     * @return owner The address of the token contract owner
     */
    function owner() external view returns (address);

    /**
     * @return The token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @return The token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @return Number of currently-existing tokens (tokens that have been
     * minted and that have not been burned).
     */
    function totalSupply() external view returns (uint256);

    /**
     * @return ID of the next token that will be minted. Existing tokens are
     * limited to IDs between `STARTING_TOKEN_ID` and `_nextTokenId` (including
     * `STARTING_TOKEN_ID` and excluding `_nextTokenId`, though not all of these
     * IDs may be in use if tokens have been burned).
     */
    function nextTokenId() external view returns (uint256);

    /**
     * @return True iff the token contract owner is allowed to mint, burn, or
     * transfer on behalf of arbitrary addresses.
     */
    function isControllable() external view returns (bool);

    /**
     * @return The address of the transaction batcher used to batch calls over
     * onlyOwner functions.
     */
    function batcher() external view returns (address);

    /**
     * @return The address of the token Renderer. The contract at this address
     * is assumed to implement the IRenderer interface.
     */
    function renderer() external view returns (address);

    /**
     * @return True iff the Renderer cannot be changed.
     */
    function rendererLocked() external view returns (bool);

    /**
     * @return The address of the Guard used to determine whether a mint is
     * allowed. The contract at this address is assumed to implement the IGuard
     * interface.
     */
    function mintGuard() external view returns (IGuard);

    /**
     * @return True iff the mint Guard cannot be changed.
     */
    function mintGuardLocked() external view returns (bool);

    /**
     * @return The address of the Guard used to determine whether a burn is
     * allowed. The contract at this address is assumed to implement the IGuard
     * interface.
     */
    function burnGuard() external view returns (IGuard);

    /**
     * @return True iff the burn Guard cannot be changed.
     */
    function burnGuardLocked() external view returns (bool);

    /**
     * @return The address of the Guard used to determine whether a transfer is
     * allowed. The contract at this address is assumed to implement the IGuard
     * interface.
     */
    function transferGuard() external view returns (IGuard);

    /**
     * @return True iff the transfer Guard cannot be changed.
     */
    function transferGuardLocked() external view returns (bool);

    /**
     * @return receiver Address that should receive royalties from sales.
     * @return royaltyAmount How much royalty that should be sent to `receiver`,
     * denominated in the same unit of exchange as `salePrice`.
     * @param tokenId The token being sold.
     * @param salePrice The sale price of the token, denominated in any unit of
     * exchange. The royalty amount will be denominated and should be paid in
     * that same unit of exchange.
     */
    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount);

    /**
     * @return The Uniform Resource Identifier (URI) for the token with
     * `tokenId`.
     * @param tokenId The token whose URI to retrieve.
     * @dev Function visibility is external rather than public (which is the
     * visibility of the OpenZeppelin implementation) as a gas optimization.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);

    /**
     * @return The owner of the `tokenId` token.
     *
     * Requirements:
     * - `tokenId` must exist.
     * @param tokenId The token whose owner to query.
     */
    function ownerOf(uint256 tokenId) external view returns (address);

    /**
     * @return The number of tokens in `owner`'s account.
     * @param owner The account whose balance to query.
     */
    function balanceOf(address owner) external view returns (uint256);

    /**
     * @return An address approved to spend the `tokenId` token (other than the
     * owner), if one exists.
     *
     * Requirements:
     * - `tokenId` must exist.
     * @param tokenId The token whose approvals to query.
     */
    function getApproved(uint256 tokenId) external view returns (address);

    /**
     * @return Whether `operator` is approved to spend any of `owner`'s tokens.
     * @param owner The account owning the tokens.
     * @param operator The account spending the tokens.
     */
    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);

    /**
     * @return True iff a token can be minted, burned, or transferred by a
     * particular operator, from a particular sender (`from` is address 0 iff
     * the token is being minted), to a particular recipient (`to` is address 0
     * iff the token is being burned).
     * @param operator Transaction msg.sender
     * @param from Token sender
     * @param to Token recipient
     * @param value Amount (ERC20) or token ID (ERC721)
     */
    function isAllowed(
        address operator,
        address from,
        address to,
        uint256 value // amount (ERC20) or tokenId (ERC721)
    ) external view returns (bool);

    /** Transfers ownership of the contract to a new account (`newOwner`)
     *
     * Emits an `OwnershipTransferred` event.
     *
     * Requirements:
     * - The caller must be the current owner.
     * @param newOwner Address that will become the owner
     */
    function transferOwnership(address newOwner) external;

    /**
     * Leaves the contract without an owner. After calling this function, it
     * will no longer be possible to call `onlyOwner` functions.
     *
     * Requirements:
     * - The caller must be the current owner.
     */
    function renounceOwnership() external;

    /**
     * Irreversibly disables the token contract owner from minting, burning,
     * and transferring on behalf of arbitrary addresses.
     *
     * Emits a `ControlDisabled` event.
     *
     * Requirements:
     * - The caller must be the token contract owner or the batcher.
     */
    function disableControl() external;

    /**
     * Update the address of the batcher for batching calls over
     * onlyOwner functions.
     *
     * Emits a `BatcherUpdated` event.
     *
     * Requirements:
     * - The caller must be the token contract owner or the batcher.
     * @param implementation Address of new batcher
     */
    function updateBatcher(address implementation) external;

    /**
     * Update the address of the token Renderer. The contract at the passed-in
     * address is assumed to implement the IRenderer interface.
     *
     * Emits a `RendererUpdated` event.
     *
     * Requirements:
     * - The caller must be the token contract owner or the batcher.
     * - Renderer must not be locked.
     * @param implementation Address of new Renderer
     */
    function updateRenderer(address implementation) external;

    /**
     * Irreversibly prevents the token contract owner from changing the token
     * Renderer.
     *
     * Emits a `RendererLocked` event.
     *
     * Requirements:
     * - The caller must be the token contract owner or the batcher.
     */
    function lockRenderer() external;

    /**
     * Update the address of the Guard for minting. The contract at the
     * passed-in address is assumed to implement the IGuard interface.
     *
     * Emits a `GuardUpdated` event with `GuardType.Mint`.
     *
     * Requirements:
     * - The caller must be the token contract owner or the batcher.
     * - The mint Guard must not be locked.
     * @param implementation Address of new mint Guard
     */
    function updateMintGuard(address implementation) external;

    /**
     * Update the address of the Guard for burning. The contract at the
     * passed-in address is assumed to implement the IGuard interface.
     *
     * Emits a `GuardUpdated` event with `GuardType.Burn`.
     *
     * Requirements:
     * - The caller must be the token contract owner or the batcher.
     * - The burn Guard must not be locked.
     * @param implementation Address of new burn Guard
     */
    function updateBurnGuard(address implementation) external;

    /**
     * Update the address of the Guard for transferring. The contract at the
     * passed-in address is assumed to implement the IGuard interface.
     *
     * Emits a `GuardUpdated` event with `GuardType.Transfer`.
     *
     * Requirements:
     * - The caller must be the token contract owner or the batcher.
     * - The transfer Guard must not be locked.
     * @param implementation Address of transfer Guard
     */
    function updateTransferGuard(address implementation) external;

    /**
     * Irreversibly prevents the token contract owner from changing the mint,
     * burn, and/or transfer Guards.
     *
     * If at least one guard was requested to be locked, emits a `GuardLocked`
     * event confirming whether each Guard is locked.
     *
     * Requirements:
     * - The caller must be the token contract owner or the batcher.
     * @param mintGuardLock If true, the mint Guard will be locked. If false,
     * does nothing to the mint Guard.
     * @param burnGuardLock If true, the mint Guard will be locked. If false,
     * does nothing to the burn Guard.
     * @param transferGuardLock If true, the mint Guard will be locked. If
     * false, does nothing to the transfer Guard.
     */
    function lockGuards(
        bool mintGuardLock,
        bool burnGuardLock,
        bool transferGuardLock
    ) external;

    /**
     * Gives permission to `to` to spend/transfer the `tokenId` token. The
     * approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero
     * address clears previous approvals.
     *
     * Emits an `Approval` event.
     *
     * Requirements:
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     * @param to The address to be approved to spend the token.
     * @param tokenId The token ID `to` will be approved to spend.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * Approves or removes `operator` as an operator for the caller. Operators
     * will be able to spend any token owned by the caller.
     *
     * Emits an `ApprovalForAll` event.
     *
     * Requirements:
     * - The `operator` cannot be the caller.
     * @param operator The account to give or revoke approval to spend any of
     * the caller's tokens.
     * @param approved True if `operator` is being given approval, false if
     * `operator`'s approval is to be revoked.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @return True after successfully executing mint and transfer of
     * `nextTokenId` to `account`.
     *
     * Emits a `Transfer` event with `address(0)` as `from`.
     *
     * Requirements:
     * - `account` cannot be the zero address.
     * @param account The account to receive the minted token.
     */
    function mintTo(address account) external returns (bool);

    /**
     * @return True after successfully bulk minting and transferring the
     * `nextTokenId` through `nextTokenId + amount` tokens to `account`.
     *
     * Emits a `Transfer` event (with `address(0)` as `from`) for each token
     * that is minted.
     *
     * Requirements:
     * - `account` cannot be the zero address.
     * @param account The account to receive the minted tokens.
     * @param amount The number of tokens to be minted.
     */
    function bulkMintToOneAddress(address account, uint256 amount)
        external
        returns (bool);

    /**
     * @return True after successfully bulk minting and transferring one of the
     * `nextTokenId` through `nextTokenId + accounts.length` tokens to each of
     * the addresses in `accounts`.
     *
     * Emits a `Transfer` event (with `address(0)` as `from`) for each token
     * that is minted.
     *
     * Requirements:
     * - `accounts` cannot have length 0.
     * - None of the addresses in `accounts` can be the zero address.
     * @param accounts The accounts to receive the minted tokens.
     */
    function bulkMintToNAddresses(address[] calldata accounts)
        external
        returns (bool);

    /**
     * @return True after successfully burning `tokenId`.
     *
     * Emits a `Transfer` event with `address(0)` as `to`.
     *
     * Requirements:
     * - The caller must either own or be approved to spend the `tokenId` token.
     * - `tokenId` must exist.
     * @param tokenId The tokenId to be burned.
     */
    function redeem(uint256 tokenId) external returns (bool);

    /**
     * Transfers the `tokenId` token from `from` to `to`.
     *
     * Emits a `Transfer` event.
     *
     * Requirements:
     * - The caller must own the token or be an approved operator.
     * - `from` must own `tokenId`.
     * - `to` cannot be the zero address.
     * @param from The account sending the token.
     * @param to The account to receive the token.
     * @param tokenId The tokenId to be transferred.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * See [`IERC721.safeTransferFrom`](https://docs.openzeppelin.com/contracts/3.x/api/token/erc721#ERC721-safeTransferFrom-address-address-uint256-)
     * @param from The account sending the token.
     * @param to The account to receive the token.
     * @param tokenId The tokenId to be transferred.
     * @dev This function is unused by Syndicate Protocol, but remains in this
     * fork for IERC721 compliance.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * See [`IERC721.safeTransferFrom`](https://docs.openzeppelin.com/contracts/3.x/api/token/erc721#ERC721-safeTransferFrom-address-address-uint256-bytes-)
     * @param from The account sending the token.
     * @param to The account to receive the token.
     * @param tokenId The tokenId to be transferred.
     * @param _data Optional bytes data to send along with the call.
     * @dev This function is unused by Syndicate Protocol, but remains in this
     * fork for IERC721 compliance.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) external;

    /**
     * Burns `tokenId` without checking whether the caller owns or is approved
     * to spend the token.
     *
     * Emits a `Transfer` event with `address(0)` as `to` AND a
     * `ControllerRedemption` event.
     *
     * Requirements:
     * - The caller must be the token contract owner or the batcher.
     * - `isControllable must be true.
     * - `tokenId` must exist.
     * - `tokenId` must be owned by `account`.
     * @param account The account whose token will be burned.
     * @param tokenId The tokenId to be burned.
     */
    function controllerRedeem(address account, uint256 tokenId) external;

    /**
     * Transfers `tokenId` token from `from` to `to`, without checking whether
     * the caller owns or is approved to spend the token.
     *
     * Emits a `Transfer` event AND a `ControllerTransfer` event.
     *
     * Requirements:
     * - The caller must be the token contract owner or the batcher.
     * - `isControllable` must be true.
     * - `tokenId` must exist.
     * - `from` must own `tokenId`.
     * - `to` cannot be the zero address.
     * @param from The account sending the token.
     * @param to The account to receive the token.
     * @param tokenId The tokenId to be transferred.
     */
    function controllerTransfer(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * Sets the default royalty fee percentage for the ERC721.
     *
     * A custom royalty fee will override the default if set for specific
     * `tokenId`s.
     *
     * Requirements:
     * - The caller must be the token contract owner.
     * - `isControllable` must be true.
     * @param receiver The account to receive the royalty.
     * @param feeNumerator The fee amount in basis points.
     */
    function setDefaultRoyalty(address receiver, uint96 feeNumerator) external;

    /**
     * Sets a custom royalty fee percentage for the specified `tokenId`.
     *
     * Requirements:
     * - The caller must be the token contract owner.
     * - `isControllable` must be true.
     * - `tokenId` must exist.
     * @param tokenId The tokenId to set a custom royalty for.
     * @param receiver The account to receive the royalty.
     * @param feeNumerator The fee amount in basis points.
     */
    function setTokenRoyalty(
        uint256 tokenId,
        address receiver,
        uint96 feeNumerator
    ) external;

    /**
     * Allows the owner of an ERC20Club or ERC721Collective to return
     * any ERC20 tokens erroneously sent to the contract.
     *
     * Emits a `TokenRecoveredERC20` event.
     *
     * Requirements:
     * - The caller must be the (Club or Collective) token contract owner.
     * @param recipient Address that erroneously sent the ERC20 token(s)
     * @param erc20 Erroneously-sent ERC20 token to recover
     * @param amount Amount to recover
     */
    function recoverERC20(
        address recipient,
        address erc20,
        uint256 amount
    ) external;

    /**
     * Allows the owner of an ERC20Club or ERC721Collective to return
     * any ERC721 tokens erroneously sent to the contract.
     *
     * Emits a `TokenRecoveredERC721` event.
     *
     * Requirements:
     * - The caller must be the (Club or Collective) token contract owner.
     * @param recipient Address that erroneously sent the ERC721 token
     * @param erc721 Erroneously-sent ERC721 token to recover
     * @param tokenId The tokenId to recover
     */
    function recoverERC721(
        address recipient,
        address erc721,
        uint256 tokenId
    ) external;
}

enum GuardType {
    Mint,
    Burn,
    Transfer
}
