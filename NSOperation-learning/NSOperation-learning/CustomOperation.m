
//
//  CustomOperation.m
//  NSOperation-learning
//
//  Created by yaoxiaobing on 16/5/12.
//  Copyright © 2016年 yaoxiaobing. All rights reserved.
//

#import "CustomOperation.h"

@implementation CustomOperation

- (void)main
{
    @autoreleasepool {
        
//        注意
//        默认情况下，调用了start方法后并不会开一条新线程去执行操作，而是在当前线程同步执行操作
//        只有将NSOperation放到一个NSOperationQueue中，才会异步执行操作
        NSLog(@"custom --- %@,isMainThread = %zd",self,[NSThread isMainThread]);
    }

}

@end
