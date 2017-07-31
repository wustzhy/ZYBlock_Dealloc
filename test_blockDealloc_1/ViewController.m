//
//  ViewController.m
//  test_blockDealloc_1
//
//  Created by Ray on 2017/7/25.
//  Copyright © 2017年 Yestin. All rights reserved.
//

#import "ViewController.h"

#import "TestOneViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%s",__func__);
    
    TestOneViewController * vc = [[TestOneViewController alloc]init];
    vc.view.backgroundColor = [UIColor yellowColor];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
