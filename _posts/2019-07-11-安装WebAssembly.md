---
title: 安装 WebAssembly
description: 本节介绍如何设置工具链以及将 Rust 编译为 WebAssembly 并集成到 JavaScript 中。
categories:
  - rust/WebAssembly
tags: [rust, WebAssembly, 翻译]
---

# Rust 工具链

你需要安装标准的 Rust 工具链，包括 `rustup`, `rustc` 和 `cargo`。

[按照以下说明安装 Rust 工具链](https://www.rust-lang.org/tools/install)。

使用 Rust 和 WebAssembly 的最佳体验是使用 Rust 发布的稳定版。这意味着我们不需要任何实验版本。但是我们需要 Rust 1.30 及更高版本。

## `wasm-pack`
`wasm-pack` 是您构建、测试和发布 Rust 生成的 WebAssembly 的网站和商店。

[从这里获取`wasn-pack`](https://rustwasm.github.io/wasm-pack/installer/)

## `cargo-generate`

[`cargo-generate` 通过预先存在的 git 存储库作为模板，帮助您快速驱动并运行新的 Rust 项目。](https://github.com/ashleygwilliams/cargo-generate)

使用以下命令安装 `cargo-generate`

```hljs
cargo install cargo-generate
```

## `npm`

`npm` 是 JavaScript 的包管理器。我们将使用它来安装和运行 JavaScript 捆绑器和开发服务器。在本教程结束时，我们将编译的 `.wasm` 发布到 `npm` 注册表。

[按照以下说明按照 `npm`](https://www.npmjs.com/get-npm)

如果您已经安装了 npm，请确保它是最新版本的命令：

```hljs
npm install npm@latest -g
```

- [**目录**](/rust/webassembly/2019/08/22/WebAssembly之书目录)
- 下一篇:[**Hello,World!**](/rust/webassembly/2019/07/12/Hello,World/)
- 上一篇:[**教程:康威的生命游戏**](/rust/webassembly/2019/07/10/教程-康威的生命游戏/)

---

- via: [https://rustwasm.github.io/book/game-of-life/setup.html](https://rustwasm.github.io/book/game-of-life/setup.html)
- 译者: lkighy
- 校对: -
