//
//  ViewController.m
//  NSThread-learning
//
//  Created by yaoxiaobing on 16/5/12.
//  Copyright © 2016年 yaoxiaobing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - thread
-(void)thread1:(id)param{

    NSLog(@"thread 1");

    
    
    [[NSThread currentThread] cancel];//只是标记线程的状态是取消isCanceled = YES
    
    BOOL isCanceled = [NSThread currentThread].isCancelled;
    if (isCanceled) {
        //判断线程的状态是取消，调用exit方法，让线程真正退出
        [NSThread exit];
    }
    
    //睡眠3秒
    //执行下载
    NSString *urlString = @"http://images.haiwainet.cn/2016/0512/20160512083447819.jpg";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    UIImage *image = [UIImage imageWithData:data];
    //模拟延时
    [NSThread sleepForTimeInterval:3.0];
    

    //更新UI
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];

}


- (void)updateUI:(id)param{
    
    UIImage *image = (UIImage *)param;
    self.imageView.image = image;

}

- (void)thread2:(id)param{

    NSLog(@"thread 2");
    NSString *urlString = @"http://pic1.nipic.com/2008-12-09/200812910493588_2.jpg";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    UIImage *image = [UIImage imageWithData:data];
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
}

- (IBAction)start1:(id)sender {
    //1.手动开启方式创建
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(thread1:) object:@"thread1"];
    thread.name = @"manual";
    [thread start];
}

- (IBAction)start2:(id)sender {
    //2.自动创建
    [NSThread detachNewThreadSelector:@selector(thread2:) toTarget:self withObject:@"thread2"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
