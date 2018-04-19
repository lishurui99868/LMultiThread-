//
//  TicketManager.m
//  多线程
//
//  Created by 李姝睿 on 2016/11/30.
//  Copyright © 2016年 李姝睿. All rights reserved.
//

#import "TicketManager.h"
#define Total 50

@interface TicketManager ()

@property int tickets; // 剩余票数
@property int saleCount; // 卖出票数

@property (nonatomic, strong) NSThread *threadBJ;
@property (nonatomic, strong) NSThread *threadSH;

@property (nonatomic, strong) NSCondition *ticketCondition;

@end
@implementation TicketManager

- (instancetype)init {
    if (self = [super init]) {
        self.ticketCondition = [[NSCondition alloc] init];
        self.tickets = Total;
        self.threadBJ = [[NSThread alloc] initWithTarget:self selector:@selector(sale) object:nil];
        [self.threadBJ setName:@"BJ_Thread"];
        self.threadSH = [[NSThread alloc] initWithTarget:self selector:@selector(sale) object:nil];
        [self.threadSH setName:@"SH_Thread"];
    }
    return self;
}

- (void)sale {
    while (true) {
//        @synchronized (self) {
        [self.ticketCondition lock];
            if (self.tickets > 0) {
                [NSThread sleepForTimeInterval:0.5];
                self.tickets --;
                self.saleCount = Total - self.tickets;
                NSLog(@"%@：当前余票：%d，售出：%d", [NSThread currentThread].name, self.tickets, self.saleCount);
            }
        [self.ticketCondition unlock];
//        }
        
    }
}

- (void)startToSale {
    [self.threadBJ start];
    [self.threadSH start];
}

@end
