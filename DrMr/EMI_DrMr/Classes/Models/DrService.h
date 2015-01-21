//
//  DrService.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/06.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrService : NSObject

+ (NSDictionary *)getMrList:(NSDictionary *)mrDic;
+ (NSDictionary *)callMR:(NSDictionary *)mrDic;
+ (NSDictionary *)applyAgree:(NSDictionary *)mrDic;
+ (NSDictionary *)changeUserEditCallpermit:(BOOL)yesno;
+ (NSDictionary *)changeUserEditInroom:(BOOL)yesno;

@end
