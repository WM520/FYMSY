//
//  JPLastestNewsDetailViewController.m
//  JiePos
//
//  Created by Jason_LJ on 2017/4/18.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "JPLastestNewsDetailViewController.h"
#import "JPInfoModel.h"
#import <YYText/NSAttributedString+YYText.h>

@interface JPLastestNewsDetailViewController ()

@end

@implementation JPLastestNewsDetailViewController

- (void)getInfoDetailWithInfoID:(NSString *)infoID {
    NSString *url = [NSString stringWithFormat:@"%@%@", JPServerUrl, jp_getInfoDetail_url];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:infoID forKey:@"id"];
    
    weakSelf_declare;
    [JPNetworking postUrl:url params:params progress:nil callback:^(id resp) {
        JPLog(@"公告详情 - %@", resp);
        JPInfoModel *model = [JPInfoModel yy_modelWithDictionary:resp[@"information"]];
        
        [weakSelf handleUIWithTitle:model.title date:model.createTimeSt content:model.content];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    JPLog(@"infoID - %@", _infoID);
    
//    [self getInfoDetailWithInfoID:self.infoID];
    [self handleUIWithTitle:self.model.title date:self.model.createTimeSt content:self.model.content];
}

- (void)handleUIWithTitle:(NSString *)title date:(NSString *)date content:(NSString *)content {
    
    UILabel *titleLab = [self.view viewWithTag:101];
    if (!titleLab) {
        titleLab = [UILabel new];
        titleLab.frame = CGRectMake(JPRealValue(30), JPRealValue(30), kScreenWidth - JPRealValue(60), JPRealValue(30));
        titleLab.font = JP_DefaultsFont;
        titleLab.textColor = JP_Content_Color;
        titleLab.text = title;
        titleLab.tag = 101;
        [self.view addSubview:titleLab];
    }
    UILabel *dateLab = [self.view viewWithTag:102];
    if (!dateLab) {
        dateLab = [UILabel new];
        dateLab.frame = CGRectMake(JPRealValue(30), JPRealValue(90), kScreenWidth - JPRealValue(60), JPRealValue(30));
        dateLab.font = [UIFont systemFontOfSize:JPRealValue(24)];
        dateLab.textColor = JP_NoticeText_Color;
        dateLab.text = date;
        dateLab.tag = 102;
        [self.view addSubview:dateLab];
    }
    YYTextView *contentView = [self.view viewWithTag:103];
    if (!contentView) {
        contentView = [[YYTextView alloc] initWithFrame:CGRectMake(JPRealValue(30), JPRealValue(130), kScreenWidth - JPRealValue(60), kScreenHeight - JPRealValue(130) - 64)];
//        contentView.font = JP_DefaultsFont;
//        contentView.textColor = [UIColor colorWithHexString:@"666666"];
        contentView.backgroundColor = JP_viewBackgroundColor;
        contentView.showsVerticalScrollIndicator = NO;
        contentView.showsHorizontalScrollIndicator = NO;
        contentView.editable = NO;
        contentView.textVerticalAlignment = YYTextVerticalAlignmentTop;
        contentView.tag = 103;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = JPRealValue(16);// 字体的行间距
        
        NSDictionary *attributes = @{
                                     NSFontAttributeName:JP_DefaultsFont,
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666"]
                                     };
        contentView.attributedText = [[NSAttributedString alloc] initWithString:content attributes:attributes];
        [self.view addSubview:contentView];
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
