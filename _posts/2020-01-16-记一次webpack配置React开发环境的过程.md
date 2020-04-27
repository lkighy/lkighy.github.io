# 记一次 webpack 配置 React 开发环境的过程

## 初始化
> npm init

## 安装 webpack
> npm i webpack webpack-dev-server webpack-cli --save

## 可选安装 'html-webpack-plugin'
'html-webpack-plugin' 作用是自动导入 js 文件，而不用手动去引入
> npm i html-webpack-plugin

## 配置 webpack 配置文件
在项目根目录下创建 'webpack.config.js' 文件
写入如下内容
`webpack.config.js`
```js
const path = require("path")
// html-webpack-plugin 组件为可选导入,导入这个组件,可以不需要 再index.html 文件中再导入 main.js 文件,webpack 会自动生成打包 进文件中,需要 npm i html-webpack-plugin --save 命令进行安装
const htmlWebpackPlugin = require("html-webpack-plugin")

module.exports = {
  // 设置入口文件
  entry: path.join(__dirname, "./src/main.js"),
  // 设置输出文件
  output: {
    path: path.join(__dirname, "./dist"),
    filename: "bundle.js"
  },
  // 配置插件
  plugins: [
    // 创建刚刚导入的插件
    new htmlWebpackPlugin({
      // 模板文件
      template: path.join(__dirname, "./src/index.html"),
      // 输出文件
      filename: "index.html"
    })
  ]
}
```

## 创建入口文件
1. 在根目录下创建 `src` 文件夹
2. 在 `src` 文件夹下创建 `index.html` 文件和 `main.js` 文件
在 `src/index.html` 文件中写入如下内容
`src/index.html`

```html
<!DOCTYPE html>
<html lang="zh-cn">
<head>
  <meta charset="UTF-8">
  <title>Title</title>
</head>
<body>
  <div id="root"></div>
</body>
</html>
```

在 `src/main.js` 文件中写入如下内容
`src/main.js`

```js
let root = document.querySelector('#root')
root.textContent = "Hello, world!"
```

## 配置 `package.json`, 添加启动命令
在 `package.json` 下的 `scripts` 字段中添加如下内容
 
复制时请把 `//` 内的内容删除，

```json
"scripts": { 
    // ...
    // webpack-dev-server 中的部分选项 
    // --open 默认启动时打开浏览器, 
    // --hot 热更新
    // --port 3000 设置端口为 3000 
    // --contentBase src 设置浏览器默认打开 src 目录 如果没有 使用 html-webpack-plugin 选项则可以设置这个选项
    "dev": "webpack-dev-server --open --hot"
}
// ...
```

这时候在终端运行 npm run dev，会打开默认浏览器，显示 hello, world.

基础的 webpack 开发环境配置完成，接下来配置 React 的环境。

## 安装 React
> npm i react react-dom --save-dev

## 安装和配置 babel 
> npm i --save-dev @babel/core @babel/cli @babel/preset-env babel-preset-react
