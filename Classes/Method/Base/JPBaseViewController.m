//
//  JPBaseViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/5/22.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPBaseViewController.h"

@interface JPBaseViewController ()

@end

@implementation JPBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    //  监控网络状态变化
//    [JPNetworkUtils netWorkState:^(NSInteger netState) {
//        switch (netState) {
//            case 1: {
//                NSLog(@"手机流量上网");
//            }
//                break;
//            case 2: {
//                NSLog(@"WIFI上网");
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
    
    // 导航栏背景颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.27 green:0.28 blue:0.30 alpha:1]];
    // 导航栏标题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // 导航栏左右按钮字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //  设置导航返回键
    if (self.navigationController.viewControllers.count > 1) {
        
        UIBarButtonItem *left = [[UIBarButtonItem alloc] init];
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectMake(15, 8, JPRealValue(30), JPRealValue(30))];
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
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
