# WXApi

如何配置Universal Links，请看：https://www.jianshu.com/p/10ce6aa70e61

分享功能，请看：https://www.jianshu.com/p/150d67c8285d

授权登录功能，请看：https://www.jianshu.com/p/a8d572751e5f

update at 2020-05-20

1. 修改工程中Bundle Identifier
2. 将AppDelegate.m中的宏定义``WXAppId``、``UNIVERSALLINK``修改为您在微信开发平台中申请的App ID和Universal Links
3. 将``weixin``对应的URL Schemes修改为微信App ID
4. 修改Associated Domains为applinks:开头，后面加上你配置.well-known/apple-app-site-association文件所在服务器URL
5. 保证真机测试，要求搭载系统iOS 12+，微信版本7.0.7+

注意：使用Universal Links跳转需要前往苹果开发者官网配置Associated Doamins，若之前未打开届时会导致与其Bundle Identifier相关的所有描述文件全部失效，必须重新配置描述文件并安装到本机后方可调试
