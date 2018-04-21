//
//  ViewController.m
//  多线程
//
//  Created by 李姝睿 on 2016/11/30.
//  Copyright © 2016年 李姝睿. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
#import "TicketManager.h"
#import "TestSingle.h"
#import "CustomOperation.h"
#import "GCDTest.h"

@interface ViewController ()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    TicketManager *manager = [[TicketManager alloc]init];
//    [manager startToSale];
    
    

}
#pragma mark - pThread
- (IBAction)pThreadAction:(id)sender {
    NSLog(@"我在主线程执行");
    pthread_t pthread;
    char *str = "string";
    pthread_create(&pthread, NULL, run, str);
}
void *run(void *data) {
    printf("%s \n", data);
    NSLog(@"我在子线程执行");
    for (int i = 1; i < 10; i ++) {
        NSLog(@"%d",i);
        sleep(1);
    }
    return NULL;
}
#pragma mark - NSThread
- (IBAction)NSThreadAction:(id)sender {
    NSLog(@"我在主线程执行-NSThread");
    // 1.通过alloc init 的方式创建并执行线程
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(runThread1) object:nil];
    [thread1 setName:@"Name_Thread1"];
    [thread1 setThreadPriority:0.2]; // 设置优先级 0（低）～ 1（高）
    [thread1 start];
    
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(runThread1) object:nil];
    [thread2 setName:@"Name_Thread2"];
    [thread2 setThreadPriority:0.5];
    [thread2 start];
    
    // 2.通过detachNewThreadSelector 方式创建并执行线程
    //    [NSThread detachNewThreadSelector:@selector(runThread1) toTarget:self withObject:nil];
    
    // 3.通过performSelectorInBackground 方式创建线程
    //    [self performSelectorInBackground:@selector(runThread1) withObject:nil];
    
    // 线程中的任务执行完之后被释放
}

- (void)runThread1 {
    NSLog(@"DOWNLOAD ------- %@", [NSThread currentThread]);
    CFTimeInterval start = CFAbsoluteTimeGetCurrent();
    
    NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522321266313&di=ed9a6275326aa65211a500130c915d13&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F014fc4554236ee0000019ae9140050.jpg"];
    NSData *imgData = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:imgData];
    [self performSelectorOnMainThread:@selector(showImage:) withObject:img waitUntilDone:NO];
    
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    NSLog(@"%f", end - start);
}

- (void)showImage:(UIImage *)img {
    self.imgView.image = img;
    NSLog(@"UI ------ %@", [NSThread currentThread]);
}
#pragma mark - GCD
- (IBAction)GCDAction:(id)sender {
//    [GCDTest asynConcurrent];
//    [GCDTest asynSerial];
//    [GCDTest syncConcurrent];
//    [GCDTest syncSerial];
//    [GCDTest asynMain];
//    [GCDTest syncMain];
//    [GCDTest delay];
//    [GCDTest once];
//    [GCDTest barrier];
//    [GCDTest apply];
    [GCDTest group2];
//    [self GCDCommunicate];
}
#pragma mark - Single
- (IBAction)singleAction:(id)sender {
    TestSingle *single = [TestSingle shareSingle];
    NSLog(@"%@",single);
}
/**
 GCD线程间通信
 */
- (void)GCDCommunicate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"UI ------ %@", [NSThread currentThread]);
        NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522321266313&di=ed9a6275326aa65211a500130c915d13&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F014fc4554236ee0000019ae9140050.jpg"];
        NSData *imgData = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:imgData];
        // 主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgView.image = img;
            NSLog(@"UI ------ %@", [NSThread currentThread]);
        });
    });
}
#pragma mark - NSOperation
- (IBAction)NSOperationAction:(id)sender {
//    [self blockOperation];
//    [self invocationOperation];
//    [self maxConcurrentOperationCount];
//    [self addDependency];
    [self operationCommunicate];
}

- (void)maxConcurrentOperationCount {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 设置最大并发数量（同一时间最多有多少个任务可以执行）
    // maxConcurrentOperationCount > 1 并发队列
    // maxConcurrentOperationCount == 1 串行队列
    // maxConcurrentOperationCount == 0 不执行任务
    // maxConcurrentOperationCount == -1 最大值，不受限制
    queue.maxConcurrentOperationCount = 1;
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1 ------ %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2 ------ %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3 ------ %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"4 ------ %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"5 ------ %@", [NSThread currentThread]);
    }];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue addOperation:op5];
}

- (void)invocationOperation {
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download1) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download2) object:nil];
    NSInvocationOperation *op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download3) object:nil];
    /*
     * 主队列：[NSOperationQueue mainQueue]
     * 非主队列：[[NSOperationQueue alloc] init] 同时具备并发和串行的功能
     */
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
}

- (void)blockOperation {
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1 ------ %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2 ------ %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3 ------ %@", [NSThread currentThread]);
    }];
    // 追加任务 如果一个操作中的任务数量大于1，那么会开子线程并发执行任务，不一定是子线程，有可能是主线程
    [op3 addExecutionBlock:^{
        NSLog(@"4 ------ %@", [NSThread currentThread]);
    }];
    [op3 addExecutionBlock:^{
        NSLog(@"5 ------ %@", [NSThread currentThread]);
    }];
    [op3 addExecutionBlock:^{
        NSLog(@"6 ------ %@", [NSThread currentThread]);
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    // 简便方法
    [queue addOperationWithBlock:^{
        NSLog(@"7 ------ %@", [NSThread currentThread]);
    }];
}

- (void)download1 {
    NSLog(@"%s ------ %@", __func__, [NSThread currentThread]);
}

- (void)download2 {
    NSLog(@"%s ------ %@", __func__, [NSThread currentThread]);
}

- (void)download3 {
    NSLog(@"%s ------ %@", __func__, [NSThread currentThread]);
}

- (void)addDependency {
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1 ------ %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2 ------ %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3 ------ %@", [NSThread currentThread]);
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"4 ------ %@", [NSThread currentThread]);
    }];
    // 操作监听
    op3.completionBlock = ^{
        NSLog(@"**** 好了 ********%@", [NSThread currentThread]);
    };
    // 添加依赖
    [op1 addDependency:op4];
    [op4 addDependency:op3];
    [op3 addDependency:op2];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
}

- (IBAction)startAction:(id)sender {
    self.queue = [[NSOperationQueue alloc] init];
    self.queue.maxConcurrentOperationCount = 1;
    
    CustomOperation *op1 = [[CustomOperation alloc] init];
    [self.queue addOperation:op1];
}
- (IBAction)suspendAction:(id)sender {
    [self.queue setSuspended:YES];
}
- (IBAction)goOnAction:(id)sender {
    // 不能暂停当前正在执行的任务
    [self.queue setSuspended:NO];
}
- (IBAction)cancelAction:(id)sender {
    [self.queue cancelAllOperations];
}

- (void)operationCommunicate {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *download = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"-------%@",[NSThread currentThread]);
        NSURL *url = [NSURL URLWithString:@"http://pic39.nipic.com/20140320/18201281_214432763000_2.jpg"];
        NSData *imgData = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:imgData];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imgView.image = img;
            NSLog(@"-------%@",[NSThread currentThread]);
        }];
    }];
    [queue addOperation:download];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
