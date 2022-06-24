# Welcome to the Syndicate Developer Platform!

We've designed Collectives with special care to make our contracts modular and composable with custom implementations from the developer community.

We recommend that you start at our GitBook to learn more about the Collectives architecture and for guidance into manual contract interactions. Then, check out our open-sourced code here!

We'll be open-sourcing more contracts in the months ahead, but for now, we've included everything you need to get started building on top of our protocol:

- The interface for `ERC721Collective`: an indispensable guide to the manual contract interactions you can perform on your Collective. Every Module will call at least one kind of `ERC721Collective` token transaction; and almost every Module, Guard, or Renderer will make use of `ERC721Collective`'s `view` functions.
- Interfaces for Guards and Renderers: lists of the functions that your custom Guards and Renderers must implement, respectively
- Example contracts: basic implementations of a Module, a Guard, and a Renderer
