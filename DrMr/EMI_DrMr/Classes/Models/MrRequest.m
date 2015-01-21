//
//  MrRequest.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/08/25.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "MrRequest.h"


@implementation MrRequest

- (NSDictionary *)getDrListRequest
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *tenant_id = Const_tenantid;
	NSString *action = @"get_group_leaders";
	NSString *user_id = [UserFactory userID];
	NSString *user_tenant_id = Const_tenantid;
	NSString *company_cd = @"";
	
	
	if ([Configuration currentBeaconLocation].length!=0) {

		company_cd = [Configuration currentBeaconLocation];
		
	}
	else if ([Configuration currentGPSLocation].length!=0 ) {

		company_cd = [Configuration currentGPSLocation];
		
	}
			
	//Dr一覧取得APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@"
						  @"&action=%@"
						  @"&contents[user_id]=%@"
						  @"&contents[user_tenant_id]=%@"
						  @"&contents[company_cd]=%@",
						  tenant_id,
						  action,
						  user_id,
						  user_tenant_id,
						  company_cd];
	
	self.body = postData;

	//送信実行
	NSData *response_data = [self submit];
	
	if (response_data != nil) {
		
		NSError *error=nil;
	
		id jsonObject = [NSJSONSerialization JSONObjectWithData:response_data
														options:kNilOptions
														  error:&error];
		
		if ([jsonObject isKindOfClass:[NSArray class]]) {
			jsonObject = [NSArray arrayWithArray:jsonObject];
		}
		else {
			jsonObject = [NSDictionary dictionaryWithDictionary:jsonObject];
		}
		
		if (0 == [error code]) {
			
			// 成功時
			if ([[jsonObject valueForKey:@"status"]isEqualToString:APIResponseNormalStatusCode]) {
				
				[mdic setDictionary:jsonObject];
				[mdic setObject:@"" forKey:@"result_title"];
				[mdic setObject:@"" forKey:@"result_message"];
				
				[Configuration setUserListMaster:jsonObject];
				
			}
			else {
								
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:MsgGetgetDrListError forKey:@"result_message"];
			}
			
		}
		else {
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:MsgGetgetDrListFormatError forKey:@"result_message"];
		}
	}
	else {
		
		NSString *result_message = @"";
		
		if (self.request_error != nil) {
			
			result_message = [NSString stringWithFormat:@"%@",self.request_error];
			
		} else{
			result_message = MsgGetgetDrListConnectError;
		}
		
		[mdic setObject:TitleCommonError forKey:@"result_title"];
		[mdic setObject:result_message forKey:@"result_message"];
		
	}
	
	return mdic;
	
}

- (NSDictionary *)applyRequest:(NSDictionary *)drDic
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
		
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *tenant_id = Const_tenantid;
	NSString *action = @"apply_request";
	NSString *user_id = [UserFactory userID];
	NSString *user_tenant_id = Const_tenantid;
	NSString *request_message = @"";
	NSString *team_id = [[drDic valueForKeyPath:@"group.group_user_id"]objectAtIndex:0];
	NSString *team_tenant_id = Const_tenantid;
	
	
	//Dr一覧取得APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@"
						  @"&action=%@"
						  @"&contents[user_id]=%@"
						  @"&contents[user_tenant_id]=%@"
						  @"&contents[request_message]=%@"
						  @"&contents[team_id]=%@"
						  @"&contents[team_tenant_id]=%@",
						  tenant_id,
						  action,
						  user_id,
						  user_tenant_id,
						  request_message,
						  team_id,
						  team_tenant_id];
	
	self.body = postData;
	
	//送信実行
	NSData *response_data = [self submit];
	
	if (response_data != nil) {
		
		NSError *error=nil;
		
		id jsonObject = [NSJSONSerialization JSONObjectWithData:response_data
														options:kNilOptions
														  error:&error];
		
		if ([jsonObject isKindOfClass:[NSArray class]]) {
			jsonObject = [NSArray arrayWithArray:jsonObject];
		}
		else {
			jsonObject = [NSDictionary dictionaryWithDictionary:jsonObject];
		}
		
		if (0 == [error code]) {
			
			// 成功時
			if ([[jsonObject valueForKey:@"status"]isEqualToString:APIResponseNormalStatusCode]) {
							
				[mdic setDictionary:jsonObject];
				[mdic setObject:@"" forKey:@"result_title"];
				[mdic setObject:MsgApprovalSuccess forKey:@"result_message"];
								
			}
			else {
				
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:MsgApprovalError forKey:@"result_message"];
			}
			
		}
		else {
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:MsgApprovalFormatError forKey:@"result_message"];
		}
	}
	else {
		
		NSString *result_message = @"";
		
		if (self.request_error != nil) {
			
			result_message = [NSString stringWithFormat:@"%@",self.request_error];
			
		} else{
			result_message = MsgApprovalConnectError;
		}
		
		[mdic setObject:TitleCommonError forKey:@"result_title"];
		[mdic setObject:result_message forKey:@"result_message"];
		
	}
	
	return mdic;
	
}

- (NSDictionary *)changeUserEditCallpermitRequest:(BOOL)yesno
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *tenant_id = Const_tenantid;
	NSString *action = @"edit_user";
	
	NSString *user_id = [UserFactory userID];
	NSString *user_high_class_cd = [UserFactory userHighClassCd];
	NSString *update_date = [UserFactory userUpdateDte];
	NSString *callpermit_flg = @"";
	
	if (yesno) {
		callpermit_flg = @"1";
	}
	else {
		callpermit_flg = @"0";
	}
	
	//呼出可否ステータス更新APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@&action=%@&contents[user_id]=%@&contents[user_high_class_cd]=%@&contents[update_date]=%@&contents[callpermit_flg]=%@",
						  tenant_id,
						  action,
						  user_id,
						  user_high_class_cd,
						  update_date,
						  callpermit_flg];
	
	self.body = postData;
	
	//送信実行
	NSData *response_data = [self submit];
	
	if (response_data != nil) {
		
		NSError *error=nil;
		
		id jsonObject = [NSJSONSerialization JSONObjectWithData:response_data
														options:kNilOptions
														  error:&error];
		
		if ([jsonObject isKindOfClass:[NSArray class]]) {
			jsonObject = [NSArray arrayWithArray:jsonObject];
		}
		else {
			jsonObject = [NSDictionary dictionaryWithDictionary:jsonObject];
		}
		
		if (0 == [error code]) {
			
			// 成功時
			if ([[jsonObject valueForKey:@"status"]isEqualToString:APIResponseNormalStatusCode]) {
				
				[mdic setDictionary:jsonObject];
				[mdic setObject:@"" forKey:@"result_title"];
				[mdic setObject:@"" forKey:@"result_message"];
				
			}
			else {
								
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:MsgEditMrCallpermitError forKey:@"result_message"];
			}
			
		}
		else {
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:MsgEditMrCallpermitFormatError forKey:@"result_message"];
		}
	}
	else {
		
		NSString *result_message = @"";
		
		if (self.request_error != nil) {
			
			result_message = [NSString stringWithFormat:@"%@",self.request_error];
			
		} else{
			result_message = MsgEditMrCallpermitConnectError;
		}
		
		[mdic setObject:TitleCommonError forKey:@"result_title"];
		[mdic setObject:result_message forKey:@"result_message"];
		
	}
	
	return mdic;
	
}

- (NSDictionary *)changeUserEditInroomRequest:(BOOL)yesno
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *tenant_id = Const_tenantid;
	NSString *action = @"edit_user";
	
	NSString *user_id = [UserFactory userID];

	NSString *user_high_class_cd = [UserFactory userHighClassCd];
	NSString *update_date = [UserFactory userUpdateDte];
		
	/**
	 *  MRの場合のみ利用。DRの場合はなし
	 */
	NSString *company_location = @"";
	
	if ([Configuration currentBeaconLocation].length!=0) {
		
		company_location = [Configuration currentBeaconLocation];
		
	}
	else if ([Configuration currentGPSLocation].length!=0 ) {
		
		company_location = [Configuration currentGPSLocation];
		
	}
	
	NSString *inroom_flg = @"";
	
	if (yesno) {
		inroom_flg = @"1";
	}
	else {
		inroom_flg = @"0";
	}
	
	//院内・院外ステータス更新APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@&action=%@&contents[user_id]=%@&contents[user_high_class_cd]=%@&contents[update_date]=%@&contents[company_location]=%@&contents[inroom_flg]=%@",
						  tenant_id,
						  action,
						  user_id,
						  user_high_class_cd,
						  update_date,
						  company_location,
						  inroom_flg];
	
	self.body = postData;
	
	//送信実行
	NSData *response_data = [self submit];
	
	if (response_data != nil) {
		
		NSError *error=nil;
		
		id jsonObject = [NSJSONSerialization JSONObjectWithData:response_data
														options:kNilOptions
														  error:&error];
		
		if ([jsonObject isKindOfClass:[NSArray class]]) {
			jsonObject = [NSArray arrayWithArray:jsonObject];
		}
		else {
			jsonObject = [NSDictionary dictionaryWithDictionary:jsonObject];
		}
		
		if (0 == [error code]) {
			
			// 成功時
			if ([[jsonObject valueForKey:@"status"]isEqualToString:APIResponseNormalStatusCode]) {
				
				[mdic setDictionary:jsonObject];
				[mdic setObject:@"" forKey:@"result_title"];
				[mdic setObject:@"" forKey:@"result_message"];
				
				
			}
			else {
								
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:MsgCommonError forKey:@"result_message"];
			}
			
		}
		else {
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:MsgCommonFormatError forKey:@"result_message"];
		}
	}
	else {
		
		NSString *result_message = @"";
		
		if (self.request_error != nil) {
			
			result_message = [NSString stringWithFormat:@"%@",self.request_error];
			
		} else{
			result_message = MsgCommonConnectError;
		}
		
		[mdic setObject:TitleCommonError forKey:@"result_title"];
		[mdic setObject:result_message forKey:@"result_message"];
		
	}
	
	return mdic;
	
}

@end
