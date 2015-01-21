//
//  MrRequest.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/08/25.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "HttpPost.h"

@interface MrRequest : HttpPost

- (NSDictionary *)getDrListRequest;
- (NSDictionary *)applyRequest:(NSDictionary *)drDic;


- (NSDictionary *)changeUserEditCallpermitRequest:(BOOL)yesno;
- (NSDictionary *)changeUserEditInroomRequest:(BOOL)yesno;

@end
