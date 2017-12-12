//
//  JPDealStateModel.h
//  JiePos
//
//  Created by Jason_LJ on 2017/4/19.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPDealStateModel : NSObject
/**
 "parentName": null,
 "id": 179,
 "createTime": null,
 "parentId": 176,
 "type": "-1",
 "name": "交易失败"
 */
//@property (nonatomic, copy) NSString *parentName;
@property (nonatomic, copy) NSString *businessNameId;
//@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
@end
