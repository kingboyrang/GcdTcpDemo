//
//  ViewController.m
//  socketDemo
//
//  Created by 吳瀾洲 on 2020/7/28.
//  Copyright © 2020 kingboyrang. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

@interface ViewController ()<GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket *socket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


//断开
- (IBAction)closeConnect:(id)sender {
    
    [self.socket disconnect];
    self.socket = nil;
}

//重连
- (IBAction)resetConnect:(id)sender {
    // 创建socket
   if (self.socket == nil)
       self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
   // 连接socket
   if (!self.socket.isConnected){
       NSError *error;
       [self.socket connectToHost:@"127.0.0.1" onPort:8040 withTimeout:-1 error:&error];
       if (error) NSLog(@"%@",error);
   }
}
//连接
- (IBAction)btnConnect:(id)sender {
    // 创建socket
   if (self.socket == nil)
       // 并发队列，这个队列将影响delegate回调,但里面是同步函数！保证数据不混乱，一条一条来
       // 这里最好是写自己并发队列
       self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
   // 连接socket
   if (!self.socket.isConnected){
       NSError *error;
       [self.socket connectToHost:@"127.0.0.1" onPort:8040 withTimeout:-1 error:&error];
       if (error) NSLog(@"%@",error);
   }
}
//发送内容
-(IBAction)sendBtnAction:(id)sender {
    
    NSData *data = [self.txtField.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:-1 tag:10086];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.txtField resignFirstResponder];
}

#pragma mark GCDAsyncSocketDelegate Methods
//已经连接到服务器
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(nonnull NSString *)host port:(uint16_t)port{
    NSLog(@"连接成功 : %@---%d",host,port);
    //连接成功或者收到消息，必须开始read，否则将无法收到消息,
    //不read的话，缓存区将会被关闭
    // -1 表示无限时长 ,永久不失效
    [self.socket readDataWithTimeout:-1 tag:10086];
}

// 连接断开
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"断开 socket连接 原因:%@",err);
}

//已经接收服务器返回来的数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"接收到tag = %ld : %ld 长度的数据",tag,data.length);
    //连接成功或者收到消息，必须开始read，否则将无法收到消息
    //不read的话，缓存区将会被关闭
    // -1 表示无限时长 ， tag
    [self.socket readDataWithTimeout:-1 tag:10086];
}

//消息发送成功 代理函数 向服务器 发送消息
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"%ld 发送数据成功",tag);
}

@end
