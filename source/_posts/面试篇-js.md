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