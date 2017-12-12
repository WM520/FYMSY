//
//  JPRegisterProgressView.h
//  JiePos
//
//  Created by Jason_LJ on 2017/5/23.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JPProgressOfApplySteps) {
    JPStepsBaseInfo         = 1,    //  基本信息
    JPStepsBillingInfo      = 2,    //  结算信息
    JPStepsCertificateInfo  = 3,    //  证件信息
};
@interface JPRegisterProgressView : UIView
@property (nonatomic, assign) JPProgressOfApplySteps steps;
@end
