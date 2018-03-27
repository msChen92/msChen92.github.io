title: webpack
---
# webpack

## webpack的优点
- 虽然webpack的工作模式有点“怪异”，但它的配置功能和扩展能力非常出众，而且相比fis，webpack更专注于构建本身，开发者有很大的空间去改造和扩展；

- 与前端的新技术高度融合，比如Vue、React、Angular（这些框架也是组件化的典范，与webpack的理念有共通点）等，并且与-之对应的loader或plugin是官方或者框架作者推出的，并非“来路不明”的第三方提供；

- 生命周期非常优雅，compiler和compilation拥有各自的生命周期，并且几乎每个阶段都暴露了钩子函数，非常利用扩展；
社区力量庞大。这意味着遇到问题时，能够得到更多人的意见和帮助。这一点来讲，fis与webpack的社区力量不是一个量级的。

---

## webpcak转译出的文件过大怎么办

- 配置全局变量:告诉webpcak我们处于production环境中

```
//指定环境，将process.env.NODE_ENV环境与library关联
 new Webpack.DefinePlugin({
    'process.env.NODE_ENV': JSON.stringify('production'),
 }),
```

- 优化devtool中的source-map：source-map在开发阶段确实很好用，调试起来很方便，但是在生产环境下就没必要部署了。 

- 剥离css文件，单独打包
 	+ 安装webpack插件extract-text-webpack-plugin。 npm install extract-text-webpack-plugin --save-dev。 
 	+ 这里使用了contenthash，webpack会根据内容去生成hash值。
```
plugins:[
   new ExtractTextPlugin('static/css/styles.[contenthash].css'),
  ]
```


- 使用UglifyJSPlugin压缩
- 提取公共依赖
	 + 使用CommonsChunkPlugin插件，将多个js文件进行提取，建立一个独立的文件。这个文件包含一些共用模块，浏这样览器只在刚开始的时候加载一次，便缓存起来供后续使用。而不用每次访问一个新界面时，再去加载一个更大的文件。
- 开启gzip压缩
- 开启html压缩，自动添加上面生成的静态资源

---
## webpack转译速度慢什么办？
- 使用webpack --watch
- 配置externals:忽略文件不打包
```
externals: 
    {
      'antd':true,
      'react': 'React',
      'react-dom': 'ReactDOM'
    }
 ```
 	+ 配置externals的缺陷:总而言之，问题是这样产生的：
		* Webpack 发现我们依赖了 react-addons-css-transition-group
		* Webpack 去打包 react-addons-css-transition-group 的时候发现它依赖了 react 模块下的一个叫 ReactTransitionGroup.js 的文件，于是 Webpack 去打包这个文件。
		* ReactTransitionGroup.js 依赖了整个 react 的入口文件 React.js，虽然我们设置了 externals ，但是 Webpack 不知道这个入口文件等效于 react 模块本身，于是我们可爱又敬业的 Webpack 就把整个 react 又重新打包了一遍。
- 将那些共有的模块打进另外一个文件中，然后使用CommonsChunkPlugin插件，在webpack –watch非第一编打包的时候就不会重复的打另外一个文件了。

---

## webpack loader
- 能够对加载的资源文件，进行一些处理。比如把less、sass文件编译成css文件，负责这个处理过程的，就是webpack的loader。

 + vue-loader 处理vue组件
 + less-loader 处理编译less
 + html-loader 加载html文件并打包内链的静态文件

- loader的本质是接收字符串(或者buffer),再返回处理完的字符串(或者buffer)的过程
webpack会将加载的资源作为参数传入loader方法，交于loader处理再返回

- [如何编写一个loader](https://doc.webpack-china.org/contribute/writing-a-loader)
 + 在我这个需求中，就是将我加载的html，套在我设定的layout中，再将这个处理完的html返回。大致的代码就是这样：
```
 // {string} source: 加载的html的字符串值
module.exports = function (source) {
  return getLayoutHtml().replace('{{__content__}}', source)
}
```
 + 第一步，只要实现一个getLayoutHtml方法，能得到设定的layout.html文件就好。仔细想想，layout文件应该是通过配置声明的，然后在loader里去根据配置，调用node的api去加载文件就好
```
module.exports = function (source) {
  const options = loaderUtils.getOptions(this)
  const layoutHtml = fs.readFileSync(options.layout, 'utf-8')
  return layoutHtml.replace('{{__content__}}', source)
}
```
 + webpack的config增加如下loader配置：
```
{
  test: /\.(html)$/,
  loader: 'html-layout-loader',
  include: htmlPath, // the htmls you want inject to layout
  options: {
    layout: layoutHtmlPath // the path of default layout html
  }
}
```
 + [more](https://github.com/wuomzfx/html-layout-loader)

