//
//  TestSingle.h
//  多线程
//
//  Created by 李姝睿 on 2016/11/30.
//  Copyright © 2016年 李姝睿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestSingle : NSObject <NSCopying, NSMutableCopying>

+ (instancetype)shareSingle;

@end
