//
//  MrService.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/06.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "MrService.h"
#import "MrRequest.h"

@implementation MrService


+ (NSDictionary *)getDrList;
{
	MrRequest *mrRequest = [[MrRequest alloc]init];
	return [mrRequest getDrListRequest];
}

+ (NSDictionary *)applyRequest:(NSDictionary *)drDic;
{
	//アラートを表示
	UIAlertView *_alertView = nil;
	_alertView = [[UIAlertView alloc] initWithTitle:TitleCommonConnecting
											message:MsgCommonPleaseWait
										   delegate:nil
								  cancelButtonTitle:nil
								  otherButtonTitles:nil];
	[_alertView show];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];

	MrRequest *mrRequest = [[MrRequest alloc]init];
	NSDictionary *dic =[mrRequest applyRequest:drDic];
	
	[_alertView dismissWithClickedButtonIndex:0 animated:NO];
	
	return dic;
}

+ (NSDictionary *)changeUserEditCallpermit:(BOOL)yesno
{
	MrRequest *mrRequest = [[MrRequest alloc]init];
	return [mrRequest changeUserEditCallpermitRequest:yesno];
}

+ (NSDictionary *)changeUserEditInroom:(BOOL)yesno
{
	MrRequest *mrRequest = [[MrRequest alloc]init];
	return [mrRequest changeUserEditInroomRequest:yesno];
}

@end
