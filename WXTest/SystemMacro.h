
#ifndef SystemMacro_h
#define SystemMacro_h

#define APP_VERSION     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]    ///版本号
#define APP_BUILD          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]     ///构建版本号


/**
 *  单例宏方法
 *
 *  @param block
 *
 *  @return 返回单例
 */
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \


#endif

//输出日志宏
#ifndef CONSOLE
    #define DebugLog(format, ...) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format),  ##__VA_ARGS__] )
#else
  #define DebugLog(format, ...) nil
#endif


