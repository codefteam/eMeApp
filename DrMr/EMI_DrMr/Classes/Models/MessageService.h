//
//  MessageService.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/06.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageService : NSObject

+ (NSDictionary *)sendMessage:(NSDictionary *)userDic message:(NSString *)message;

+ (NSDictionary *)getMessages:(NSDictionary *)userDic displayCt:(NSString *)display_ct pageNm:(NSString *)page_num;

+ (NSDictionary *)getUnreadMessages;

@end
