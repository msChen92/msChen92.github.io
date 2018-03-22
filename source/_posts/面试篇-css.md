title: css
---
# css哪些样式可以被继承
 - 字体系列属性：font  font-family font-weight font-size  font-style
 - 文本系列属性：text-indent text-align line-height word-spacing text-tranform color
 - 元素可见性：visibility
 - 光标水性：cursor

# rem的原理
## 首先理解em和px
- px和em都是长度单位，区别是，px的值是固定的，指定是多少就是多少，计算比较容易。em的值不是固定的，并且em会继承父级元素的字体大小。浏览器的默认字体高都是16px。所以未经调整的浏览器都符合: 1em=16px。那么12px=0.75em, 10px=0.625em。
- em是为字体而生的
- rem布局的本质是等比缩放，一般是基于宽度
 + rem是相对单位：相对的是html根元素，em是相对于父元素
- 比rem更好的方案：vw(视口的宽度的1/100) 和vh(视口高度的1/100)
``` 
/*rem方案*/
html{font-size:width/100}//js获取宽度
p{width:15.625rem}
/*vw方案*/
p{width:15.625vw}//不需要js，但是兼容性差
```