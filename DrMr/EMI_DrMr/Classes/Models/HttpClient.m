//
//  HttpClient.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/09/09.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "HttpClient.h"

@implementation HttpClient

/**
 *  アカウント認証を行う
 */
- (NSDictionary *)loginAuthenticationRequest:(NSString *)tenant_id loginid:(NSString *)login_id password:(NSString *)password
{
	
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *action = @"user_auth";
	NSString *smartphonesb_cd = Const_smartphonesb_cd;
	NSString *push_device_token = [Configuration pushDeviceToken];
	
	
	//ログインAPIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@&action=%@&contents[login_id]=%@&contents[password]=%@&contents[smartphonesb_cd]=%@&contents[push_device_token]=%@",
						  tenant_id,
						  action,
						  login_id,
						  password,
						  smartphonesb_cd,
						  push_device_token];
	
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
			
				[Configuration setLoginInfo:jsonObject];
				
			}
			else {
							
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:MsgUserAuthenticatedError forKey:@"result_message"];
				
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
			
		}
		else{
			result_message = MsgCommonConnectError;
		}
		
		[mdic setObject:TitleCommonError forKey:@"result_title"];
		[mdic setObject:result_message forKey:@"result_message"];
		
	}
	
	return mdic;
	
}

/**
 *  利用者情報取得する
 */
- (NSDictionary *)getUserInfoRequest
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *tenant_id = Const_tenantid;
	NSString *action = @"get_user";
	
	NSString *contents_tenant_id = Const_tenantid;
	NSString *contents_user_id = [UserFactory userID];
	NSString *contents_user_no = [UserFactory userNO];
	
	
	//利用者情報取得APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@&action=%@&contents[tenant_id]=%@&contents[user_id]=%@&contents[user_no]=%@",
						  tenant_id,
						  action,
						  contents_tenant_id,
						  contents_user_id,
						  contents_user_no];
	
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
				
				[Configuration setUserMaster:jsonObject];
				
				if ([[[Configuration userMaster] valueForKeyPath:@"contents.user_info.inroom_flg"]isEqualToString:@"1"]) {

					[Configuration setCurrentState:YES];
				}
				else {
					[Configuration setCurrentState:NO];
				}
				
			}
			else {
				
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:MsgGetUserError forKey:@"result_message"];
			}
			
		}
		else {
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:MsgGetUserFormatError forKey:@"result_message"];
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

- (NSDictionary *)editNowPasswordRequest:(NSString *)password_now newPassword:(NSString *)password_new
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *tenant_id = Const_tenantid;
	NSString *action = @"edit_password";
	NSString *mode = @"execute";
	NSString *user_id = [UserFactory userID];
	NSString *user_update_dte = [UserFactory userUpdateDte];
	
	
	//利用者情報取得APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@&action=%@&contents[mode]=%@&contents[user_id]=%@&contents[user_update_dte]=%@&contents[now_password]=%@&contents[new_password]=%@",
						  tenant_id,
						  action,
						  mode,
						  user_id,
						  user_update_dte,
						  password_now,
						  password_new];
	
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
				[mdic setObject:MsgEditPasswordSuccess forKey:@"result_message"];
			
			}
			else {
				
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:MsgEditPasswordError forKey:@"result_message"];
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
		}
		else{
			result_message = MsgCommonConnectError;
		}
		
		[mdic setObject:TitleCommonError forKey:@"result_title"];
		[mdic setObject:result_message forKey:@"result_message"];
		
	}
	
	return mdic;
	
}

/**
 *  病院・会社一覧取得
 */
- (NSDictionary *)getCompanyMasterRequest:(NSString *)tenant_id query:(NSString *)query
{

	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *action = @"get_master";
	NSString *contents_object_name = @"company";
	NSString *contents_id = @"";
	NSString *contents_parent_cd = @"";
	NSString *contents_limit = @"";
	NSString *contents_offset = @"";
	NSString *contents_search_condition = query;
	
	
	//病院・企業一覧取得APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@&action=%@&contents[object_name]=%@&contents[id]=%@&contents[parent_cd]=%@&contents[limit]=%@&contents[offset]=%@%@",
						  tenant_id,
						  action,
						  contents_object_name,
						  contents_id,
						  contents_parent_cd,
						  contents_limit,
						  contents_offset,
						  contents_search_condition];
	
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
				[mdic setObject:@"success" forKey:@"result_title"];
				[mdic setObject:@"" forKey:@"result_message"];
				
				[Configuration setCompany:jsonObject];
				
			}
			else {
				
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:@"データの取得に失敗しました(病院・会社)" forKey:@"result_message"];
				
			}
			
		}
		else {
			
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:@"システムエラー" forKey:@"result_message"];
			
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

/**
 *  診療科・部門一覧取得
 */
- (NSDictionary *)getDepartmentMasterRequest:(NSString *)tenant_id query:(NSString *)query
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *action = @"get_master";
	NSString *contents_object_name = @"hospital_department";
	NSString *contents_id = @"";
	NSString *contents_parent_cd = @"";
	NSString *contents_limit = @"";
	NSString *contents_offset = @"";
	NSString *contents_search_condition = query;
	
	
	//診療科・部門一覧取得APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@&action=%@&contents[object_name]=%@&contents[id]=%@&contents[parent_cd]=%@&contents[limit]=%@&contents[offset]=%@%@",
						  tenant_id,
						  action,
						  contents_object_name,
						  contents_id,
						  contents_parent_cd,
						  contents_limit,
						  contents_offset,
						  contents_search_condition];
	
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
				[mdic setObject:@"success" forKey:@"result_title"];
				[mdic setObject:@"" forKey:@"result_message"];
				
				[Configuration setDepartment:jsonObject];
				
			}
			else {
				
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:@"データの取得に失敗しました(診療科・部門)" forKey:@"result_message"];
			}
			
		}
		else {
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:@"システムエラー" forKey:@"result_message"];
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

/**
 *  病院契約会社一覧取得
 */
- (NSDictionary *)getContractMasterRequest:(NSString *)tenant_id query:(NSString *)query
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *action = @"get_master";
	NSString *contents_object_name = @"contract";
	NSString *contents_id = @"";
	NSString *contents_parent_cd = @"";
	NSString *contents_limit = @"";
	NSString *contents_offset = @"";
	NSString *contents_search_condition = query;
	
	//病院契約会社一覧取得APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@&action=%@&contents[object_name]=%@&contents[id]=%@&contents[parent_cd]=%@&contents[limit]=%@&contents[offset]=%@%@",
						  tenant_id,
						  action,
						  contents_object_name,
						  contents_id,
						  contents_parent_cd,
						  contents_limit,
						  contents_offset,
						  contents_search_condition];
	
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
				
				[Configuration setContract:jsonObject];
				
			}
			else {
				
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:MsgGetContractError forKey:@"result_message"];
			}
			
		}
		else {
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:MsgGetContractFormatError forKey:@"result_message"];
		}
	}
	else {
		
		NSString *result_message = @"";
		
		if (self.request_error != nil) {
			
			result_message = [NSString stringWithFormat:@"%@",self.request_error];
			
		} else{
			result_message = MsgGetContractConnectError;
		}
		
		[mdic setObject:TitleCommonError forKey:@"result_title"];
		[mdic setObject:result_message forKey:@"result_message"];
		
	}
	
	return mdic;
	
}

/**
 *  タクシー一覧取得
 */
- (NSDictionary *)getTaxiMasterRequest:(NSString *)tenant_id query:(NSString *)query
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *action = @"get_master";
	NSString *contents_object_name = @"taxi";
	NSString *contents_id = @"";
	NSString *contents_parent_cd = @"";
	NSString *contents_limit = @"";
	NSString *contents_offset = @"";
	NSString *contents_search_condition = query;
	
	
	//タクシー一覧取得APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@&action=%@&contents[object_name]=%@&contents[id]=%@&contents[parent_cd]=%@&contents[limit]=%@&contents[offset]=%@%@",
						  tenant_id,
						  action,
						  contents_object_name,
						  contents_id,
						  contents_parent_cd,
						  contents_limit,
						  contents_offset,
						  contents_search_condition];
	
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
				[mdic setObject:@"success" forKey:@"result_title"];
				[mdic setObject:@"" forKey:@"result_message"];
				
				[Configuration setTaxi:jsonObject];
				
			}
			else {
				
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:@"データの取得に失敗しました(タクシー会社)" forKey:@"result_message"];
			}
			
		}
		else {
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:@"システムエラー" forKey:@"result_message"];
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

/**
 *  Beacon管理一覧取得
 */
- (NSDictionary *)getBeaconMasterRequest:(NSString *)tenant_id query:(NSString *)query
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *action = @"get_master";
	NSString *contents_object_name = @"beacon";
	NSString *contents_id = @"";
	NSString *contents_parent_cd = @"";
	NSString *contents_limit = @"";
	NSString *contents_offset = @"";
	NSString *contents_search_condition = query;
	
	//Beacon一覧取得APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@&action=%@&contents[object_name]=%@&contents[id]=%@&contents[parent_cd]=%@&contents[limit]=%@&contents[offset]=%@%@",
						  tenant_id,
						  action,
						  contents_object_name,
						  contents_id,
						  contents_parent_cd,
						  contents_limit,
						  contents_offset,
						  contents_search_condition];
	
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
				
				[Configuration setBeacon:jsonObject];
				
			}
			else {
				
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:MsgGetBeaconError forKey:@"result_message"];
			}
			
		}
		else {
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:MsgGetBeaconFormatError forKey:@"result_message"];
		}
	}
	else {
		
		NSString *result_message = @"";
		
		if (self.request_error != nil) {
			
			result_message = [NSString stringWithFormat:@"%@",self.request_error];
			
		} else{
			result_message = MsgGetBeaconConnectError;
		}
		
		[mdic setObject:TitleCommonError forKey:@"result_title"];
		[mdic setObject:result_message forKey:@"result_message"];
		
	}
	
	return mdic;
	
}



/**
 *  メッセージを送信
 */
- (NSDictionary *)sendMessageRequest:(NSDictionary *)userDic message:(NSString *)message
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
		
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *tenant_id = Const_tenantid;
	NSString *action = @"send_message";
	NSString *talk_id = @"";
	NSString *to_user_id = userDic[@"user_id"];//相手先の利用者ID
	NSString *to_user_tenant_id = Const_tenantid;//相手先のテナントID
	NSString *message_body = message;
	NSString *from_user_id = [UserFactory userID];
	NSString *from_user_tenant_id = Const_tenantid;
	NSString *delivery_dte = [Utility currentDate:@"yyyy-MM-dd HH:mm:ss"];
	
	//メッセージ送信APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@"
						  @"&action=%@"
						  @"&contents[talk_id]=%@"
						  @"&contents[to_user_id]=%@"
						  @"&contents[to_user_tenant_id]=%@"
						  @"&contents[message_body]=%@"
						  @"&contents[from_user_id]=%@"
						  @"&contents[from_user_tenant_id]=%@"
						  @"&contents[delivery_dte]=%@",
						  tenant_id,
						  action,
						  talk_id,
						  to_user_id,
						  to_user_tenant_id,
						  message_body,
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

/**
 *  メッセージを取得
 */
- (NSDictionary *)getMessagesRequest:(NSDictionary *)userDic displayCt:(NSString *)display_ct pageNm:(NSString *)page_num
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *tenant_id = Const_tenantid;
	NSString *action = @"get_messages";
	NSString *talk_id = @"";
	NSString *to_user_id = [UserFactory userID];//利用者ID
	NSString *to_user_tenant_id =  [UserFactory tenantID];//利用者テナントID
	NSString *from_user_id = userDic[@"user_id"];//相手先利用者ID
	NSString *from_user_tenant_id = Const_tenantid;//相手先テナントID
	
	NSString *page_display_ct = display_ct;//取得件数
	NSString *start_page_num = page_num;//取得開始位置
	
	//メッセージ一覧取得APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@"
						  @"&action=%@"
						  @"&contents[talk_id]=%@"
						  @"&contents[to_user_id]=%@"
						  @"&contents[to_user_tenant_id]=%@"
						  @"&contents[from_user_id]=%@"
						  @"&contents[from_user_tenant_id]=%@"
						  @"&contents[page_display_ct]=%@"
						  @"&contents[start_page_num]=%@",
						  tenant_id,
						  action,
						  talk_id,
						  to_user_id,
						  to_user_tenant_id,
						  from_user_id,
						  from_user_tenant_id,
						  page_display_ct,
						  start_page_num];
	
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
				
				NSString *result_message = [jsonObject valueForKeyPath:@"contents.detail_message"];
				
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:result_message forKey:@"result_message"];
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

- (NSDictionary *)getUnreadMessagesRequest
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
	
	//接続先URL
	NSString *urlStr = RakuzaApiURL;
	
	
	self.url = [NSURL URLWithString:urlStr];
	
	NSString *tenant_id = Const_tenantid;
	NSString *action = @"get_unread_messages";
	NSString *to_user_id = [UserFactory userID];//利用者ID
	NSString *to_user_tenant_id = Const_tenantid;//利用者テナントID
	
	//メッセージ一覧取得APIリクエストデータ
	NSString *postData = [NSString stringWithFormat:@"tenant_id=%@"
						  @"&action=%@"
						  @"&contents[to_user_id]=%@"
						  @"&contents[to_user_tenant_id]=%@",
						  tenant_id,
						  action,
						  to_user_id,
						  to_user_tenant_id];
	
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
				
				[Configuration setUnreadMessages:jsonObject];
				
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

