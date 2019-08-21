---
title: 为什么是 Rust 和 WebAssembly？
description: JavaScript Web应用程序很难获得并保持可靠的性能。JavaScript 的动态类型系统和垃圾回收机制对保持可靠的性能没有任何帮助。如果您不小心徘徊在 JIT 的快乐道路上，看似微不足道的代码更改可能会导致严重的性能下降。
categories:
 - rust/WebAssembly
tags: [rust, WebAssembly, 翻译]
---

## 具有高级的人机工程学(Ergonomics)和低级控制(Control)

JavaScript Web应用程序很难获得并保持可靠的性能。JavaScript 的动态类型系统和垃圾回收机制对保持可靠的性能没有任何帮助。如果您不小心徘徊在 JIT 的快乐道路上，看似微不足道的代码更改可能会导致严重的性能下降。

Rust 为程序员提供了低级控制和可靠的性能。它不受 JavaScript 的非确定性垃圾回收的影响。程序员可以控制间接、单拟画和内存布局。

## 小巧的 `.wasm`

代码的多少非常重要，因为必须通过网络下载 `.wasm`。Rust 缺少一个运行时小巧的 `.wasm`，因为没有囊肿的垃圾回收器，您只需要为实际使用的功能支付相应的容量（代码的多少）。

## 不需要全部重写

不需要丢弃现有的代码库。您可以首先将对性能敏感的 JavaScript 函数移植到 Rust，以获得最好的收益。如果你愿意，你甚至可以在那里停下来。

## 与他人的愉快合作

Rust 和 WebAssembly 与现有的 JavaScript 工具集成。它支持 ECMAScript 模块，您可以继续使用您喜欢的工具，如 npm, webpack 和 Greenkeeper。

## 你期待的设施

Rust 拥有开发人员所期待的现代化设施：

- 强大的包管理工具 `cargo`,
- 富有表现了(和零成本) 的抽象,
- 和一个热情的社区!😊

---

- [**目录**](/rust/webassembly/2019/08/22/WebAssembly之书目录)
- 下一篇: [**什么是 WebAssembly?**](/rust/webassembly/2019/07/09/什么是WebAssembly/)
- 上一篇: [**Rust 🦀 和 WebAssembly 🕸**](/rust/webassembly/2019/07/07/rust-和-WebAssembly/)

---
- via: [https://rustwasm.github.io/book/why-rust-and-webassembly.html](https://rustwasm.github.io/book/why-rust-and-webassembly.html)
- 译者: lkighy
- 校对: -