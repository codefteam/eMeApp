//
//  AccountService.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/06.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "AccountService.h"
#import "HttpClient.h"
#import "DrService.h"
#import "MrService.h"

#import "GPSManager.h"
#import "BluetusManager.h"

@implementation AccountService

+ (NSDictionary *)loginAuthentication:(NSString *)tenantid loginid:(NSString *)login_id password:(NSString *)password
{
	
	[MasterService clearData];
	
	NSDictionary *dic;

	HttpClient *httpClient = [[HttpClient alloc]init];
	dic = [httpClient loginAuthenticationRequest:tenantid loginid:login_id password:password];
	
	if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
		
		dic = [MasterService getUserInfo];
		
		if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {

			dic = [MasterService getBeaconMaster];
			
			if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {


				//DRの場合、利用者
				//MRの場合、病院契約会社一覧取得に該当する病院マスタを取得
				if ([[UserFactory userHighClassCd]isEqualToString:Dr_user_high_class_cd]) {
					
					dic = [MasterService getCompanyMaster];
			
					if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
						
						//レスポンスのコピー
						NSMutableDictionary *copyDic = [NSMutableDictionary dictionaryWithDictionary:dic];
						
						//病院・会社格納
						NSMutableDictionary *company_list = [NSMutableDictionary dictionary];
						
						//病院・会社一覧生成
						NSMutableDictionary *company_info = [NSMutableDictionary dictionaryWithDictionary:[copyDic valueForKeyPath:[NSString stringWithFormat:@"contents.data.%@", [UserFactory userCompany]]]];

						
						[company_list setObject:company_info forKey:[UserFactory userCompany]];
						
						[Configuration setCompany:company_list];
						
					}
					
				}
				else {
					
					NSString *queryStr = [NSString stringWithFormat:@"&contents[search_condition][contract_company]=%@",[UserFactory userCompany]];
					
					dic = [MasterService getContractMaster:queryStr];
					
					if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
						
						dic = [MasterService getCompanyMaster];
						
						if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
					
							//病院一覧レスポンスのコピー
							NSMutableDictionary *copyCompanyDic = [NSMutableDictionary dictionaryWithDictionary:dic];
							NSMutableDictionary *copyContractDic = [NSMutableDictionary dictionaryWithDictionary:[Configuration contract]];
							
							//病院・会社格納
							NSMutableDictionary *company_list = [NSMutableDictionary dictionary];
							
							NSMutableDictionary *contract_list = [NSMutableDictionary dictionaryWithDictionary:[copyContractDic valueForKeyPath:[NSString stringWithFormat:@"contents.data"]]];
							
							
							for (NSString *key in contract_list.allKeys) {
								
								//病院・会社一覧生成
								NSMutableDictionary *contract_info = [NSMutableDictionary dictionaryWithDictionary:[contract_list objectForKey:key]];
								
								NSString *company_code = [contract_info objectForKey:@"company"];
								
								NSMutableDictionary *company_info = [NSMutableDictionary dictionaryWithDictionary:[copyCompanyDic valueForKeyPath:[NSString stringWithFormat:@"contents.data.%@", company_code]]];
								
								if (company_info.count!=0) {
									[company_list setObject:company_info forKey:company_code];
								}
				
							}
							
							[Configuration setCompany:company_list];

						}

					}
					
				}
			}
		}
	}
	
	return dic;
	
}

+ (NSDictionary *)logout
{

	NSDictionary *dic;
	
	[[GPSManager sharedManager]stopMonitoring];
	[[BluetusManager sharedManager]stopScanning];
	
	
	if ([[UserFactory userHighClassCd] isEqualToString:Dr_user_high_class_cd]) {
		
		dic = [DrService changeUserEditInroom:NO];
	}
	else {
		
		dic = [MrService changeUserEditInroom:NO];
	}
	
	if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {

		dic = @{@"status":APIResponseNormalStatusCode,
				@"result_title":@"",
				@"result_message":@""};
	}
	else {
		dic = @{@"status":TitleCommonError,
				@"result_title":TitleCommonError,
				@"result_message":MsgLogoutError};
	}
	
	return dic;
}

+ (NSDictionary *)changePassword:(NSString *)password_now password_new:(NSString *)password_new
{
	HttpClient *httpClient = [[HttpClient alloc]init];

	return [httpClient editNowPasswordRequest:password_now newPassword:password_new];
	
}

+ (NSDictionary *)isLoginValidate:(NSString *)loginid password:(NSString *)password
{
	
	NSDictionary *dic;
	
	if (loginid.length==0) {
		
		dic = @{@"status":@"",
				@"result_title":@"",
				@"result_message":MsgInputLoginIDError};
	}
	else if (password.length==0) {
		dic = @{@"status":@"",
				@"result_title":@"",
				@"result_message":MsgInputPasswordError};
	}
	else {
		dic = @{@"status":APIResponseNormalStatusCode,
				@"result_title":@"",
				@"result_message":@""};
	}
	
	
	return dic;
}

+ (NSDictionary *)isPasswordValidate:(NSString *)password_now password_new:(NSString *)password_new password_check:(NSString *)password_check
{
	NSDictionary *dic;
	
	if (password_now.length==0) {
		
		dic = @{@"status":@"",
				@"result_title":@"",
				@"result_message":MsgInputPasswordNowError};
	}
	else if (password_new.length==0) {
		dic = @{@"status":@"",
				@"result_title":@"",
				@"result_message":MsgInputPasswordNewError};
	}
	else if (password_check.length==0) {
		
		dic = @{@"status":@"",
				@"result_title":@"",
				@"result_message":MsgInputPasswordCheckError};
	}
	else if (![password_new isEqualToString:password_check]) {
		dic = @{@"status":@"",
				@"result_title":@"",
				@"result_message":MsgInputPasswordValidateError};
		
	}
	
	else {
		dic = @{@"status":APIResponseNormalStatusCode,
				@"result_title":@"",
				@"result_message":@""};
	}
	
	
	return dic;
	
}


@end
