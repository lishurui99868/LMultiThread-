//
//  GCDTest.m
//  多线程
//
//  Created by YY on 2018/4/19.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import "GCDTest.h"

@implementation GCDTest
/**
 异步函数+并发队列 会开启多条线程，队列中的任务并发执行
 */
+ (void)asynConcurrent {
    /** 创建队列
     "com.520it.download" C语言的字符串，标签
     队列的类型   DISPATCH_QUEUE_CONCURRENT 并行
     DISPATCH_QUEUE_SERIAL 串行
     */
    //    dispatch_queue_t queue = dispatch_queue_create("com.520it.download", DISPATCH_QUEUE_CONCURRENT);
    /* 获得全局并发队列
     DISPATCH_QUEUE_PRIORITY_DEFAULT 优先级
     */
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 封装任务
    dispatch_async(queue, ^{
        NSLog(@"download1--------%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download2--------%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download3--------%@",[NSThread currentThread]);
    });
}
/**
 异步函数+串行队列 只开一条线程，队列中的任务串行执行
 */
+ (void)asynSerial {
    dispatch_queue_t queue = dispatch_queue_create("com.520it.download", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"download1--------%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download2--------%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download3--------%@",[NSThread currentThread]);
    });
}
/**
 同步函数+并发队列 不会开线程，任务串行执行
 */
+ (void)syncConcurrent {
    dispatch_queue_t queue = dispatch_queue_create("com.520it.download", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSLog(@"download1--------%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download2--------%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download3--------%@",[NSThread currentThread]);
    });
}
/**
 同步函数+串行队列 不会开线程，任务串行执行
 */
+ (void)syncSerial {
    dispatch_queue_t queue = dispatch_queue_create("com.520it.download", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"download1--------%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download2--------%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download3--------%@",[NSThread currentThread]);
    });
}
/**
 异步函数+主队列 所有任务都在主线程执行，不会开启线程
 */
+ (void)asynMain {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSLog(@"download1--------%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download2--------%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download3--------%@",[NSThread currentThread]);
    });
}
/**
 同步函数+主队列 死锁
 */
+ (void)syncMain {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        NSLog(@"download1--------%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download2--------%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download3--------%@",[NSThread currentThread]);
    });
}
/**
 延迟执行
 */
+ (void)delay {
    // 1.延迟执行的第一种方法
    NSLog(@"** start **");
//    [self performSelector:@selector(task) withObject:nil afterDelay:2.f];
    // 2.延迟执行的第二种方法
//    [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(task) userInfo:nil repeats:YES];
    // 3.GCD
    /* DISPATCH_TIME_NOW 从现在开始计算时间
     * 3.f 延迟的时间
     * dispatch_get_main_queue() 队列
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"GCD延时 ---------- %@", [NSThread currentThread]);
    });
}

+ (void)task {
    NSLog(@"task ---------- %@", [NSThread currentThread]);
}
/**
 一次性代码
 */
+ (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"------ once --------");
    });
}
/**
 栅栏函数
 */
+ (void)barrier {
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 栅栏函数不能用全局并发队列
    dispatch_queue_t queue = dispatch_queue_create("download", 0);
    dispatch_async(queue, ^{
        NSLog(@"download1--------%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download2--------%@",[NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"++++++++++++++++++++++++");
    });
    dispatch_async(queue, ^{
        NSLog(@"download3--------%@",[NSThread currentThread]);
    });
}
/**
 快速迭代  子线程和主线程一起完成遍历任务，任务的执行是并发的
 */
+ (void)apply {
    /*
     * 10 遍历次数
     * 队列必须是并发队列
     */
    dispatch_apply(10, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSLog(@"%zd -- %@", index, [NSThread currentThread]);
    });
}
/**
 队列组
 */
+ (void)group {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"--1-------%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"--2-------%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"--3-------%@", [NSThread currentThread]);
    });
    // 当队列组中所有任务都执行完毕之后会进入到下面的方法 内部本身是异步执行的
    dispatch_group_notify(group, queue, ^{
        NSLog(@"----- dispatch_group_notify ----");
    });
}
/**
 队列组以前的写法
 */
+ (void)group2 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    // 在该方法后面的异步任务会被纳入到队列的监听范围，进入群组
    // dispatch_group_enter 和 dispatch_group_leave 配对使用
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"--1-------%@", [NSThread currentThread]);
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"--2-------%@", [NSThread currentThread]);
        dispatch_group_leave(group);
    });
    // DISPATCH_TIME_FOREVER 死等，直到队列组中所有任务执行完毕再执行 阻塞的
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"---- end ----");
}
@end
