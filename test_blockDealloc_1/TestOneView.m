//
//  TestOneView.m
//  test_blockDealloc_1
//
//  Created by Ray on 2017/7/25.
//  Copyright © 2017年 Yestin. All rights reserved.
//

#import "TestOneView.h"

@implementation TestOneView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// 持有 传入的block , strong
-(void)setOneBlock:(ZYOneBlock1)oneBlock{
    
    _oneBlock = oneBlock;
    _oneBlock();
}

// 持有 传入的block , 但是 weak
- (void)testWeakBlock:(ZYOneBlock1) block;
{
    self.weak_oneBlock = block;
}

// 不持有 传入的block , 在method中直接执行掉
- (void)testBlock2WithBlock:(ZYOneBlock2) secondblock;
{
    secondblock();
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

@end
