---
title: Hello,World
description: 本节将向您展示如何构建和运行您的第一个 Rust WebAssembly 程序：一个警告 "Hello, World!" 的网页。
categories:
  - rust/WebAssembly
tags: [rust, WebAssembly, 翻译]
---

开始之前，请确保以按照[安装说明](/rust/webassembly/2019/07/11/安装WebAssembly/)进行操作。

## 克隆项目模板

这份项目模板预先配置好了默认值，因此您可以快速构建、集成、打包 web 代码。

使用以下命令克隆项目模板：

```hljs
cargo generate --git https://github.com/rustwasm/wasm-pack-template
```

这因该会提示您输入新项目的名称。我们将使用 `wasm-game-of-life`.

```hljs
wasm-game-of-life
```

## 项目结构

进入 `wasm-game-of-life` 项目

```hljs
cd wasm-game-of-life
```

让我们看看他的内容

```hljs
wasm-game-of-life/
├── Cargo.toml
├── LICENSE_APACHE
├── LICENSE_MIT
├── README.md
└── src
    ├── lib.rs
    └── utils.rs
```

让我们详细介绍这些文件

### `wasm-game-of-life/Cargo.toml`

`Cargo.toml` 文件指定货物的依赖关系和元数据，Rust 的包管理器和构建工具。这个预先配置了一个 `wasm-game-of-life` 依赖项，我们将在后面深入介绍一些可选的依赖项，并且正确初始化 `crate-type` 以生成 `.wasm` 库。

### `wasm-game-of-life/src/lib.rs`

`src/lib.rs` 文件是我们正在编译为 WebAssembly 的 Rust 包的根。它使用 `wasm-bindgen` 与 JavaScript 进行交互。它导入 `window.alert` JavaScript 函数，并导出 `greet` Rust 函数，该函数显示警告问候消息。

```rust
extern crate cfg_if;
extern crate wasm_bindgen;

mod utils;

use cfg_if::cfg_if;
use wasm_bindgen::prelude::*;

cfg_if! {
    // When the `wee_alloc` feature is enabled, use `wee_alloc` as the global
    // allocator.
    if #[cfg(feature = "wee_alloc")] {
        extern crate wee_alloc;
        #[global_allocator]
        static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;
    }
}

#[wasm_bindgen]
extern {
    fn alert(s: &str);
}

#[wasm_bindgen]
pub fn greet() {
    alert("Hello, wasm-game-of-life!");
}
```

### `wasm-game-of-life/src/utils.rs`

`src/utils.rs` 模块提供了常用的实用程序，使得使用 Rust 编译成 WebAssembly 更容易。我们将在本教程查看调试我们的`wasm` 代码时，会更详细地介绍这些使用程序，现在我们可以忽略此文件。

## 建立项目

我们使用 `wasm-pack` 来编译一下构建步骤：

- 确保我们有 Rust 1.30 或更高版本，并且通过 rustup 安装了 `wasm32-unknown-unknown` ,
- 通过 `cargo` 将我们的 Rust 源代码编译成 WebAssembly `.wasm` 项目。
- 使用 `wasm-bindgen` 生成 Javascript API 以使用我们的 Rust 生成的 WebAssembly.

要完成这些，请在项目目录运行此命令:

```hljs
wasm-pack build
```

构建完成后，我们可以在 `pkg` 目录中找到它的文件，它应该包含以下内容：

```hljs
pkg/
├── package.json
├── README.md
├── wasm_game_of_life_bg.wasm
├── wasm_game_of_life.d.ts
└── wasm_game_of_life.js
```

`README.md` 文件是从主项目复制的，但其他文件是新创建的。

### `wasm-game-of-life/pkg/wasm_game_of_life_bg.wasm`

`.wasm` 文件时由 Rust 编译器从 Rust 源码生成的 WebAssembly 二进制文件。它将所有所有 Rust 函数和数据编译成的 `wasm` 版本。例如，它具有 "greet" 功能。

### `wasm-game-of-life/pkg/wasm-game-of-life.js

`.js` 文件是由 `wasm-bindgen` 生成的，包含 JavaScript 粘合剂，用于将 DOM 和 JavaScript 函数导入 Rust 并向 WebAssembly 函数公开一个很好的 APU 到 JavaScript。 例如，有一个 JavaScript `greet` 函数，它包装从 WebAssembly 模块导出的 `greet` 函数，现在这种粘合剂并没有太多作用，但是当我们开始在 wasm 和 JavaScript 之间来回传递更多值时，它将有助于这些值传递到边界。

```javaScript
import * as wasm from './wasm_game_of_life_bg';

// ...

export function greet() {
    return wasm.greet();
}

```

### `wasm-game-of-life/pkg/wasm_game_of_life.d.ts`

`.d.ts` 文件包含 JavaScript glue 的 TypeScript 类型声明，如果您使用的是 TypeScript，则可以选中对 WebAssembly
函数类型的调用，并且您的 IDE 可以提供自动完成和建议！ 如果您不使用 TypeScript，则可以忽略此文件。

```hljs
export function greet(): void;
```

### `wasm-game-of-life/pkg/package.json`

[`package.json` 文件包含有关生成的 JavaScript 和 WebAssembly 包的元数据。](https://docs.npmjs.com/files/package.json) npm 和 JavaScript 捆绑包使用它来确定包、包名、版本和一堆其他东西之间的依赖关系。它帮助我们与 JavaScript 工具集成，并允许我们将我们的包发布到 npm。

```json
{
  "name": "wasm-game-of-life",
  "collaborators": [
    "Your Name <your.email@example.com>"
  ],
  "description": null,
  "version": "0.1.0",
  "license": null,
  "repository": null,
  "files": [
    "wasm_game_of_life_bg.wasm",
    "wasm_game_of_life.d.ts"
  ],
  "main": "wasm_game_of_life.js",
  "types": "wasm_game_of_life.d.ts"
}
```

## 将它放入网页

要获取我们的 `wasm-game-of-life` 包并在网页中使用它，我们使用 [`create-wasm-app` JavaScript 项目模板](https://github.com/rustwasm/create-wasm-app)。

在 `wasm-game-of-life` 目录中运行此命令:

```hljs
npm init wasm-app www
```

这是我们新的 `wasm-game-of-life/www` 子目录包含的内容:

```hljs
wasm-game-of-life/www/
├── bootstrap.js
├── index.html
├── index.js
├── LICENSE-APACHE
├── LICENSE-MIT
├── package.json
├── README.md
└── webpack.config.js
```

再一次，让我们仔细看看其中的一些文件。

### `wasm-game-of-life/www/package.json`

这个 `package.json` 预先配置了 `webpack` 和 `webpack-dev-server` 依赖项，以及对 `hello-wasm-pack` 的依赖，`hello-wasm-pack` 是已发布到 npm 的初始 `wasm-pack-template` 包的一个版本。

### `wasm-game-of-life/www/webpack.config.js`

此文件配置 webpack 及器本低开发服务器。他是预配置的，您根本不需要调整它已使用 webpack 以及本低开发服务器正常工作。

### `wasm-game-of-life/www/index.html`

这是网页的根 HTML 文件。它除了加载 bootstrap.js 之外没什么用处，它是 index.js 的一个非常薄弱的包装器。

```HTML
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Hello wasm-pack!</title>
  </head>
  <body>
    <script src="./bootstrap.js"></script>
  </body>
</html>
```

### `wasm-game-of-life/www/index.js`

`index.js` 是我们网页 JavaScript 的主要入口点。它导入了 `hello-wasm-pack` npm 包，包博涵默认的 `wasm-pack-template` 编译 WebAssembly 和 JavaScript 的粘合剂，然后调用 `hello-wasm-pack` 的 greet 函数.

```js
import * as wasm from "hello-wasm-pack";

wasm.greet();
```

## 安装依赖项

首先，通过在 `wasm-game-of-life/www` 子目录中运行 `npm install` 来确保安装本低开发服务器及其依赖项:

```hljs
npm install
```

此命令只需要运行一次，并将安装 `webpack` JavaScript bundler 及其开发服务器。

> 注意， 使用 Rust 和 WebAssembly 不需要 webpack, 它只是我们为方便起见而选择的 bundler 和开发服务器，Parcel 和 Rollup 还应该支持将 WebAssembly 导入为 ECMAscript 模块。如果您愿意，也可在没有捆绑器的情况下使用 Rust 和 WebAssembly!

## 在 `www` 中使用 我们本地的 `wasm-game-of-life` 包

我们希望使用本地的 `wasm-game-of-life` 软件包，而不是使用来自 npm 的 `hello-wasm-pack` 软件包。浙江使我们能够逐步发展我们的 wasm-game-of-life` 计划。

打开 `wasm-game-of-life/www/package.json` 并编辑 `"dependencies"` 以包含 `"wasm-game-of-life":"file:../pkg` 条目:

```javaScript
    // ...
    "dependencies": {
        "wasm-game-of-life":"file:../pkg", // add this line!
        // ...
    }
```

接下来，修改 `wasm-game-of-life/www/index.js` 以导入 `wasm-game-of-life` 而不是 `hello-wasm-pack` 包:

```javaScript
import * as wasm from "wasm-game-of-life";

wasm.greet();
```

由我们声明一个新的依赖项，我们需要安装它：

```hljs
npm install
```

我们的网页现在已准备好在本地提供了！

## 本地服务

接下来，打开开发服务器的新终端。在新终端运行服务器让它在后台运行，并且不会阻止我们在此起见运行去其他命令。在新终端中，从 `wasm-game-of-life/www` 目录中运行此命令:

```hljs
npm run start
```

在浏览器导航到 http://localhost:8080/ 您将看到一条警告信息:

![hello-world](../images/hello-world.png)

无论何时进行更改并希望他们反映在 [http://localhost:8080/](http://localhost:8080/), 只需要在 `wasm-game-of-life` 目录中运行 `wasm-pack build` 命令。

## 练习

- 修改 `wasm-game-of-life/src/lib.rs` 中的greet 函数，取一个 `name: &str` 参数，自定义一个 alerted 消息，并将你的名字传递给来自 `wasm-game-of life/www/index.js`。使用 `wasm-pack` 重新构建 `.wasm` 二进制文件，然后在 Web 浏览器中刷新 http://localhost:8080/ ,您应该看到自定义问候语！

<details>
<summary>回答</summary>

该 `greet` 功能的新版本 `wasm-game-of-life/src/lib.rs` :

```rust

#![allow(unused_variables)]
fn main() {
#[wasm_bindgen]
pub fn greet(name: &str) {
    alert(&format!("Hello, {}!", name));
}
}
```

新调用 `greet` 的 `wasm-game-of-life/www/index.js`:

```hljs
wasm.greet("Your Name");
```

</details>

- 下一篇:[**康威生命游戏的游戏规则**](/)
- 上一篇:[**安装 WebAssembly**](/rust/webassembly/2019/07/11/安装WebAssembly/)
- 如果您还读过该系列文章,建议您从[**Rust 🦀 和 WebAssembly 🕸**](/rust/webassembly/2019/07/07/rust-和-WebAsembly/)开始阅读

---

- via: [https://rustwasm.github.io/book/game-of-life/introduction.html](https://rustwasm.github.io/book/game-of-life/introduction.html)
- 作者: -
- 译者: lkighy
- 校对: -
