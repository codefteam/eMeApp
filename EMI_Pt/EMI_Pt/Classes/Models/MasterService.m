//
//  MasterService.m
//  EMI_Pt
//
//  Created by esukei on 2014/10/28.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "MasterService.h"
#import "HttpClient.h"

@implementation MasterService

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

+ (NSDictionary *)getTaxiMaster
{
	HttpClient *httpClient = [[HttpClient alloc]init];
	return [httpClient getTaxiMasterRequest:Const_tenantid query:@""];
}

+ (NSDictionary *)getBeaconMaster
{
	NSString *queryStr = [NSString stringWithFormat:@"&contents[search_condition][company]=%@",[[Configuration selectCompany]objectForKey:@"parent_cd"]];
	
	HttpClient *httpClient = [[HttpClient alloc]init];
	return [httpClient getBeaconMasterRequest:Const_tenantid query:queryStr];
}



@end
