//
//  ViewController.m
//  QYNNotificationManager
//
//  Created by qiyun on 16/4/11.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import "ViewController.h"
#import "QYNNotificationManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [[QYNNotificationManager shareInstanceManager] addObserver:self
                                                          name:@"123"
                                                        object:nil
                                                      response:^(NSDictionary *dic) {
                                                            
                                                          NSLog(@"dict = %@",dic);
                                                      }];
    
    [[QYNNotificationManager shareInstanceManager] postNotificationName:@"123" object:nil userInfo:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
