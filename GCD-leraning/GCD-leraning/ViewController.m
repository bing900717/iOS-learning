//
//  ViewController.m
//  GCD-leraning
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

//    //异步加并行
//    [self asyncConcurrentQueue];
//
//    //异步串行
//    [self asyncSerialQueue];
//    
//    //同步并行
//    [self syncConcurrentQueue];
//    
//    //同步串行
//    [self syncSerialQueue];
//    
//    //异步+主队列
//    [self asyncMainQueue];
    
    //同步+主队列
//    [self syncMainQueue];
    
    //线程间通信
//    [self communication];
    
    //队列组
//    [self group];
    
    //dispatch_apply
//    [self apply];
    
    //barrier
//    [self barrier];
    
    //semaphoer
    [self semaphore];
    
}



- (void)asyncConcurrentQueue
{
    
    //同步加并行
   //注意: 如果是同步函数, 只要代码执行到了同步函数的那一行, 就会立即执行任务, 只有任务执行完毕才会继续往后执行
   //能不能开启新的线程, 和并行/串行没有关系, 只要函数是同步就不会开启新线程
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"1 - %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2 - %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3 - %@",[NSThread currentThread]);
    });
    
    NSLog(@"%s",__func__);
}

-(void)asyncSerialQueue
{
    //会创建新的线程, 但是只会创建一个新的线程, 所有的任务都在这个新的线程中执行
    // 1.创建队列
    dispatch_queue_t queue = dispatch_queue_create("com.520it.lnj", NULL);
    // 2.添加任务
    dispatch_async(queue, ^{
        NSLog(@"1 - %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2 - %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3 - %@", [NSThread currentThread]);
    });
    NSLog(@"%s", __func__);

}

- (void)syncConcurrentQueue
{
    //同步+并行
    //注意: 如果是同步函数, 只要代码执行到了同步函数的那一行, 就会立即执行任务, 只有任务执行完毕才会继续往后执行
    //能不能开启新的线程, 和并行/串行没有关系, 只要函数是同步就不会开启新线程
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_sync(queue, ^{
        NSLog(@"1 - %@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2 - %@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3 - %@",[NSThread currentThread]);
    });
    
    NSLog(@"%s",__func__);
}

-(void)syncSerialQueue
{
    //会创建新的线程, 但是只会创建一个新的线程, 所有的任务都在这个新的线程中执行
    // 1.创建队列
    dispatch_queue_t queue = dispatch_queue_create("com.520it.lnj", DISPATCH_QUEUE_SERIAL);
    // 2.添加任务
    dispatch_sync(queue, ^{
        NSLog(@"1 - %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2 - %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3 - %@", [NSThread currentThread]);
    });
    NSLog(@"%s", __func__);
    
}

- (void)asyncMainQueue
{
    // 主队列, 只要将任务放到主队列中, 那么任务就会在主线程中执行
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 如果任务放在主队列中, 哪怕是异步方法也不会创建新的线程
    dispatch_async(queue, ^{
        NSLog(@"1 - %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2 - %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3 - %@", [NSThread currentThread]);
    });

}

- (void)syncMainQueue
{
//    注意: 同步函数不能搭配主队列使用,会发生死循环
//    如果是在子线程中调用同步函数 + 主对列 是可以执行的
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        NSLog(@"1 - %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2 - %@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3 - %@", [NSThread currentThread]);
    });
    
}

- (void)communication
{
    //线程间通信
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 1.下载图片(耗时)
    dispatch_async(queue, ^{
        NSLog(@"%@", [NSThread currentThread]);
        // 1.创建URL
        NSURL *url = [NSURL  URLWithString:@"http://pic36.nipic.com/20131217/6704106_233034463381_2.jpg"];
        // 2.通过NSData下载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        // 3.将NSData转换为图片
        UIImage *image = [UIImage imageWithData:data];
        // 4.更新UI
        // 如果是通过异步函数调用, 那么会先执行完所有的代码, 再更新UI
        // 如果是同步函数调用, 那么会先更新UI, 再执行其它代码
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"%@", [NSThread currentThread]);
            self.imageView.image = image;
            NSLog(@"更新UI完毕");
        });
        NSLog(@"Other");
    });

}

- (void)group
{
    
//    队列组
//    有这么1种需求
//    首先：分别异步执行2个耗时的操作
//    其次：等2个异步操作都执行完毕后，再回到主线程执行操作
//    如果想要快速高效地实现上述需求，可以考虑用队列组
    
    dispatch_group_t group =  dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执行1个耗时的异步操作
    
        for (int i =0; i< 60000; i++) {
            
        }
        NSLog(@"group 1 done");
    
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执行1个耗时的异步操作
        for (int i =0; i< 50000; i++) {
            
        }
        NSLog(@"group 2 done");

    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程...
        
        NSLog(@"all done");
        
    });
    
}

- (void)apply
{
//    dispathc_apply 是dispatch_sync 和dispatch_group的关联API.它以指定的次数将指定的Block加入到指定的队列中。并等待队列中操作全部完成.
    dispatch_async(dispatch_get_global_queue(0, 0), ^(){
        dispatch_apply(10, dispatch_get_global_queue(0, 0), ^(size_t index){
            
            for (int i = 0; i< 100*(index +1); i++) {
                
            }
            NSLog(@"index = %zd,--done",index);
        });
        NSLog(@"done");
    });
}


- (void)barrier
{
    
//    dispatch_barrier_async 作用是在并行队列中，等待前面两个操作并行操作完成，这里是并行输出
//    dispatch-1，dispatch-2
//    然后执行
//    dispatch_barrier_async中的操作，(现在就只会执行这一个操作)执行完成后，即输出
//    "dispatch-barrier，
//    最后该并行队列恢复原有执行状态，继续并行执行
//    dispatch-3,dispatch-4
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-1");
    });
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-2");
    });
    dispatch_barrier_async(concurrentQueue, ^(){
        NSLog(@"dispatch-barrier");
    });
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-3");
    });
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-4");
    });

}

- (void)semaphore
{
    
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); 如果semaphore计数大于等于1.计数－1，返回，程序继续运行。如果计数为0，则等待。这里设置的等待时间是一直等待。dispatch_semaphore_signal(semaphore);计数＋1.在这两句代码中间的执行代码，每次只会允许一个线程进入，这样就有效的保证了在多线程环境下，只能有一个线程进入。

    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int index = 0; index < 100000; index++) {
        
        dispatch_async(queue, ^(){
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//
            
            NSLog(@"addd :%d", index);
            
            [array addObject:[NSNumber numberWithInt:index]];
            
            dispatch_semaphore_signal(semaphore);
            
        });
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
