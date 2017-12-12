//
//  JPViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPViewController.h"

@interface JPViewController () <UIGestureRecognizerDelegate>

@end

@implementation JPViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCFUMMessageClickNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCFUMMessageClickNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
//    //  监控网络状态变化
//    [JPNetworkUtils netWorkState:^(NSInteger netState) {
//        switch (netState) {
//            case 1:
//            case 2: {
//                
//                }
//            }
//                break;
//            default: {
//                NSLog(@"没网");
//            }
//                break;
//        }
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JP_viewBackgroundColor;
    
    // 导航栏背景颜色
    [self.navigationController.navigationBar setBarTintColor:JPBaseColor];
    // 导航栏标题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // 导航栏左右按钮字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //  设置ViewController可以滑动pop
    //    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        if ([self.navigationController.viewControllers count] > 1) {
    //            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    //            self.navigationController.interactivePopGestureRecognizer.delegate = self;
    //        } else {
    //
    //            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    //        }
    //    }
    //  设置导航返回键
    if (self.navigationController.viewControllers.count > 1) {
        
        UIBarButtonItem *left = [[UIBarButtonItem alloc] init];
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectMake(15, 8, JPRealValue(30), JPRealValue(25))];
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(JPRealValue(5), JPRealValue(5), JPRealValue(5), JPRealValue(5));
        leftButton.backgroundColor = [UIColor clearColor];
        [leftButton setBackgroundImage:[[UIImage imageNamed:@"jp_goBack1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(onBackItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [left setCustomView:leftButton];
        
        // 调整 leftBarButtonItem 在 iOS7 下面的位置
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        //  距左侧的距离 默认为0
        //  negativeSpacer.width = 0;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, left] ;
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        self.navigationController.navigationBar.translucent = NO;
    }
    weakSelf_declare;
    [[NSNotificationCenter defaultCenter] addObserverForName:kCFUMMessageClickNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if ([JPUserEntity sharedUserEntity].isLogin) {
            JPNavigationController *nav = weakSelf.tabBarController.viewControllers[0];
            if (nav.viewControllers.count > 1) {
                [nav popToRootViewControllerAnimated:NO];
            }
            nav.tabBarController.selectedIndex = 1;
        }
    }];
}

//  返回按钮可通过重写此方法
- (void)onBackItemClicked:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
