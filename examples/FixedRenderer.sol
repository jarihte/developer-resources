// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import {IRenderer} from "../interfaces/IRenderer.sol";
import {IERC721Collective} from "../interfaces/IERC721CollectiveFlat.sol";

/**
 * A renderer that returns the same token URI for all token IDs. This scheme is
 * useful when all instances of the Collective NFT have an identical visual
 * representation.
 */
contract FixedRenderer is IRenderer {
    // ERC721Collective => tokenURI
    mapping(address => string) private _uriOf;

    event TokenURIUpdated(address indexed collective, string uri);

    /**
     * Updates the URI for all tokenIds of a Collective.
     *
     * Requirements:
     * - The caller must be the Collective owner
     * @param collective Address of the Collective
     * @param uri New URI
     */
    function updateTokenURI(address collective, string memory uri) external {
        require(
            msg.sender == IERC721Collective(collective).owner(),
            "FixedRenderer: Must be collective owner"
        );
        _uriOf[collective] = uri;
        emit TokenURIUpdated(collective, uri);
    }

    /**
     * @return The URI of a particular Collective NFT
     * @param collective Address of the Collective
     * @dev This function is intended for use by the front end, e.g. to render
     * a given token from a given Collective.
     */
    function tokenURIOf(
        address collective,
        uint256 // tokenId
    ) external view returns (string memory) {
        return _uriOf[collective];
    }

    /**
     * @return The URI of a particular NFT from the calling Collective
     * @dev This function is intended for use in ERC721Collective itself:
     * `msg.sender` is assumed to be the Collective. This allows external
     * contracts to access the URI of any of the Collective's tokens.
     */
    function tokenURI(
        uint256 // tokenId
    ) external view returns (string memory) {
        return _uriOf[msg.sender]; // msg.sender is an ERC721Collective contract
    }
}
