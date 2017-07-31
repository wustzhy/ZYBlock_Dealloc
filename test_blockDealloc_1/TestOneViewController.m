//
//  TestOneViewController.m
//  test_blockDealloc_1
//
//  Created by Ray on 2017/7/25.
//  Copyright © 2017年 Yestin. All rights reserved.
//

#import "TestOneViewController.h"

#import "TestOneView.h"

typedef void(^MyBlockOne)(NSArray *);


@interface TestOneViewController ()

@property (nonatomic,   strong)     TestOneView * oneView;

@property (nonatomic,   strong)     NSArray * pArray;

@property (nonatomic,   copy)     MyBlockOne myBlock1;

@end

@implementation TestOneViewController
{
    NSInteger _intType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self testStrongBlock_1];
    [self testMethod_StrongBlock_1];
    
    [self testWeakBlock_1];
    
    [self testParamBlock_2];
    
    [self testParam_SelfBlock_1];
    [self testCopy_SelfBlock_1];
}

#pragma mark - block test methods

// ----------------------------------------------
// 传入的block 被strong持有
- (void)testStrongBlock_1{
    
    [self.view addSubview: self.oneView];
    
    __weak typeof(self) weakSelf = self;
    self.oneView.oneBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf->_intType = 11;
        strongSelf.pArray = @[@(11)];
    };
}

// ----------------------------------------------
// 传入的block块中 含有本类的实例方法
- (void)testMethod_StrongBlock_1{
    
    [self.view addSubview: self.oneView];
    
    __weak typeof(self) weakSelf = self;
    self.oneView.oneBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf->_intType = 121;
        strongSelf.pArray = @[@(121)];
        
        // method
        [strongSelf containSelfMethod];
    };
}
- (void)containSelfMethod{
    _intType = 1010;
    self.pArray = @[@(2020)];
}

// ----------------------------------------------
// 传给子view的block 被子view weak持有
    - (void)testWeakBlock_1{
        
        [self.view addSubview: self.oneView];
        
        [self.oneView testWeakBlock:^{
            _intType = 111;
            self.pArray = @[@(1)];
        }];
    }

// ----------------------------------------------
// 传给子view的block ***❌不*** 被子view 持有, 直接执行掉
- (void)testParamBlock_2{
    
    [self.view addSubview: self.oneView];
    
    [self.oneView testBlock2WithBlock:^{
        _intType = 22;
        self.pArray = @[@(1)];
    }];
}

// ----------------------------------------------
// block作参数, 不持有
    - (void)testParam_SelfBlock_1{
        [self testParam_SelfBlcokWith:^(NSArray * arr) {
            self.pArray = arr;
            NSLog(@"%s",__func__);
        }];
    }
    - (void)testParam_SelfBlcokWith:(MyBlockOne)myBlock{
        
        NSArray * arr = @[@"myblock1"];
        myBlock(arr);
        
    }

// ----------------------------------------------
// block作参数, 👉被持有
- (void)testCopy_SelfBlock_1{
    
        __weak typeof(self) weakSelf = self;
    [self testCopy_SelfBlcokWith:^(NSArray * arr) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.pArray = arr;
        NSLog(@"%s",__func__);
    }];
}
- (void)testCopy_SelfBlcokWith:(MyBlockOne)myBlock{
    
    self.myBlock1 = myBlock;
    
    NSArray * arr = @[@"myblock1"];
    
    NSLog(@"%s",__func__);
    sleep(1);
    NSLog(@"%s",__func__);
    self.myBlock1(arr);
}

// ----------------------------------------------
//  GCD 延时 导致延迟释放~
- (void)didMoveToParentViewController:(UIViewController *)parent{
    
    [self.oneView removeFromSuperview];
    
    NSLog(@"%s , %@",__func__ ,self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"%s , %@",__func__ ,self);
        [self testBackTimerAfter];  // 点击pop 时,会延迟2s dealloc
        
    });
}
- (void)testBackTimerAfter{
       
    [self.oneView testWeakBlock:^{
        NSLog(@"%s , %@",__func__ ,self);
    }];
    
    __weak typeof(self) weakSelf = self;
    _oneView.oneBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"%s , %@",__func__ ,strongSelf);
    };
}


#pragma mark - getter
-(TestOneView *)oneView{
    if(_oneView == nil){
        _oneView = [[TestOneView alloc]initWithFrame:CGRectMake(100, 100, 200, 300)];
        _oneView.backgroundColor = [UIColor blueColor];
    }
    return _oneView;
}

-(void)dealloc{
    NSLog(@"%s , %@",__func__ ,self);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
