//
//  UserFactory.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/07.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "UserFactory.h"

@implementation UserFactory

+ (NSString *)tenantID
{
	return [[Configuration loginInfo] valueForKeyPath:@"contents.user_info.tenant_id"];
}

+ (NSString *)userID
{
	return [[Configuration loginInfo] valueForKeyPath:@"contents.user_info.user_id"];
}

+ (NSString *)userNO
{
	return [[Configuration loginInfo] valueForKeyPath:@"contents.user_info.user_no"];
}

+ (NSString *)userHighClassCd
{
	return [[Configuration userMaster] valueForKeyPath:@"contents.user_info.user_high_class_cd"];
}

+ (NSString *)userCompany
{
	return [[Configuration userMaster] valueForKeyPath:@"contents.user_info.company"];
}

+ (NSString *)inRoomFlg
{
	return [NSString stringWithString:[[Configuration userMaster] valueForKeyPath:@"contents.user_info.inroom_flg"]];
}

+ (NSString *)callpermitFlg
{
	return [NSString stringWithString:[[Configuration userMaster] valueForKeyPath:@"contents.user_info.callpermit_flg"]];
}

+ (NSString *)userUpdateDte
{
	return [[Configuration userMaster] valueForKeyPath:@"contents.user_info.update_date"];
}


@end
