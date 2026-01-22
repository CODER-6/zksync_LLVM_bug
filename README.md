# zkSync LLVM 编译器 Bug 复现项目

本项目用于复现 zkSync LLVM 编译器 bug（CVE-2024-45056）。

## 项目说明

- **分析文档**: 详细的 bug 分析请参阅 [zkSync-LLVM-Bug-分析.md](zkSync-LLVM-Bug-分析.md)
- **复现命令**: 复现所需的完整命令请参阅 [com.md](com.md)

这是一个影响 Aave V3 zkSync 部署的严重编译器漏洞，涉及位操作在编译过程中的错误优化。

---

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
