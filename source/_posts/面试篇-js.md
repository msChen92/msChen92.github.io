title: js
---
# js对象深浅克隆
- 浅复制：只会将对象的各个属性进行依次复制，并不会进行递归复制，而js存储对象都是存地址的，所以浅复制会导致obj.c和shallowCopy.c 指向同一块内存地址；会导致引用。
- 对象的深复制：它不仅将原对象的各个属性逐个复制出去，而且将原对象各个属性所包含的对象也依次采用深复制的方法递归复制到新对象上。这就不会存在上面obj和shallowCopy的c属性指向同一个对象的问题。
最核心的思想还是采用递归的方式，不断进行，直到基本数据类型后，再复制

# js中的this
##js中的this指向
- 全局作用域或者普遍函数中this指向全局对象window
- 方调用中谁调用this指向谁
- 在构造函数或这个构造函数原型对象中this指向构造函数的实例(不适用new是指向window的)

## call / apply / bind
- call:第一个参数如果是null的话，this就会指向window
```
	var a = {
	    user:"追梦子",
	    fn:function(e,ee){
	        console.log(this.user); //追梦子
	        console.log(e+ee); //3
	    }
	}
	var b = a.fn;
	b.call(a,1,2);
```

- apply的第二个参数必须是数组,第一个参数如果是null的话，this就会指向window

```
	var a = {
	    user:"追梦子",
	    fn:function(e,ee){
	        console.log(this.user); //追梦子
	        console.log(e+ee); //11
	    }
	}
	var b = a.fn;
	b.apply(a,[10,1]);
```

- bind:bind方法返回的是一个修改过后的函数
```
	var a = {
	    user:"追梦子",
	    fn:function(e,d,f){
	        console.log(this.user); //追梦子
	        console.log(e,d,f); //10 1 2
	    }
	}
	var b = a.fn;
	var c = b.bind(a,10);
	c(1,2);
```

- 区别：call和apply都是改变上下文中的this并立即执行这个函数，bind方法可以让对应的函数想什么时候调就什么时候调用，并且可以将参数在执行的时候添加，这是它们的区别

# cookie,localStroage,sessionStroage 区别

# 跨域的方法及原理

#js中的事件委托

#js中数组的一些方法
- some:some() 方法用于检测数组中的元素是否满足指定条件（函数提供）相当于逻辑运算符 ||
 + 如果有一个元素满足条件，则表达式返回true , 剩余的元素不会再执行检测。
 + 如果没有满足条件的元素，则返回false
 + 不会对空数组进行检测，不会改变原始数组

---

- every:当数组每个元素在判定函数中都返回true，则最终结果为true，相当于逻辑运算符 &&
 + 如果数组中检测到有一个元素不满足，则整个表达式返回 false ，且剩余的元素不会再进行检测。
 + 如果所有元素都满足条件，则返回 true
 + 同some
---

- map:map() 方法返回一个新数组，数组中的元素为原始数组元素调用函数处理后的值

- filter
- reduce
- find
- findIndex

# DOM事件类型
- DOM0 element.onclick=function(){}
- DOM2 element.addEventListener('click',function(){},false)
- DOM3 element.addEventListener('keyup',function(){},false)//增加了键盘事件等

# 事件模型
- 捕获：window > document > html > body > 目标元素
- 冒泡
- 事件流是什么？
 + 第一阶段：捕获
 + 第二阶段：目标阶段：事件通过捕获到达目标元素
 + 第三阶段：目标元素上传到window元素：冒泡


# DOM事件类
### event对象常见应用
- event.preventDefault()
- event.stopPropagation()
- event.stoplmmediatePropagation()//事件响应优先级
	+ 一个按钮注册两个事件a和b,需求要a执行的时候，就不再执行b，给a加这个就可以成功阻止b的执行
- event.currentTarget:当前绑定的事件，就是下面的父级元素
- event.target
	+ 比如很多个div，同时注册点击事件，给他们的父元素添加点击事件，e.target找到目标元素，兼容srcElement

### 自定义事件
```
var eve = new Event('custome')
ev.addEventListener('custome',function(){
	console.log('custome')
})
ev.dispatchEvent(eve)
```
CustomeEvent可以添加参数数据{}
```
var eve = new CustomeEvent('事件名',{})
```

# 原型链
## 创建对象的几种方法
- 字面量方式
```
var o1 = {name:'o1'}
var o2 = new Object({name:'o2'})
```
- 构造函数
```
var M = function(name){this.name = name}
var o3 = new M('o3')
这里的o3是实例对象
这里的M是构造函数
M.prototype是原型对象，原型对象中constructor的属性指向构造函数本身
o3._proto_===M.prototype严格相等


```
- object.create
```
var p = {name : 'p'}
var o4 = Object.create(p)
```