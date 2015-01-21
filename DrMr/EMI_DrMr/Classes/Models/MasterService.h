//
//  MasterService.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/06.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterService : NSObject

+ (NSDictionary *)getUserInfo;

+ (NSDictionary *)getCompanyMaster:(NSString *)queryStr;
+ (NSDictionary *)getCompanyMaster;
+ (NSDictionary *)getDepartmentMaster;
+ (NSDictionary *)getContractMaster:(NSString *)queryStr;
+ (NSDictionary *)getContractMaster;
+ (NSDictionary *)getBeaconMaster;
+ (void)clearData;

@end
