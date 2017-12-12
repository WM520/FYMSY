//
//  JPConst.h
//  JiePos
//
//  Created by Jason_LJ on 2017/6/27.
//  Copyright © 2017年 Jason. All rights reserved.
//

#ifndef JPConst_h
#define JPConst_h

//  商户自助信息审核进度
typedef NS_ENUM(NSUInteger, JPApplyProgress) {
    JPApplyProgressNotThrough    = 1,   //  审核不通过
    JPApplyProgressApplying      = 2,   //  审核中
    JPApplyProgressThrough       = 3,   //  审核通过
};

#endif /* JPConst_h */
