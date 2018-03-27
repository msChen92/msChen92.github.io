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
