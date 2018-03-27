title: css盒模型
---
# css盒模型
## IE模型
- 宽度指的是content+padding+border
- box-sizing:border-box

## 标准模型
- 宽度指的是content
- box-sizing:content-box

## BFC盒模型
### BFC的特性
- 内部Box会在垂直方向，从顶部开始一个接一个的放置
- box垂直方向的距离由margin决定，属于同一个BFC的相邻box的margin会发生叠加
- 每个元素的margin box的左边,与包含块border box的左边相接触,即使浮动也是如此
- BFC的区域不会与float box叠加
- BFC就是页面上的一个隔离的独立容器，容器里面的子元素不会影响外面的元素，反之亦然
- 计算BFC的高度,浮动元素也参与计算 

### 如何触发BFC
- float除了none以外的值
- overflow 除了visible以外的值(hidden,auto,scroll)
- display(table-cell,table-caption,inline-block,flex,inline-flex)
- position值为（absolute,fixed)
- fieldset元素

### BFC应用场景
- 解决margin叠加问题
 + 3个p元素之间距离为50px,发生外边距叠加,解决这个叠加问题是的每个p之间是100px,可以创建BFC，给p元素添加一个父元素，让他触发BFC
- 用于布局：两栏自适应高度之类的
```
<!DOCTYPE html> 
    <head>
        <title>BFC</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <style>
            .floatLeft,.floatRight {
                width:100px;
                height:100px;
            }
            .floatLeft {
                /*左浮动触发BFC*/
                float:left;
                background:green;
            }
            .floatRight {
                /*右浮动触发BFC*/
                float:right;
                background:yellow;
            }
            .bfcContent {
                /*table-cell触发BFC*/
                display:table-cell;
                width:9000px;/*宽度大到屏幕宽度即可*/
                /*hack手段，针对IE6、7*/
                *display:inline-block;
                *width:auto;
                height:100px;
                background:pink;
            } 
        </style>
    </head>
    <body>
        <div class="floatLeft"></div>
        <div class="floatRight"></div>
        <div class="bfcContent bfcContentStl"></div>
    </body>
</html>
```
- 清除浮动