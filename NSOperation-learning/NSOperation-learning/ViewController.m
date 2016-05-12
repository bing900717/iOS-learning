//
//  ViewController.m
//  NSOperation-learning
//
//  Created by yaoxiaobing on 16/5/12.
//  Copyright © 2016年 yaoxiaobing. All rights reserved.
//

#import "ViewController.h"
#import "CustomOperation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSOperation
//    NSOperation是个抽象类，并不具备封装操作的能力，必须使用它的子类
//    使用NSOperation子类的方式有3种
//    NSInvocationOperation
//    NSBlockOperation
//    自定义子类继承NSOperation，实现内部相应的方法
    
    //默认情况下，调用了start方法后并不会开一条新线程去执行操作，而是在当前线程同步执行操作
    //只有将NSOperation放到一个NSOperationQueue中，才会异步执行操作
    
    
    //1.NSBlockOperation
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1----%@,isMainThread = %@",[NSThread currentThread],@([NSThread isMainThread]));
        //主线程中运行
    }];
    [op1 addExecutionBlock:^{
        //子线程中运行
      NSLog(@"2----%@,isMainThread = %@",[NSThread currentThread],@([NSThread isMainThread]));
    }];
    [op1 addExecutionBlock:^{
        //子线程中运行
      NSLog(@"3----%@,isMainThread = %@",[NSThread currentThread],@([NSThread isMainThread]));
    }];
    
    op1.completionBlock = ^{
        NSLog(@"线程1结束");
    };
//    [op1 start];
    
    //2.NSInvocationOperation
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(thread2:) object:@"op2"];
    //添加依赖，线程1结束后调用线程2
    [op2 addDependency:op1];
//    [op2 start];
    
    //自定义operation
    CustomOperation *op3 = [[CustomOperation alloc] init];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //设置最大并发数目
//    什么是并发数
//    同时执行的任务数
//    比如，同时开3个线程执行3个任务，并发数就是3
//    最大并发数的相关方法
    [queue setMaxConcurrentOperationCount:2];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    
    
}


- (void)thread2:(id)param
{
//    注意
//    默认情况下，调用了start方法后并不会开一条新线程去执行操作，而是在当前线程同步执行操作
//    只有将NSOperation放到一个NSOperationQueue中，才会异步执行操作
    NSLog(@"invocation = %@,isMainThread= %@",[NSThread currentThread],@([NSThread isMainThread]));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
