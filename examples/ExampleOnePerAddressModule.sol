// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.9;

import {IERC721Collective} from "../interfaces/IERC721CollectiveFlat.sol";

/**
 * An example module that allows every address to mint one ERC721Collective
 * token per Collective.
 */
contract ExampleOnePerAddressModule {
    // ERC721Collective => max tokens mintable by this module
    mapping(address => uint256) public publicSupply;
    // ERC721Collective => account => minted
    mapping(address => mapping(address => bool)) public hasMinted;

    event PublicSupplyUpdated(address indexed collective, uint256 amount);
    event Minted(address indexed collective, address indexed account);

    /**
     * Updates the max number of Collective NFTs that _this module_ will
     * respect for a given Collective.
     *
     * Requirements:
     * - The caller must be the Collective owner
     * @param collective Address of the Collective
     * @param amount New public supply
     * @dev This limitation restricts _this module_ from causing the
     * `ERC721Collective`'s `totalSupply` (accounting for tokens minted by _any_
     * module) to exceed `publicSupply`. Mints from other modules could mean
     * that fewer than `publicSupply` tokens can be minted from this module.
     */
    function updatePublicSupply(address collective, uint256 amount)
        external
    {
        require(
            msg.sender == IERC721Collective(collective).owner(),
            "ExampleOnePerAddressModule: Must be collective owner"
        );

        publicSupply[collective] = amount;
        emit PublicSupplyUpdated(collective, amount);
    }

    /**
     * @return True after successfully executing mint of a given Collective NFT.
     *
     * Emits a `Minted` event.
     *
     * Requirements:
     * - The caller cannot have already minted this Collective NFT
     * - The total supply of the Collective NFT cannot have already reached
     *   `publicSupply`
     * - `account` cannot be the zero address (from `ERC721Collective.mintTo`).
     * @param collective Address of the Collective
     */
    function mint(address collective) external returns (bool) {
        require(
            !hasMinted[collective][msg.sender],
            "ExampleOnePerAddressModule: Address has already minted"
        );
        require(
            IERC721Collective(collective).totalSupply() <
                publicSupply[collective],
            "ExampleOnePerAddressModule: Public supply reached"
        );

        hasMinted[collective][msg.sender] = true;
        IERC721Collective(collective).mintTo(msg.sender);
        emit Minted(collective, msg.sender);
        return true;
    }

    /**
     * This function is called for all messages sent to this contract (there
     * are no other functions). Sending Ether to this contract will cause an
     * exception, because the fallback function does not have the `payable`
     * modifier.
     * Source: https://docs.soliditylang.org/en/v0.8.9/contracts.html?highlight=fallback#fallback-function
     */
    fallback() external {
        revert("ExampleOnePerAddressModule: non-existent function");
    }
}
