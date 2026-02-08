# On-Chain Whitelist Manager

This repository provides an expert-level solution for managing access lists (whitelists) on the blockchain. Instead of storing every address in a costly array or mapping, this implementation uses **Merkle Proofs**, reducing gas costs to a near-constant regardless of the whitelist size.

### Features
* **Gas Efficiency:** Verify 10,000+ addresses for the same gas cost as verifying 10.
* **Security:** Proofs are generated off-chain and verified on-chain, preventing unauthorized access.
* **Flexibility:** Easily update the entire whitelist by simply changing the `merkleRoot`.

### Quick Start
1. Generate a Merkle Root from your list of addresses using a library like `merkletreejs`.
2. Deploy `Whitelist.sol` with the generated root.
3. Users provide their specific `bytes32[]` proof when calling the `claim` function.
