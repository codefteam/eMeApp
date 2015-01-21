//
//  UserFactory.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/07.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserFactory : NSObject

+ (NSString *)tenantID;
+ (NSString *)userID;
+ (NSString *)userNO;
+ (NSString *)userCompany;
+ (NSString *)inRoomFlg;
+ (NSString *)callpermitFlg;
+ (NSString *)userHighClassCd;
+ (NSString *)userUpdateDte;

@end
