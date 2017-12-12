//
//  QRCodeScanningVC.m
//  SGQRCodeExample
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 JP_lee. All rights reserved.
//

#import "QRCodeScanningVC.h"
#import "ScanSuccessJumpVC.h"
#import "IBBaseInfoViewController.h"

@interface QRCodeScanningVC ()

@end

@implementation QRCodeScanningVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 注册观察者
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeAibum:) name:SGQRCodeInformationFromeAibum object:nil];
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeScanning:) name:SGQRCodeInformationFromeScanning object:nil];
}

/** 从相册获取到图片的扫描 */
- (void)SGQRCodeInformationFromeAibum:(NSNotification *)noti {
    NSString *string = noti.object;

    if (![string containsString:@"jiepos"]) {
        [SVProgressHUD showInfoWithStatus:@"无效的二维码！"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([string isURLString]) {
        NSArray *arr = [string componentsSeparatedByString:@"="];
        NSString *qrcodeid = [arr lastObject];
        
        [SVProgressHUD showWithStatus:@"扫描结果识别中..."];
        weakSelf_declare;
        [JPNetTools1_0_2 getQrCodeScanningResultsWithQrcodeid:qrcodeid callback:^(NSString *code, NSString *msg, id resp) {
            JPLog(@"qrcodeid -- %@ 二维码扫描结果 - %@ - %@ - %@", qrcodeid, code, msg, resp);
            if ([code isEqualToString:@"00"]) {
                
                [SVProgressHUD dismiss];
                if ([resp isKindOfClass:[NSDictionary class]]) {
                    JPQRCodeModel *model = [JPQRCodeModel yy_modelWithDictionary:resp];
                    if (model.isUsed) {
                        //  已使用
//                        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//                        jumpVC.jump_bar_code = model.reviewStatus;
//                        [weakSelf.navigationController pushViewController:jumpVC animated:YES];
                        [SVProgressHUD showInfoWithStatus:model.reviewStatus];
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        //  未使用 空码
                        IBBaseInfoViewController *baseInfoVC = [IBBaseInfoViewController new];
                        baseInfoVC.qrcodeid = qrcodeid;
                        [weakSelf.navigationController pushViewController:baseInfoVC animated:YES];
                    }
                }
                
            } else {
                [SVProgressHUD showInfoWithStatus:msg];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else { // 扫描结果为条形码
        
//        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//        jumpVC.jump_bar_code = string;
//        [self.navigationController pusrhViewController:jumpVC animated:YES];
        [SVProgressHUD showInfoWithStatus:@"无效的二维码！"];
    }
}
/** 扫码获取到图片的扫描 */
- (void)SGQRCodeInformationFromeScanning:(NSNotification *)noti {
    NSString *string = noti.object;
    
    if (![string containsString:@"jiepos"]) {
        [SVProgressHUD showInfoWithStatus:@"无效的二维码！"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([string isURLString]) {
        
        NSArray *arr = [string componentsSeparatedByString:@"="];
        NSString *qrcodeid = [arr lastObject];
        
        [SVProgressHUD showWithStatus:@"扫描结果识别中..."];
        weakSelf_declare;
        [JPNetTools1_0_2 getQrCodeScanningResultsWithQrcodeid:qrcodeid callback:^(NSString *code, NSString *msg, id resp) {
            JPLog(@"qrcodeid -- %@ 二维码扫描结果 - %@ - %@ - %@", qrcodeid, code, msg, resp);
            if ([code isEqualToString:@"00"]) {
                [SVProgressHUD dismiss];
                
                if ([resp isKindOfClass:[NSDictionary class]]) {
                    JPQRCodeModel *model = [JPQRCodeModel yy_modelWithDictionary:resp];
                    if (model.isUsed) {
                        //  已使用
//                        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//                        jumpVC.jump_bar_code = model.reviewStatus;
//                        [weakSelf.navigationController pushViewController:jumpVC animated:YES];
                        
                        [SVProgressHUD showInfoWithStatus:model.reviewStatus];
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        //  未使用 空码
                        IBBaseInfoViewController *baseInfoVC = [IBBaseInfoViewController new];
//                        JPBaseInfoViewController *baseInfoVC = [JPBaseInfoViewController new];
                        baseInfoVC.qrcodeid = qrcodeid;
                        [weakSelf.navigationController pushViewController:baseInfoVC animated:YES];
                    }
                }
                
            } else {
                if ([code isEqualToString:@"-1001"]) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                [SVProgressHUD showInfoWithStatus:msg];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        // 扫描结果为条形码
//        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//        jumpVC.jump_bar_code = string;
//        [self.navigationController pushViewController:jumpVC animated:YES];
        [SVProgressHUD showInfoWithStatus:@"无效的二维码！"];
    }
}

- (void)dealloc {
    SGQRCodeLog(@"QRCodeScanningVC - dealloc");
    [SGQRCodeNotificationCenter removeObserver:self];
}

@end
