//
//  GCDTest.h
//  多线程
//
//  Created by YY on 2018/4/19.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDTest : NSObject
/**
 异步函数+并发队列 会开启多条线程，队列中的任务并发执行
 */
+ (void)asynConcurrent;
/**
 异步函数+串行队列 只开一条线程，队列中的任务串行执行
 */
+ (void)asynSerial;
/**
 同步函数+并发队列 不会开线程，任务串行执行
 */
+ (void)syncConcurrent;
/**
 同步函数+串行队列 不会开线程，任务串行执行
 */
+ (void)syncSerial;
/**
 异步函数+主队列 所有任务都在主线程执行，不会开启线程
 */
+ (void)asynMain;
/**
 同步函数+主队列 死锁
 */
+ (void)syncMain;
/**
 延迟执行
 */
+ (void)delay;
/**
 一次性代码
 */
+ (void)once;
/**
 栅栏函数
 */
+ (void)barrier;
/**
 快速迭代
 */
+ (void)apply;
/**
 队列组
 */
+ (void)group;
+ (void)group2;
@end
