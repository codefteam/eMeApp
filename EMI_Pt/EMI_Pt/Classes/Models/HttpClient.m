//
//  HttpClient.m
//  EMI_Pt
//
//  Created by esukei on 2014/07/22.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "HttpClient.h"
#import "Configuration.h"


@implementation HttpClient

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
				[mdic setObject:@"" forKey:@"result_title"];
				[mdic setObject:@"" forKey:@"result_message"];
				
				[Configuration setCompany:jsonObject];
				
			}
			else {
				
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:MsgGetCompanyError forKey:@"result_message"];
				
			}
			
		}
		else {
			
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:MsgGetCompanyFormatError forKey:@"result_message"];
			
		}
	}
	else {
		
		NSString *result_message = @"";
		
		if (self.request_error != nil) {
			
			result_message = [NSString stringWithFormat:@"%@",self.request_error];
			
		} else{
			result_message = MsgGetCompanyConnectError;
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
	NSString *contents_parent_cd = [[Configuration selectCompany]valueForKey:@"parent_cd"];
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
				[mdic setObject:@"" forKey:@"result_title"];
				[mdic setObject:@"" forKey:@"result_message"];
				
				[Configuration setDepartment:jsonObject];
				
			}
			else {
				
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:MsgGetDepartmentError forKey:@"result_message"];
			}
			
		}
		else {
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:MsgGetDepartmentFormatError forKey:@"result_message"];
		}
	}
	else {
		
		NSString *result_message = @"";
		
		if (self.request_error != nil) {
			
			result_message = [NSString stringWithFormat:@"%@",self.request_error];
			
		} else{
			result_message = MsgGetDepartmentConnectError;
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
				[mdic setObject:@"" forKey:@"result_title"];
				[mdic setObject:@"" forKey:@"result_message"];
				
				[Configuration setTaxi:jsonObject];
				
			}
			else {
				
				[mdic setDictionary:jsonObject];
				[mdic setObject:TitleCommonError forKey:@"result_title"];
				[mdic setObject:MsgGetTaxiError forKey:@"result_message"];
			}
			
		}
		else {
			[mdic setObject:TitleCommonError forKey:@"result_title"];
			[mdic setObject:MsgGetTaxiFormatError forKey:@"result_message"];
		}
	}
	else {
		
		NSString *result_message = @"";
		
		if (self.request_error != nil) {
			
			result_message = [NSString stringWithFormat:@"%@",self.request_error];
			
		} else{
			result_message = MsgGetTaxiConnectError;
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

@end
