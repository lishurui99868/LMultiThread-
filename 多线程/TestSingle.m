//
//  TestSingle.m
//  多线程
//
//  Created by 李姝睿 on 2016/11/30.
//  Copyright © 2016年 李姝睿. All rights reserved.
//



#import "TestSingle.h"

@implementation TestSingle

static TestSingle *_ins;
+ (instancetype)shareSingle {
    
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ins = [super allocWithZone:zone];
    });
    return _ins;
}

- (id)copyWithZone:(NSZone *)zone {
    return _ins;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _ins;
}

@end
