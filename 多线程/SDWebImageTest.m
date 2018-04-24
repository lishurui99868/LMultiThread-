//
//  SDWebImageTest.m
//  多线程
//
//  Created by YY on 2018/4/24.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import "SDWebImageTest.h"
#import <SDWebImage/SDWebImageManager.h>

typedef NS_OPTIONS(NSInteger, ActionType){
    ActionTypeTop =     1 << 0,  // 1 * 2(0) = 1
    ActionTypeBottom =  1 << 1,  // 1 * 2(1) = 2
    ActionTypeLeft =    1 << 2,  // 1 * 2(2) = 4
    ActionTypeRight =   1 << 3   // 1 * 2(3) = 8
};

@interface SDWebImageTest ()<NSCacheDelegate>

@property (nonatomic, strong) NSCache *cache;
@end
@implementation SDWebImageTest

- (void)demo:(ActionType)type {
    if (type & ActionTypeTop) {
        NSLog(@"向上 ---- %zd", type & ActionTypeTop);
    }
    if (type & ActionTypeBottom) {
        NSLog(@"向下 ---- %zd", type & ActionTypeBottom);
    }
    if (type & ActionTypeLeft) {
        NSLog(@"向左 ---- %zd", type & ActionTypeLeft);
    }
    if (type & ActionTypeRight) {
        NSLog(@"向右 ---- %zd", type & ActionTypeRight);
    }
}

- (instancetype)init {
    if (self = [super init]) {
        [self demo:ActionTypeLeft | ActionTypeBottom];
    }
    return self;
}

- (void)test {
    // 1.清空缓存
    // cleanDisk:清除过期缓存，计算当前缓存的大小，和设置的最大缓存数量比较，如果超出那么会继续删除（按照文件创建的先后顺序）
    // clearDisk:直接删除，然后重新创建
    // 过期：7天
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    [[SDWebImageManager sharedManager].imageCache clearDisk];
    [[SDWebImageManager sharedManager].imageCache cleanDisk];
    // 2.取消当前所有操作
    [[SDWebImageManager sharedManager] cancelAll];
    // 3.最大并发数量：6
    // 4.缓存文件的保存名称如何处理？ 拿到图片的URL路径，对该路径进行MD5加密
    // 5.该框架内部对内存警告的处理方式？内部通过监听通知的方式清理缓存
    // 6.该框架进行缓存处理的方式：NSCache
    // 7.如何判断图片的类型：在判断图片类型的时候只匹配第一个字节
    // 8.队列中任务的处理方式：FIFO
    // 9.如何下载图片的？发送网络请求下载图片，NSURLConnection
    // 10.请求超时时间 15s
}

- (NSCache *)cache {
    if (! _cache) {
        _cache = [[NSCache alloc] init];
        _cache.delegate = self;
        _cache.totalCostLimit = 5; // 总成本数是5，如果发现存的数据超过总成本数会自动回收之前的对象
    }
    return _cache;
}
#pragma mark - NSCacheDelegate
// 即将回收对象的时候调用该方法
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    NSLog(@"回收%@", obj);
}

- (void)add {
    // NSCache的key只是对对象进行强引用，不是拷贝
//    NSString *str = [NSString stringWithFormat:@"cache -- %zd", i];
    for (NSInteger i = 0; i < 10; i ++) {
        NSString *str = [NSString stringWithFormat:@"cache -- %zd", i];
        // cost:成本
        [self.cache setObject:str forKey:@(i) cost:1];
    }
}

- (void)check {
    for (NSInteger i = 0; i < 10; i ++) {
        NSString *str = [self.cache objectForKey:@(i)];
        if (str) {
            NSLog(@"%@", str);
        }
    }
}

- (void)remove {
    [self.cache removeAllObjects];
}

@end
