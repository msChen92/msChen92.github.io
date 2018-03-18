---
title: http协商缓存VS强缓存
---

# 浏览器缓存(web性能优化)

## 强缓存（也称本地缓存）

- 强缓存是利用http头中的Expires和Cache-Control两个字段来控制的，用来表示资源的缓存时间。
  强缓存中，普通刷新会忽略它，但不会清除它，需要强制刷新。
  浏览器强制刷新，请求会带上Cache-Control:no-cache和Pragma:no-cache
  + Expires-http1.0的规范
    * 绝对时间的GMT格式的时间字符串，当服务器与客户端时间偏差较大时，就会导致缓存混乱
  + Cache-Control-http1.1的规范
    * cache-control:max-age=691200,主要是利用该字段的相对时间值max-age
    * Cache-Control与Expires可以在服务端配置同时启用，同时启用的时候Cache-Control优先级高。
    * 除了max-age的字段外还有其他字段值：no-cache[不使用本地缓存]，no-stroe[禁止浏览器缓存数据]，public[可以被所有用户缓存]，private[只能被终端用户的浏览器缓存]

---

## 协商缓存（也称弱缓存）

- 由服务器来确定缓存资源是否可用，客户端与服务器端要通过某种标识来进行通信，让服务器判断请求资源是否可以缓存访问。
- 主要涉及到两组header字段：Etag和If-None-Match、Last-Modified和If-Modified-Since
  + Etag和If-None-Match
    * Etag/If-None-Match返回一个校验码。ETag可以保证每一个资源是唯一的，资源变化都会导致ETag变化，服务器根据浏览器上送的If-None-Match值来判断是否命中缓存。
    * 与Last-Modified不一样的是，当服务器返回304 Not Modified的响应时，由于ETag重新生成过，response header中还会把这个ETag返回，即使这个ETag跟之前的没有变化。
  + Last-Modify/If-Modify-Since
    * 浏览器第一次请求一个资源的时候，服务器返回的header中会加上Last-Modify，Last-modify是一个时间标识该资源的最后修改时间，例如Last-Modify: Thu,20 Dec 2037 23:59:59 GMT。
    * 当浏览器再次请求该资源时，request的请求头中会包含If-Modify-Since，该值为缓存之前返回的Last-Modify。服务器收到If-Modify-Since后，根据资源的最后修改时间判断是否命中缓存。
    * 如果命中缓存，则返回304，并且不会返回资源内容，并且不会返回Last-Modify。

  + Etag存在的必要性：主要解决Last-Modify难解决的问题
    * 文章周期性修改，内容不变，修改时间改变，这种情况下不希望客户端重新GET
    * 文件修改频繁，if-Modified-Since能检查到的粒度是S级的，这种修改无法判断(UNIX只能到秒)
  + Last-Modified与ETag同时使用，服务器会优先验证ETag，一致的情况下，才会继续比对Last-Modified，最后才决定是否返回304。
-
---

