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

@property (nonatomic, strong) NSOperationQueue *operQueue;
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
    NSLog(@"我在子线程执行-NSThread");
    for (int i = 1; i <= 10; i ++) {
        NSLog(@"%@ ----------- %d",[NSThread currentThread].name,i);
        sleep(1);
        if (i == 10) {
            [self performSelectorOnMainThread:@selector(runMainThread) withObject:nil waitUntilDone:YES];
        }
    }
}

- (void)runMainThread {
    NSLog(@"回到主线程");
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
}
#pragma mark - Single
- (IBAction)singleAction:(id)sender {
    TestSingle *single = [TestSingle instance];
    NSLog(@"%@",single);
}

#pragma mark - Operation
- (void)clickOperation {
    NSLog(@"main thread");
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSInvocationOperation *invocationOper = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationAction) object:nil];
//        [invocationOper start];
//        NSLog(@"end");
//    });
    
//    NSBlockOperation *blockOper = [NSBlockOperation blockOperationWithBlock:^{
//        for (int i = 0; i < 3; i ++) {
//            NSLog(@"invocation %d",i);
//            [NSThread sleepForTimeInterval:1];
//        }
//    }];
    
    if (! self.operQueue) {
        self.operQueue = [[NSOperationQueue alloc] init];
    }
    [self.operQueue setMaxConcurrentOperationCount:2];
//    [blockOper start];
//    [self.operQueue addOperation:blockOper];
    
    CustomOperation *customOperA = [[CustomOperation alloc] initWithName:@"OperA"];
    CustomOperation *customOperB = [[CustomOperation alloc] initWithName:@"OperB"];
    CustomOperation *customOperC = [[CustomOperation alloc] initWithName:@"OperC"];
    CustomOperation *customOperD = [[CustomOperation alloc] initWithName:@"OperD"];
    
    [customOperD addDependency:customOperA];
    [customOperA addDependency:customOperC];
    [customOperC addDependency:customOperB];
    
    [self.operQueue addOperation:customOperA];
    [self.operQueue addOperation:customOperB];
    [self.operQueue addOperation:customOperC];
    [self.operQueue addOperation:customOperD];
    
    NSLog(@"end");
}

- (void)invocationAction {
    for (int i = 0; i < 3; i ++) {
        NSLog(@"invocation %d",i);
        [NSThread sleepForTimeInterval:1];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [NSThread detachNewThreadSelector:@selector(download) toTarget:self withObject:nil];
}

- (void)download {
//    NSLog(@"DOWNLOAD ------- %@", [NSThread currentThread]);
//    CFTimeInterval start = CFAbsoluteTimeGetCurrent();
//
//    NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522321266313&di=ed9a6275326aa65211a500130c915d13&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F014fc4554236ee0000019ae9140050.jpg"];
//    NSData *imgData = [NSData dataWithContentsOfURL:url];
//    UIImage *img = [UIImage imageWithData:imgData];
//
//    [self performSelectorOnMainThread:@selector(showImage:) withObject:img waitUntilDone:NO];
//
//    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
//    NSLog(@"%f", end - start);
    

    [self GCDCommunicate];
    
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

- (void)showImage:(UIImage *)img {
    self.imgView.image = img;
    NSLog(@"UI ------ %@", [NSThread currentThread]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
