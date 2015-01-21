//
//  DrRequest.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/08/25.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "DrRequest.h"


@implementation DrRequest

- (NSDictionary *)getMrListRequest:(NSDictionary *)userDic
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *tenant_id = Const_tenantid;
	NSString *action = @"get_mr_list";
	NSString *user_id = [UserFactory userID];
	NSString *user_high_class_cd = Const_user_high_class_cd;
	NSString *user_tenant_id = Const_tenantid;
	NSString *team_id = [[userDic valueForKeyPath:@"contents.group_info.user_id"]objectAtIndex:0];
	NSString *team_tenant_id = Const_tenantid;

	
	//MR一覧取得APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@"
						  @"&action=%@"
						  @"&contents[user_id]=%@"
						  @"&contents[user_high_class_cd]=%@"
						  @"&contents[user_tenant_id]=%@"
						  @"&contents[team_id]=%@"
						  @"&contents[team_tenant_id]=%@",
						  tenant_id,
						  action,
						  user_id,
						  user_high_class_cd,
						  user_tenant_id,
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
				[mdic setObject:@"" forKey:@"result_message"];
				
				[Configuration setUserListMaster:jsonObject];
				
			}
			else {
								
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:MsgGetgetMrListError forKey:@"result_message"];
			}
			
		}
		else {
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:MsgGetgetMrListFormatError forKey:@"result_message"];
		}
	}
	else {
		
		NSString *result_message = @"";
		
		if (self.request_error != nil) {
			
			result_message = [NSString stringWithFormat:@"%@",self.request_error];
			
		} else{
			result_message = MsgGetgetMrListConnectError;
		}
		
		[mdic setObject:TitleCommonError forKey:@"result_title"];
		[mdic setObject:result_message forKey:@"result_message"];
		
	}
	
	return mdic;
	
}

/**
 *  MRコミュニケート申請承認API
 */
- (NSDictionary *)applyAgreeRequest:(NSDictionary *)mrDic
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *tenant_id = Const_tenantid;
	NSString *action = @"apply_agree_request";
	NSString *user_id = [UserFactory userID];
	NSString *user_tenant_id = Const_tenantid;
	NSString *team_id = [[[Configuration userMaster] valueForKeyPath:@"contents.group_info.user_id"]objectAtIndex:0];
	NSString *team_tenant_id = Const_tenantid;
	NSString *request_user_id = [mrDic objectForKey:@"user_id"];//MRの利用者ID
	NSString *request_user_name = [mrDic objectForKey:@"user_name"];//MRの利用者名
	NSString *request_user_tenant_id = Const_tenantid;//固定
	NSString *request_tenant_id = Const_tenantid;//固定
	NSString *request_id = [mrDic objectForKey:@"request_id"];//
	NSString *request_dte = [mrDic objectForKey:@"request_dte"];
	NSString *request_type = @"0001";//0001:承認、0002:拒否
		
	
	//MR一覧取得APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@"
						  @"&action=%@"
						  @"&contents[user_id]=%@"
						  @"&contents[user_tenant_id]=%@"
						  @"&contents[team_id]=%@"
						  @"&contents[team_tenant_id]=%@"
						  @"&contents[request_user_id]=%@"
						  @"&contents[request_user_name]=%@"
						  @"&contents[request_user_tenant_id]=%@"
						  @"&contents[request_tenant_id]=%@"
						  @"&contents[request_id]=%@"
						  @"&contents[request_dte]=%@"
						  @"&contents[request_type]=%@",
						  tenant_id,
						  action,
						  user_id,
						  user_tenant_id,
						  team_id,
						  team_tenant_id,
						  request_user_id,
						  request_user_name,
						  request_user_tenant_id,
						  request_tenant_id,
						  request_id,
						  request_dte,
						  request_type];
	
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
				[mdic setObject:MsgApprovalAgreeError forKey:@"result_message"];
			}
			
		}
		else {
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:MsgApprovalAgreeFormatError forKey:@"result_message"];
		}
	}
	else {
		
		NSString *result_message = @"";
		
		if (self.request_error != nil) {
			
			result_message = [NSString stringWithFormat:@"%@",self.request_error];
			
		} else{
			result_message = MsgApprovalAgreeConnectError;
		}
		
		[mdic setObject:TitleCommonError forKey:@"result_title"];
		[mdic setObject:result_message forKey:@"result_message"];
		
	}
	
	return mdic;
	
}

/**
 *  MR呼び出しを行う
 */
- (NSDictionary *)callMRRequest:(NSDictionary *)mrDic
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *tenant_id = Const_tenantid;
	NSString *action = @"call_mr";
	
	NSString *talk_id = @"";
	NSString *to_user_id = [mrDic objectForKey:@"user_id"];
	NSString *to_user_tenant_id = Const_tenantid;
	NSString *from_user_id = [UserFactory userID];
	NSString *from_user_tenant_id = Const_tenantid;
	NSString *delivery_dte = [Utility currentDate:@"yyyy-MM-dd hh:mm:ss"];

	
	//MR呼び出しAPIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@"
						  @"&action=%@"
						  @"&contents[talk_id]=%@"
						  @"&contents[to_user_id]=%@"
						  @"&contents[to_user_tenant_id]=%@"
						  @"&contents[from_user_id]=%@"
						  @"&contents[from_user_tenant_id]=%@"
						  @"&contents[delivery_dte]=%@",
						  tenant_id,
						  action,
						  talk_id,
						  to_user_id,
						  to_user_tenant_id,
						  from_user_id,
						  from_user_tenant_id,
						  delivery_dte];
	
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
				[mdic setObject:TitleCallMrSuccess forKey:@"result_title"];
				[mdic setObject:MsgCallMrSuccess forKey:@"result_message"];
			
			}
			else {
								
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:MsgCallMrError forKey:@"result_message"];
			}
			
		}
		else {
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:MsgCallMrFormatError forKey:@"result_message"];
		}
	}
	else {
		
		NSString *result_message = @"";
		
		if (self.request_error != nil) {
			
			result_message = [NSString stringWithFormat:@"%@",self.request_error];
			
		} else{
			result_message = MsgCallMrConnectError;
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
				[mdic setObject:MsgEditDrCallpermitError forKey:@"result_message"];
			}
			
		}
		else {
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:MsgEditDrCallpermitFormatError forKey:@"result_message"];
		}
	}
	else {
		
		NSString *result_message = @"";
		
		if (self.request_error != nil) {
			
			result_message = [NSString stringWithFormat:@"%@",self.request_error];
			
		} else{
			result_message = MsgEditDrCallpermitConnectError;
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
	NSString *inroom_flg = @"";
	
	if (yesno) {
		inroom_flg = @"1";
	}
	else {
		inroom_flg = @"0";
	}
	
	//院内・院外ステータス更新APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@&action=%@&contents[user_id]=%@&contents[user_high_class_cd]=%@&contents[update_date]=%@&contents[inroom_flg]=%@",
						  tenant_id,
						  action,
						  user_id,
						  user_high_class_cd,
						  update_date,
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
