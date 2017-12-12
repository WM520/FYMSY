//
//  JPTabBarController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPTabBarController.h"

#import "JPHomeViewController.h"
#import "JPNewsViewController.h"
#import "JPPersonViewController.h"

@interface JPTabBarController () <UITabBarDelegate,UITabBarControllerDelegate>

@end

@implementation JPTabBarController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCFUMMessageClickNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCFUMMessageClickNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBar.translucent = NO;
    
    self.tabBar.translucent = NO;
    self.tabBarController.tabBar.delegate = self;
    self.delegate = self;
    [self addChildViewControllers];
    
    weakSelf_declare;
    [[NSNotificationCenter defaultCenter] addObserverForName:kCFUMMessageClickNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
//        JPNewsModel *newsModel = [JPNewsModel yy_modelWithDictionary:note.userInfo];
//        
//        JPDealDetailViewController *dealVC = [[JPDealDetailViewController alloc] init];
//        NSString *business = newsModel.tenantsName;
//        if (business.length <= 0) {
//            business = [JPUserEntity sharedUserEntity].merchantName;
//        }
//        dealVC.newsModel = newsModel;
//        dealVC.businessName = business;
//        dealVC.navigationItem.title = @"交易详情";
//        dealVC.isPresent = YES;
//        JPNavigationController *dealNav = [[JPNavigationController alloc] initWithRootViewController:dealVC];
//        [weakSelf presentViewController:dealNav animated:YES completion:nil];
        
        if ([JPUserEntity sharedUserEntity].isLogin) {
            JPNavigationController *nav = weakSelf.tabBarController.viewControllers[0];
            if (nav.viewControllers.count > 1) {
                [nav popToRootViewControllerAnimated:NO];
            }
            nav.tabBarController.selectedIndex = 1;
        }
    }];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
}

- (void)addChildViewControllers {
    [self appendViewController:[JPHomeViewController new] WithTitle:@"首页" WithImageName:@"jp_home_normal" selectImageName:@"jp_home_selected"];
    [self appendViewController:[JPNewsViewController new] WithTitle:@"消息中心" WithImageName:@"jp_news_normal" selectImageName:@"jp_news_selected"];
    [self appendViewController:[JPPersonViewController new] WithTitle:@"我的" WithImageName:@"jp_person_normal" selectImageName:@"jp_person_selected"];
}

- (void)appendViewController:(UIViewController *)vc
                   WithTitle:(NSString *)title
               WithImageName:(NSString *)ImageName
             selectImageName:(NSString *)selectImageName {
    
    JPNavigationController *nav = [[JPNavigationController alloc]initWithRootViewController:vc];
    
    nav.navigationItem.title = title;
    
    nav.navigationBar.frame = CGRectMake(0, 20, kScreenWidth, 44);
    
    self.tabBar.tintColor = JPBaseColor;
    
    vc.title = title;
    
    vc.tabBarItem.image = [[UIImage imageNamed:ImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:JPBaseColor} forState:UIControlStateSelected];
    
    [self addChildViewController:nav];
}

//tabbar点击事件
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    //如果点击 我 tabbar
    if ([item.title isEqualToString:@"我"]) {
        
    }
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
