//
//  TestSingle.m
//  多线程
//
//  Created by 李姝睿 on 2016/11/30.
//  Copyright © 2016年 李姝睿. All rights reserved.
//

#import "TestSingle.h"

@implementation TestSingle

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    static TestSingle *ins = nil;
    dispatch_once(&onceToken, ^{
        NSLog(@"init the testSingle");
        ins = [[TestSingle alloc] init];
    });
    return ins;
}

@end
