---
title: Http缓存机制
---

# 基于缓存策略三要素分解法

## 缓存存储策略

- 用来确定 Http 响应内容是否可以被客户端缓存，以及可以被哪些客户端缓存

- Cache-Control 的值：设定是否被哪些设备缓存 Public、Private、no-cache、max-age 、no-store

---

## 缓存过期策略

- 客户端用来确认存储在本地的缓存数据是否已过期，进而决定是否要发请求到服务端获取数据

- Expires指定缓存数据的有效时间，有效时间后，本地缓存作废
		+ Cache-Control的值：no-cache和max-age，既包含缓存存储策略也包含缓存过期策略
		+ Cache-Control:no-cache和Cache-Control:max-age=0的效果是一样的
		+ no-cache不建议缓存，但是还是会缓存的

---

## 缓存对比策略

 - 缓存在客户端的数据标识发往服务端，服务端通过标识来判断客户端 缓存数据是否仍有效，进而决定是否要重发数据。
 
 - 客户端检测到数据过期或浏览器刷新之后，会重新发起一个http去请求，服务器会判断请求头有没有标识（If-Modified-Since、If-None-Match），标识有效，就返回304客户端读取本队缓存数据【必须要在首次响应时输出相应的头信息Last-Modified、ETags到客户端】
	
### 在浏览器没有提供缓存过期策略的时候，遵循一个启发式缓存过期策略

- 在响应头中2个事件字段Date和Last-Modified之间的时间插值取10%作为缓存时间周期
	
[more](http://mp.weixin.qq.com/s/qOMO0LIdA47j3RjhbCWUEQ?utm_source=caibaojian.com)
