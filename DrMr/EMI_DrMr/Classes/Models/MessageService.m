//
//  MessageService.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/06.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "MessageService.h"
#import "HttpClient.h"

@implementation MessageService


+ (NSDictionary *)sendMessage:(NSDictionary *)userDic message:(NSString *)message
{
	HttpClient *request = [[HttpClient alloc]init];
	
	return [request sendMessageRequest:userDic message:message];
	
}

+ (NSDictionary *)getMessages:(NSDictionary *)userDic displayCt:(NSString *)display_ct pageNm:(NSString *)page_num
{
	HttpClient *request = [[HttpClient alloc]init];
	
	return [request getMessagesRequest:userDic displayCt:display_ct pageNm:page_num];

}

+ (NSDictionary *)getUnreadMessages
{
	HttpClient *request = [[HttpClient alloc]init];
	
	return [request getUnreadMessagesRequest];
}


@end
