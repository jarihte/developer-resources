# Syndicate Protocol V2 - Open Source

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](./LICENSE)

**Welcome to the Syndicate Developer Platform!** We've designed Collectives with special care to make our contracts modular and composable with custom implementations from the developer community. This repository contains everything you need to get started building on top of our protocol. All of the contracts within are open-sourced under the [MIT License](./LICENSE).

## Getting Started

We recommend that you start at our GitBook to learn more about the Collectives architecture and for guidance on manual contract interactions. Then, check out our open-sourced code here!

## Contents

- The interface for `ERC721Collective`: an indispensable guide to the manual contract interactions you can perform on your Collective. Every Module will call at least one kind of `ERC721Collective` token transaction; and almost every Module, Guard, Guard Mixin, or Renderer will make use of `ERC721Collective`'s `view` functions.
- Interfaces for Guards, Guard Mixins, and Renderers: lists of the functions that your custom Guards, Guard Mixins, and Renderers must implement, respectively
- Example contracts: basic implementations of a Module, a Guard, and a Renderer

We will be open-sourcing more contracts in the months ahead!
