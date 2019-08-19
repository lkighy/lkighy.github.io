---
title: 什么是 WebAssembly?
description: WebAssembly(wasm) 是一种简单的机器模型和可执行格式，具有广泛的规范，它设计为便携、紧凑，并以原生速度或接近原生速度执行.
categories:
  - rust/WebAssembly
tags: [rust, WebAssembly, 翻译]
---


WebAssembly(wasm) 是一种简单的机器模型和可执行格式，具有广泛的规范[(extensive specification)](https://webassembly.github.io/spec/)，它设计为便携、紧凑，并以原生速度或接近原生速度执行。

作为一种编程语言，WebAssembly 由两种相同结构的格式组成，尽管方式不同：
1. `.wat` 文本格式(称为"WebAssembly Text" 的 wat) 使用 [S-expressions](https://en.wikipedia.org/wiki/S-expression)，并且与 Lisp 语言系列（如 Scheme 和 Clojure）有一些相似之处。
2. `.wasm`二进制格式是比较低级别的，旨在有 wasm虚拟机直接使用。它在概念上类似于 ELF 和 Mach-O。

作为参考，这是 `wat` 中的阶乘函数：

```
(module
  (func $fac (param f64) (result f64)
    get_local 0
    f64.const 1
    f64.lt
    if (result f64)
      f64.const 1
    else
      get_local 0
      get_local 0
      f64.const 1
      f64.sub
      call $fac
      f64.mul
    end)
  (export "fac" (func $fac)))
```

如果您对 `wasm` 文件的外观感兴趣，可以使用这代码 [wat2wasm dome 演示](https://webassembly.github.io/wabt/demo/wat2wasm/)。

## 线性存储(Linear Memory)

WebAssembly 有一个非常简单的[内存模型](https://webassembly.github.io/spec/core/syntax/modules.html#syntax-mem). wasm模块可以访问单个 "线性内存", 它本质上是一个平面字节数组.此[内存可以以页(64K)大小的倍数增长](https://webassembly.github.io/spec/core/syntax/instructions.html#syntax-instr-memory),但不能收缩.

## WebAssembly 仅适用于 Web 吗?

虽然它目前在 JavaScript 和 Web 社区中收到了广泛的关注,但 wasm 并没有对其主机环境做出臆断.因此推测 wasm 在未来将在各种环境中使用 "轻便可移植"的可能性是存在的.然而到目前为止, wasm 主要与 JavaScript(JS) 关联,JavaScript 有很多特点(包括 Web 和 Node.js).

- 下一篇:[**教程:康威的生命游戏**](/)
- 上一篇:[**为什么是Rust 和 WebAssembly**](https://lkighy.github.io/rust/webassembly/2019/07/08/为什么是Rust和WebAssmbly/)

---
- via: [https://rustwasm.github.io/book/what-is-webassembly.html](https://rustwasm.github.io/book/what-is-webassembly.html)
- 作者: -
- 译者: lkighy
- 校对: -
