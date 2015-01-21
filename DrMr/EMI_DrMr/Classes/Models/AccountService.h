//
//  AccountService.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/06.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountService : NSObject

+ (NSDictionary *)loginAuthentication:(NSString *)tenantid loginid:(NSString *)login_id password:(NSString *)password;

+ (NSDictionary *)logout;

+ (NSDictionary *)changePassword:(NSString *)password_now password_new:(NSString *)password_new;

+ (NSDictionary *)isLoginValidate:(NSString *)loginid password:(NSString *)password;

+ (NSDictionary *)isPasswordValidate:(NSString *)password_now password_new:(NSString *)password_new password_check:(NSString*)password_check;

@end
