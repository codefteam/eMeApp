//
//  Utility.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/08/21.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (NSString *)version;
+ (void)setupAppTheme;

+ (NSString *)changeNullOrEmpty:(id)obj;
+ (NSString *)currentDate:(NSString *)formatStr;

@end
