---
title: 创建 rust 宏 macro_rules 宏入门
categories:
  - rust
tags: [rust]
---

> 文章中使用的一些宏介绍
> - `stringfiy!`: 对参数进行字符串化。
> 示例：
```rust
let one_plus_one = stringify!(1 + 1);
assert_eq!(one_plus_one, "1 + 1");
```

在 rust 中，可以使用 `macro_rules!` 来创建自己的宏。其语法如下：

```rust
macro_rules! macro_name {
    $rule0 ;
    $rule1 ;
    // ...
    $ruleN ;
}
```

使用 `macro_rules` 创建宏，要求您必须至少有一个规则，而每个 `$rule` 看起是这样的：

```rust
macro_rules! my_macro {
    // rule
    {$pattern} => ($expansion);
}
```

实际上，您可以使用括号和花括号随意组合,但是使用括号包裹 pattern 和 花括号包裹 expansion 是有传统的。

以下是最简单的示例,空模式：

```rust
macro_rules! four {
    () => {1 + 3};
}
```

只有当输入为空时(即 `four!()` `four![]` `four!{}`),会匹配该该规则。

## 匹配

解释器按词法顺序遍历每个规则，对于每个规则，都将尝试输入令牌树的内容，

解释器会按顺序逐个遍历规则，通过输入与 pattern 匹配则调用，否则将尝试下一个，如果所有规则都不匹配，则宏扩展将失败，并抛出错误。

## 捕获

通过某些语法规则进行匹配输入，将结果捕获到变量中，然后替换到输出中。

捕获内容以 `$` 符号开头，后面跟着标点符号 `:` ，最后是捕获类型，捕获类型必须是下列中的一个：

- `expr`: 表达式，例如：

```rust
macro_rules! expr_demo1 {
    ($e:expr) => {format!("hello, {}!", $e)};
}
println!("{}", expr_demo1!("Lucy")); // hello, Lucy!

macro_rules! expr_demo2 {
    ($e:expr) => {$e + 2};
}
println!("{}", expr_demo2!(2)); // 4
```

- `tt`: 单个令牌树, 例如

```rust
macro_rules! tt_demo {
    ($t1:tt + $t2:tt) => {$t1 * $t2};
}

println!("{}", tt_demo!(3 + 4)); // 12
```

- `ident`: 标识符, 例如

```rust
macro_rules! ident_demo {
    ($i:ident) => {format!("{:?}", $i!(#[inline]))};
}

println!("{}", ident_demo!(stringify)); // "# [inline]"
```

- `meta`: 元项目，`#[...]`, `#![...]` 属性中的内容, 例如

```rust
macro_rules! meta_demo {
    (#[$m:meta]) => {format!("{}", stringify!($m))};
}

println!("{}", meta_demo!(#[inline])); // inline
```

- `item`: 一个项目，如函数、结构、模块等
- `block`: 一个块(即由括号括起来的一段语句，包括 and/or 一个表达式)
- `stmt`: 声明
- `pat`: 模式
- `ty`: 类型
- `path`: 路径（例如: `foo`, `::std::mem::replace`, `transmute::<_, int>`, ...）

## 重复

模式可以重复。这允许匹配令牌序列。一般表达形式为 `$(...) sep rep`。

- `$` 
- `(...)` 重复的 paren 分组模式。
- `sep` 可选的分隔符，常见的示例是 `,` 和 `;`
- `rep` 必须的重复控件。目前可以是 `*` (表示零个或多个以上) 或 `+` (表示至少有一个)。不能写 "zero or one " 以及任何更具体计数或范围。

示例：

```rust
macro_rules! vec_strs {
    (
        // 开始 repetition:
        $(
            // 每个重复必须包含一个表达式
            $element:expr
        )
        // ...以逗号分隔...
        ,
        // ...零个或多个
        *
    ) => {
        // 将扩展扩在一个括号中，以便我们可以使用多个语句
        {
            let mut v = Vec::new();

            // 开始 repetition:
            $(
                // 每个 repeat 将包含以下语句，并用相应的表达式替换 $element
                v.push(format!("{}", $element));
            )*

            v
        }
    };
}

// 使用
println!("{:?}", vec_strs!(123,456,789, "abc")); // ["123", "456", "789", "abc"]
```



