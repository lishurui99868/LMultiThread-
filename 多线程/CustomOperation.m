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

- (void)main {
//    for (int i = 0; i < 3; i ++) {
//        NSLog(@"%@ %d",self.operName, i);
//        [NSThread sleepForTimeInterval:1];
//    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1];
        if (self.cancelled) {
            return ;
        }
        NSLog(@"%@",self.operName);
        self.over = YES;
    });
    while (! self.over && ! self.cancelled) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
    }
}

@end
