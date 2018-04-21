//
//  CustomOperation.m
//  多线程
//
//  Created by 李姝睿 on 2016/11/30.
//  Copyright © 2016年 李姝睿. All rights reserved.
//

#import "CustomOperation.h"

@interface CustomOperation ()

@property (nonatomic, copy) NSString *operName;
@property (nonatomic, assign) BOOL over;

@end
@implementation CustomOperation

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.operName = name;
    }
    return self;
}
// 告知要执行的任务是什么 （有利于代码隐蔽，有利于代码复用）
- (void)main {
    for (NSInteger i = 0; i < 3000; i ++) {
        NSLog(@"download1 ---- %zd ---- %@", i, [NSThread currentThread]);
    }
    if (self.cancelled) {
        return;
    }
    NSLog(@"+++++++++++++++++++++++++");
    for (NSInteger i = 0; i < 1000; i ++) {
        NSLog(@"download2 ---- %zd ---- %@", i, [NSThread currentThread]);
    }
    if (self.cancelled) {
        return;
    }
    NSLog(@"+++++++++++++++++++++++++");
    for (NSInteger i = 0; i < 1000; i ++) {
        NSLog(@"download3 ---- %zd ---- %@", i, [NSThread currentThread]);
    }
}

@end
