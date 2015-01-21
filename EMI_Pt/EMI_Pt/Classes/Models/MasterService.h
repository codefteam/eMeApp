//
//  MasterService.h
//  EMI_Pt
//
//  Created by esukei on 2014/10/28.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterService : NSObject

+ (NSDictionary *)getCompanyMaster:(NSString *)queryStr;
+ (NSDictionary *)getCompanyMaster;
+ (NSDictionary *)getDepartmentMaster;
+ (NSDictionary *)getContractMaster:(NSString *)queryStr;
+ (NSDictionary *)getContractMaster;
+ (NSDictionary *)getTaxiMaster;
+ (NSDictionary *)getBeaconMaster;


@end
