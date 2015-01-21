//
//  MasterService.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/06.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "MasterService.h"
#import "HttpClient.h"
#import "UserFactory.h"

@implementation MasterService

+ (NSDictionary *)getUserInfo
{
	HttpClient *httpClient = [[HttpClient alloc]init];
	return [httpClient getUserInfoRequest];
}

+ (NSDictionary *)getCompanyMaster:(NSString *)queryStr
{
	HttpClient *httpClient = [[HttpClient alloc]init];
	return [httpClient getCompanyMasterRequest:Const_tenantid query:queryStr];
}

+ (NSDictionary *)getCompanyMaster
{
	HttpClient *httpClient = [[HttpClient alloc]init];
	return [httpClient getCompanyMasterRequest:Const_tenantid query:@"&contents[search_condition][company_sb]=0001"];
}

+ (NSDictionary *)getDepartmentMaster
{
	HttpClient *httpClient = [[HttpClient alloc]init];
	return [httpClient getDepartmentMasterRequest:Const_tenantid query:@""];
}

+ (NSDictionary *)getContractMaster:(NSString *)queryStr
{	
	
	HttpClient *httpClient = [[HttpClient alloc]init];
	return [httpClient getContractMasterRequest:Const_tenantid query:queryStr];

}

+ (NSDictionary *)getContractMaster
{
	HttpClient *httpClient = [[HttpClient alloc]init];
	return [httpClient getContractMasterRequest:Const_tenantid query:@""];	
}

+ (NSDictionary *)getBeaconMaster
{
	HttpClient *httpClient = [[HttpClient alloc]init];
	return [httpClient getBeaconMasterRequest:Const_tenantid query:@""];
}

+ (void)clearData
{
	[Configuration setLoginID:@""];
	[Configuration setPassword:@""];

	[Configuration setCurrentBeaconLocation:@""];
	[Configuration setCurrentGPSLocation:@""];
	
	[Configuration setLoginInfo:[NSMutableDictionary dictionary]];
	[Configuration setUserMaster:[NSMutableDictionary dictionary]];
	[Configuration setUserListMaster:[NSMutableDictionary dictionary]];
}

@end
