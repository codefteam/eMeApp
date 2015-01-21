//
//  DrRequest.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/08/25.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "HttpPost.h"

@interface DrRequest : HttpPost


- (NSDictionary *)getMrListRequest:(NSDictionary *)userDic;
- (NSDictionary *)applyAgreeRequest:(NSDictionary *)mrDic;
- (NSDictionary *)callMRRequest:(NSDictionary *)mrDic;

- (NSDictionary *)changeUserEditCallpermitRequest:(BOOL)yesno;
- (NSDictionary *)changeUserEditInroomRequest:(BOOL)yesno;

@end
