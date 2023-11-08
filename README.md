# 🙂 Mood NFT - a fully onchain NFT

A dynamic (fully onchain) SVG NFT that updates in real-time when a function on the smart contract is called.

You can see this smart contract deployed [on Sepolia](https://sepolia.etherscan.io/address/0x1f7a035f4f7f1dd750c759e41d19f20290f6e4ff).

## ⚒️ Built with Foundry

This project is built with [Foundry](https://github.com/foundry-rs/foundry) a portable and modular toolkit for Ethereum application development, which is required to build and deploy the project.

## 🏗️ Getting started

Create a `.env` file with the following entries:

```
SEPOLIA_RPC_URL=<sepolia_rpc_url>
PRIVATE_KEY=<private_key>
ETHERSCAN_API_KEY=<etherscan_api_key>
```

Install project dependencies

```
make install
```

Deploy the smart contract on Anvil

```
make anvil
make deploy
```

Deploy the smart contract on Sepolia

```
make deploy ARGS="--network sepolia"
```

## 🧪 Running tests

To run against a local Anvil Ethereum node:

```
forge test
```

To run against a forked environment (e.g. a forked Sepolia testnet):

```
forge test --fork-url <sepolia_rpc_url>
```
