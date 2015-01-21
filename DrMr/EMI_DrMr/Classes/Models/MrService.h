//
//  MrService.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/06.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MrService : NSObject

+ (NSDictionary *)getDrList;
+ (NSDictionary *)applyRequest:(NSDictionary *)drDic;


+ (NSDictionary *)changeUserEditCallpermit:(BOOL)yesno;
+ (NSDictionary *)changeUserEditInroom:(BOOL)yesno;


@end
