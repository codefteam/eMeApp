//
//  HttpClient.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/09/09.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "HttpPost.h"

@interface HttpClient : HttpPost

- (NSDictionary *)loginAuthenticationRequest:(NSString *)tenant_id loginid:(NSString *)login_id password:(NSString *)password;
- (NSDictionary *)getUserInfoRequest;
- (NSDictionary *)editNowPasswordRequest:(NSString *)password_now newPassword:(NSString *)password_new;

- (NSDictionary *)getCompanyMasterRequest:(NSString *)tenant_id query:(NSString *)query;
- (NSDictionary *)getDepartmentMasterRequest:(NSString *)tenant_id query:(NSString *)query;
- (NSDictionary *)getContractMasterRequest:(NSString *)tenant_id query:(NSString *)query;
- (NSDictionary *)getTaxiMasterRequest:(NSString *)tenant_id query:(NSString *)query;
- (NSDictionary *)getBeaconMasterRequest:(NSString *)tenant_id query:(NSString *)query;



/**
 *  メッセージ
 */
- (NSDictionary *)sendMessageRequest:(NSDictionary *)userDic message:(NSString *)message;
- (NSDictionary *)getMessagesRequest:(NSDictionary *)userDic displayCt:(NSString *)display_ct pageNm:(NSString *)page_num;

- (NSDictionary *)getUnreadMessagesRequest;
@end
