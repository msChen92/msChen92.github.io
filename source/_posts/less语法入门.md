title: less语法入门
---
# less语法入门
### 变量
```
@nice-blue: #5B83AD;
@light-blue: @nice-blue + #111;

#header { color: @light-blue; }

<!-- 解析后 -->
#header { color: #6c94be; }
```

### 混合
- 定义一些通用的属性集为一个class，然后在另一个class中去调用这些属性。任何class, id 或者元素属性集都可以以同样的方式引入
```
.bordered {
  border-top: dotted 1px black;
  border-bottom: solid 2px black;
}
#menu a {
  color: #111;
  .bordered;
}
.post a {
  color: red;
  .bordered;
}

<!-- 解析后 -->
#menu a {
  color: #111;
  border-top: dotted 1px black;
  border-bottom: solid 2px black;
}
.post a {
  color: red;
  border-top: dotted 1px black;
  border-bottom: solid 2px black;
}
```

### 带参数混合
- 可以像函数一样定义一个带参数的属性集合
```
.border-radius (@radius) {
  border-radius: @radius;
  -moz-border-radius: @radius;
  -webkit-border-radius: @radius;
}
#header {
  .border-radius(4px);
}
.button {
  .border-radius(6px);  
}
```
- 可以给参数设置默认值
```
.border-radius (@radius: 5px) {
  border-radius: @radius;
  -moz-border-radius: @radius;
  -webkit-border-radius: @radius;
}
#header {
  .border-radius;  
}
```
- 可以定义不带参数属性集合，用于隐藏这个属性集合，不让他暴露到css中去
```
.wrap () {
  text-wrap: wrap;
  white-space: pre-wrap;
  white-space: -moz-pre-wrap;
  word-wrap: break-word;
}

pre { .wrap }
<!-- 解析结果 -->
pre {
  text-wrap: wrap;
  white-space: pre-wrap;
  white-space: -moz-pre-wrap;
  word-wrap: break-word;
}
```
- @arguments包含了所有传递进来的参数.不必单独处理每一个参数
```
.box-shadow (@x: 0, @y: 0, @blur: 1px, @color: #000) {
  box-shadow: @arguments;
  -moz-box-shadow: @arguments;
  -webkit-box-shadow: @arguments;
}
.box-shadow(2px, 5px);
<!-- 解析结果 -->
box-shadow: 2px 5px 1px #000;
  -moz-box-shadow: 2px 5px 1px #000;
  -webkit-box-shadow: 2px 5px 1px #000;
```

### 模式匹配
- 根据传入的参数来改变混合的默认呈现
```
//让.mixin根据不同的@switch值而表现各异
.mixin (dark, @color) {
  color: darken(@color, 10%);
}
.mixin (light, @color) {
  color: lighten(@color, 10%);
}
.mixin (@_, @color) {
  display: block;
}

//运行
@switch: light;

.class {
  .mixin(@switch, #888);
}
<!-- 解析结果 -->
.class {
  color: #a2a2a2;
  display: block;
}
/*
mixin就会得到传入颜色的浅色。如果@switch设为dark，就会得到深色。

具体实现如下：
第一个混合定义并未被匹配，因为它只接受dark做为首参
第二个混合定义被成功匹配，因为它只接受light
第三个混合定义被成功匹配，因为它接受任意值

只有被匹配的混合才会被使用。变量可以匹配任意的传入值，而变量以外的固定值就仅仅匹配与其相等的传入值。
*/
```
- 可以匹配多个参数
```
.mixin (@a) {
  color: @a;
}
.mixin (@a, @b) {
  color: fade(@a, @b);
}
```

###导引表达式
- 根据表达式进行匹配，而非根据值和参数匹配
```
//when关键字用以定义一个导引序列(此例只有一个导引)
.mixin (@a) when (lightness(@a) >= 50%) {
  background-color: black;
}
.mixin (@a) when (lightness(@a) < 50%) {
  background-color: white;
}
.mixin (@a) {
  color: @a;
}

//运行
.class1 { .mixin(#ddd) }
.class2 { .mixin(#555) }
<!-- 解析结果 -->
.class1 {
  background-color: black;
  color: #ddd;
}
.class2 {
  background-color: white;
  color: #555;
}
```
- 导引中可用的全部比较运算有： > >= = =< <。此外，关键字true只表示布尔真值，除去关键字true以外的值都被视示布尔假
```
.truth (@a) when (@a) { ... }
.truth (@a) when (@a = true) { ... }
```

- 导引序列使用逗号‘,’—分割，当且仅当所有条件都符合时，才会被视为匹配成功
```
.mixin (@a) when (@a > 10), (@a < -10) { ... }
```
- 导引可以无参数，也可以对参数进行比较运算
```
@media: mobile;

.mixin (@a) when (@media = mobile) { ... }
.mixin (@a) when (@media = desktop) { ... }

.max (@a, @b) when (@a > @b) { width: @a }
.max (@a, @b) when (@a < @b) { width: @b }
```
- 如果想基于值的类型进行匹配，可以使用is*函式
```
.mixin (@a, @b: 0) when (isnumber(@b)) { ... }
.mixin (@a, @b: black) when (iscolor(@b)) { ... }
```
- 常见的检测函式：
```
scolor

isnumber

isstring

iskeyword

isurl

判断一个值是纯数字，还是某个单位量，可以使用下列函式：

ispixel

ispercentage

isem
```
- 使用and关键字实现与条件
```
.mixin (@a) when (isnumber(@a)) and (@a > 0) { ... }
```
- 使用not关键字实现或条件
```
.mixin (@b) when not (@b > 0) { ... }
```

### 嵌套规则
- 以嵌套的方式编写层叠样式
```
#header {
  color: black;

  .navigation {
    font-size: 12px;
  }
  .logo {
    width: 300px;
    &:hover { text-decoration: none }
  }
}
```
- &符号用于写串联选择器，而不是写后代选择器。这点对伪类尤其有用，如:hover和:focus
```
.bordered {
  &.float {
    float: left; 
  }
  .top {
    margin: 5px; 
  }
}
```

### 运算
- 任何数字、颜色或者变量都可以参与运算
```
@base: 5%;
@filler: @base * 2;
@other: @base + @filler;

color: #888 / 4;
background-color: @base-color + #111;
height: 100% / 2 + @filler;
```
- less运算能够分辨出颜色和单位
```
@var: 1px + 5;  //less会输出6px

//括号也同样允许使用
width: (@var + 5) * 2;

//可以在复合属性中进行运算
border: (@width * 2) solid black;
```

### Color 函数
### Math 函数
- less提供了一组方便的数学函数，可以使用它们处理一些数字类型的值
```
round(1.67); // returns `2`
ceil(2.4);   // returns `3`
floor(2.6);  // returns `2`
percentage(0.5); // returns `50%`
```

### 命名空间
- 为了更好组织CSS或者单纯是为了更好的封装，将一些变量或者混合模块打包起来
```
#bundle {
  .button () {
    display: block;
    border: 1px solid black;
    background-color: grey;
    &:hover { background-color: white }
  }
  .tab { ... }
  .citation { ... }
}
<!-- 使用 -->
#header a {
  color: orange;
  #bundle > .button;
}
```

### 作用域
- less中的作用域跟其他编程语言非常类似，首先会从本地查找变量或者混合模块，如果没找到的话会去父级作用域中查找，直到找到为止
```
@var: red;

#page {
  @var: white;
  #header {
    color: @var; // white
  }
}

#footer {
  color: @var; // red  
}
```

### Importing
- 可以在main文件中通过下面的形势引入 .less 文件, .less 后缀可带可不带
```
@import "lib.less";
@import "lib";
```
- 如果想导入一个CSS文件而且不想less对它进行处理，只需要使用.css后缀就可以，这样less就会跳过它不去处理它
```
@import "lib.css";
```

### 字符串插值
- 变量可以用类似ruby和php的方式嵌入到字符串中
```
@base-url: "http://assets.fnord.com";
background-image: url("@{base-url}/images/bg.png");
```

### JavaScript 表达式
- JavaScript 表达式也可以在.less 文件中使用.，可以通过反引号的方式使用
```
@var: `"hello".toUpperCase() + '!'`;    //@var: "HELLO!";
```
- 也可以同时使用字符串插值和避免编译
```
@str: "hello";
@var: ~`"@{str}".toUpperCase() + '!'`; //@var: HELLO!;
```
- 可以访问JavaScript环境
```
@height: `document.body.clientHeight`;
```
- 将一个JavaScript字符串解析成16进制的颜色值，可以使用 color 函数
```
@color: color(`window.colors.baseColor`);
@darkcolor: darken(@color, 10%);
```