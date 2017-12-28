//
//  JPMacro_Url.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/13.
//  Copyright © 2017年 Jason. All rights reserved.
//

#ifndef JPMacro_Url_h
#define JPMacro_Url_h

#import <UIKit/UIKit.h>

#pragma mark - ServerUrl

//// !!!:测试环境   http://59.56.101.183:11830
////  极光推送alias
//static NSString *const ib_JPushAliasUrl = @"http://139.196.226.55:8083/cpay-acps-push/fyMchnt/ios/login";
////  退出登录
//static NSString *const ib_JPushLogoutUrl = @"http://139.196.226.55:8083/cpay-acps-push/fyMchnt/ios/logout";

// !!!:生产环境
//  极光推送alias
static NSString *const ib_JPushAliasUrl = @"http://59.56.101.183:11830/cpay-acps-push/fyMchnt/ios/login";
//  退出登录
static NSString *const ib_JPushLogoutUrl = @"http://59.56.101.183:11830/cpay-acps-push/fyMchnt/ios/logout";


// !!!: 生产环境
#define JPServerUrl @"http://wx.jiepos.com/jpay-spmp/"
// !!!: 测试服务器
//#define JPServerUrl @"http://139.196.226.55:8079/jpay-spmp/"
// !!!: 本地测试接口
//#define JPServerUrl @"http://192.168.14.110:8080/jpay-spmp/"

//  v1.0.2之后接口
#define JPNewServerUrl [NSString stringWithFormat:@"%@app/jbb", JPServerUrl]
#define JPImgServerUrl [NSString stringWithFormat:@"%@app/jbb/img", JPServerUrl]


#pragma mark - 接口地址
// !!!: 登录
static NSString *const jp_login_url = @"jbalogin/login";
// !!!: 发送验证码
static NSString *const jp_sendCode_url = @"jbalogin/sendCode";
// !!!: 重置密码
static NSString *const jp_resetPsw_url = @"jbalogin/resetPwd";
// !!!: 首页折线图数据获取
static NSString *const jp_getSumDayTransAt_url = @"jbaflow/getSumDayTransAt";
// !!!: 交易流水查询列表、消息通知交易列表
static NSString *const jp_getFlowListByCond_url = @"jbaflow/getFlowListByCond";
// !!!: 交易流水详情
static NSString *const jp_getDetailByTraNoAndRecDt_url = @"jbaflow/getDetailByTraNoAndRecDt";
// !!!: 当月累计交易金额、当月累计手续费
static NSString *const jp_getSumCurMonth_url = @"jbaflow/getSumCurMonth";
// !!!: 个人中心-修改登录密码
static NSString *const jp_modPwd_url = @"jbalogin/modPwd";
// !!!: 公告信息：详情
static NSString *const jp_getInfoDetail_url = @"jbainfo/getInfoDetail";
// !!!: 公告信息：列表
static NSString *const jp_getInfoList_url = @"jbainfo/getInfoList";
// !!!: 交易流水查询条件初始化：商户名称、交易状态、支付方式
static NSString *const jp_showCondFLow_url = @"jbaflow/showCondFLow";
// !!!: 商户二维码接口
static NSString *const jp_qrcodeAp_url = @"jbalogin/qrcodeAp";
// !!!: 常见问题
static NSString *const jp_question_url = @"http://wx.jiepos.com/jpay-spmp/vchat/problem.html";

// !!!: 鼓励金接口
static NSString *const jp_encourage_url = @"jbaflow/transactionfees";

// !!!: 强制更新
static NSString *const jp_version_url = @"/jbalogin/checkAppCpoy";

#endif /* JPMacro_Url_h */
