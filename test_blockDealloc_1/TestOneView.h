//
//  TestOneView.h
//  test_blockDealloc_1
//
//  Created by Ray on 2017/7/25.
//  Copyright © 2017年 Yestin. All rights reserved.
//

    #import <UIKit/UIKit.h>

    typedef void(^ZYOneBlock1)();

    typedef void(^ZYOneBlock2)();

    @interface TestOneView : UIView

    @property (nonatomic,   copy)     ZYOneBlock1 oneBlock;

    @property (nonatomic,   weak)     ZYOneBlock1 weak_oneBlock;
    - (void)testWeakBlock:(ZYOneBlock1) block;

    - (void)testBlock2WithBlock:(ZYOneBlock2) secondblock;

    @end
