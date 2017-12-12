//
//  JPNavigationController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPNavigationController.h"

@interface JPNavigationController ()

@end

@implementation JPNavigationController
/**
 *  当第一次使用这个类的时候会调用一次
 */
//+ (void)initialize {
//    UINavigationBar *bar = [UINavigationBar appearance];
////    [bar setBackgroundImage:[UIImage imageNamed:@"bg.png"] forBarMetrics:UIBarMetricsCompact];
//    
//    [bar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],
//       NSForegroundColorAttributeName:JP_Content_Color}];
//    
//}
///**
// *  可以在这个方法中拦截所有push进来的控制器
// */
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if(self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        //        [button setTitle:@"返回" forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"jp_goBack"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"jp_goBack"] forState:UIControlStateHighlighted];
//        button.jp_size = CGSizeMake(15, 30);
//        
//        // 让按钮内部的所有内容左对齐
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        button.contentEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 0);
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//        
//        // 隐藏tabBar
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
//    
//    // 这句super的push要放在后面，让viewController可以覆盖上面设置的leftBarButtonItem
//    [super pushViewController:viewController animated:animated];
//}
//
//- (void)back {
//    [self popViewControllerAnimated:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
