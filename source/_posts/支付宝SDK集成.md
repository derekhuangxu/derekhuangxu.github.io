title: 支付宝SDK集成
date: 2015-12-20 11:56:10
tags:
---
>因为公司最近在开发新的版本，新的版本里面需要集成支付功能，所以就开始了以下的故事。。。

## 1、创建应用
这个其实开发者们都应该懂，就是在支付宝这里挂个号，然后进行下一步业务的申请。

[创建应用的链接](https://openhome.alipay.com/platform/createApp.htm)

![创建应用界面](http://upload-images.jianshu.io/upload_images/711112-0db5991ba93c5280.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

{% asset_img http://upload-images.jianshu.io/upload_images/711112-0db5991ba93c5280.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 This is an example image %}

__*开发者只需要按照指示一步一步添加内容就可以。*__

## 2、申请移动支付
这个就需要一些公司文档什么的了，根据指示填写即可，但是要切记不要让自己的word超过了大小限制，否则有一定几率不会通过。
[签约成为商家](https://b.alipay.com/order/productDetail.htm?productId=2015110218010538)
![](http://upload-images.jianshu.io/upload_images/711112-5b75941ae4f0a37b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


>虽然说，整个流程可能需要将近两周时间，但是根据我这次集成来看，大约一周多就能完成。但是假如你的开发周期比较紧张，建议早申请，毕竟要控制时间成本。

## 3、下载官方Demo
这个是比较坑的事情。。。不知道是不是公司原来办公室网络的问题，总之就是用迅雷无论如何也下载不下来，然后用了**chrome**之后就一切顺利。

[开发工具包下载](http://doc.open.alipay.com/doc2/detail?treeId=54&articleId=103419&docType=1)

点击以上链接之后进入各种Demo的下载页面，当然，也可以下载用于UI的视觉资源。（PS:**Android和iOS的Demo是在一起的**）

#### 以下两张图片为下载的Demo的文件情况：
![Demo内部文件](http://upload-images.jianshu.io/upload_images/711112-be75b0b1e3f6bfda.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![Demo内部文件](http://upload-images.jianshu.io/upload_images/711112-d5134d7115cb196d.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

因为我是做iOS端的集成，所以自行忽略掉了服务端和Android端的Demo。

## 4、业务逻辑
[交互流程网页链接](http://doc.open.alipay.com/doc2/detail?spm=0.0.0.0.w6njr9&treeId=59&articleId=103658&docType=1)

![功能流程](http://upload-images.jianshu.io/upload_images/711112-a22113fe90aa974e.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![数据交互](http://upload-images.jianshu.io/upload_images/711112-4c7cf01cbbc683a3.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

支付宝支付的功能流程相比较微信支付来说简单的很，如上面两张图展示的，我们的App（也就是商户客户端）所做的大概只有三个步骤：

*	生成订单
*	调用支付宝接口，发送订单
*	返回订单支付结果并处理

功能层面上讲就是着这些，但是支付环节肯定有一个安全性问题，那么就需要加密以及解密的过程。

>目前支付宝采取的是**RSA**的加密方式，这是一种比较常见的非对称加密算法，至于怎么集成，下面会给大家做个详细介绍。[**RSA维基**](https://zh.wikipedia.org/wiki/RSA加密演算法)

## 5、集成
![iOS工程内容](http://upload-images.jianshu.io/upload_images/711112-f4cc1abff9952185.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 1）添加framework和其他文件
打开iOS工程，你会看到上面的一堆东西，你需要复制粘贴到自己工程里的有：

*	lipaySDK.framework
*	AlipaySDK.bundle
*	Order.h和Order.m
*	Until文件夹
*	openssl文件夹
*	libcrypto.a和libssl.a

### 2）添加第三方框架和类库
![来源于网络，侵删](http://upload-images.jianshu.io/upload_images/711112-a2b76b9d600ed23a.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
以及上面的`libcrypto.a , libssl.a`。

此时，假如你启动工程，很大几率上你会发现报**error**的情况。
报错`#include <openssl/opensslconf.h> not find`
这是一个神奇的大坑，我Google了好久，也不得其解，然后经网友提醒之后想起来`#import ""`和`#import <>`的区别。

>解决方法：Targets -> Build Settings 下的 Header Search Paths。添加如下目录 "$(SRCROOT)/项目名称/文件的绝对地址"

在集成之前，不要忘了还要写一个**URL Scheme**，在Targets -> Info 下最后一个即可找到。
![](http://upload-images.jianshu.io/upload_images/711112-2c66ba86454db581.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 3)集成代码
你在添加代码的时候会发现下图所示代码
![](http://upload-images.jianshu.io/upload_images/711112-7fb3eff2b60359e5.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

*	partner：可以在支付宝的账户中找到
*	seller：就是我们的支付宝账号
*	privateKey：这个就是我们上面提到的**RSA**加密中的**密钥**。

密钥生成方法在上文中可以看到，就是在上文中的下载的官方文档中openssl文件夹中的生成命令。

[RSA私钥及公钥生成](http://doc.open.alipay.com/doc2/detail?treeId=58&articleId=103242&docType=1)
![网页截图](http://upload-images.jianshu.io/upload_images/711112-24e81c89fabb1ce9.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

>注意：我在生成密钥的时候，在第三行，误将其以为是JAVA开发者才会使用，所以没有在命令行中输入命令，一直导致**无法加密**，所以iOS开发者务必将所有命令输入Vim当中。

生成的文件一共有两个`rsa_private_key.pem`和`rsa_public_key.pem`，第一个就是私钥，可以用vim打开，也可以用文本文件打开，打开之后复制到工程中即可，值得注意的是，复制的时候**不要有空格**等东西。。。

##### 上传公钥：
[上传公钥官方指导](http://doc.open.alipay.com/doc2/detail.htm?spm=0.0.0.0.M3ZhPy&treeId=58&articleId=103578&docType=1)，和私钥一样，上传的过程中，**切记不要有空格**等字符出现。


#### AppDelegate
	- (BOOL)application:(UIApplication *)application
				openURL:(NSURL *)url
	  sourceApplication:(NSString *)sourceApplication
			 annotation:(id)annotation {
	
	 //跳转支付宝钱包进行支付，处理支付结果
	  [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
					NSLog(@"result = %@",resultDic);
		}];
	
	return YES;
}

#### 执行回调	

		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
					   orderSpec, signedString, @"RSA"];
		
		[[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
			NSLog(@"reslut = %@",resultDic);
		}];
以下是几个回调返回的resultDic值：
		
	9000 订单支付成功 
	8000 正在处理中  
	4000 订单支付失败 
	6001 用户中途取消 
	6002 网络连接出错       
		
#### 对于iOS9进行适配
和其他的第三SDK一样，对于新的iOS9，支付宝SDK一样需要下`infoPlist`进行适配。
	
	<key>NSAppTransportSecurity</key>
	   <dict>
	   		<key>NSExceptionDomains</key>
	  		 <dict>
		 		 <key>alipay.com</key>
		 	 <dict>
	<!--Include to allow subdomains--> <key>NSIncludesSubdomains</key>
	<true/>
	<!--Include to allow insecure HTTP requests--> 	<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key> <true/>
			 <!--Include to specify minimum TLS version-->
			 <key>NSTemporaryExceptionMinimumTLSVersion</key>
			 <string>TLSv1.1</string>
		  </dict>
	   </dict>
	</dict>
	

### 4）易发bug以及总结
我觉得最易发的有：

*   报错`#include <openssl/opensslconf.h> not find`
*   返回错误ALI64和ALI69


第一个上面有提到，第二个可以在支付包官方文档中找到：[官方链接](http://doc.open.alipay.com/doc2/detail.htm?spm=a219a.7386797.0.0.ega2nl&treeId=70&articleId=103617&docType=1)。
理论上讲，最大概率出错就是在公钥和密钥的处理上，认真排查应该就会找到问题。
如果还没有解决，可以[寻找客服](http://doc.open.alipay.com/doc2/detail?treeId=70&articleId=103646&docType=1)来解决问题，刚开始的是**智能机器人客服**，如果两次都无法解决问题，还可以后面申请人工客服，只不过等待时间可能会有点长。

>支付宝的集成还是相对来说相当简单的，只要认真查验官方文档以及认真Google，相信会找到自己想要的解决方发。这篇文章较为匆忙，如有问题还请各位指正。