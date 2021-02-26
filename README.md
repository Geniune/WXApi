# 使用微信openSDK Demo

相关技术贴：
1. [配置Universal Links](https://www.jianshu.com/p/10ce6aa70e61)
2. [微信登录](https://www.jianshu.com/p/a8d572751e5f)
3. [微信分享](https://www.jianshu.com/p/150d67c8285d)
4. [企业微信登录](https://www.jianshu.com/p/05bd6c58da77)

update at 2021-02-26

1. 修改工程Bundle Identifier
2. 若需要使用微信openSDK相关功能，修改OpenManager.m内的宏定义``WX_AppID``、``WX_UniversalLink``，以及URL Types内``weixin``对应的URL Schemes；
3. 若需要使用企业微信openSDK相关功能，修改OpenManager.m中的宏定义``WW_AppID``、``WW_CorpID``、``WW_AgentID``，以及URL Types内``wwauth``对应的URL Schemes；
4. 修改Associated Domains为applinks:开头，后面加上你配置apple-app-site-association文件所在服务器URL；
5. 保证真机测试，要求搭载系统iOS 7.0+，微信版本7.0.7+。

注意：使用Universal Links跳转需要前往苹果开发者官网配置Associated Doamins，若之前未打开届时会导致与其Bundle Identifier相关的所有描述文件全部失效，必须重新配置描述文件并安装到本机后方可调试
