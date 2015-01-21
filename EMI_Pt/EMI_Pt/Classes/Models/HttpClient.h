//
//  HttpClient.h
//  EMI_Pt
//
//  Created by esukei on 2014/07/22.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "HttpPost.h"

@interface HttpClient : HttpPost

- (NSDictionary *)getCompanyMasterRequest:(NSString *)tenant_id query:(NSString *)query;
- (NSDictionary *)getDepartmentMasterRequest:(NSString *)tenant_id query:(NSString *)query;
- (NSDictionary *)getContractMasterRequest:(NSString *)tenant_id query:(NSString *)query;
- (NSDictionary *)getTaxiMasterRequest:(NSString *)tenant_id query:(NSString *)query;
- (NSDictionary *)getBeaconMasterRequest:(NSString *)tenant_id query:(NSString *)query;

@end
