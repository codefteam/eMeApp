//
//  DrService.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/06.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "DrService.h"
#import "DrRequest.h"

@implementation DrService

+ (NSDictionary *)getMrList:(NSDictionary *)mrDic
{
	DrRequest *drRequest = [[DrRequest alloc]init];
	return [drRequest getMrListRequest:mrDic];
}

+ (NSDictionary *)callMR:(NSDictionary *)mrDic
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
	
	
	DrRequest *drRequest = [[DrRequest alloc]init];
	NSDictionary *dic = [drRequest callMRRequest:mrDic];
	
	[_alertView dismissWithClickedButtonIndex:0 animated:NO];
	
	return dic;
}

+ (NSDictionary *)applyAgree:(NSDictionary *)mrDic
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
	
	DrRequest *drRequest = [[DrRequest alloc]init];
	NSDictionary *dic = [drRequest applyAgreeRequest:mrDic];
	
	[_alertView dismissWithClickedButtonIndex:0 animated:NO];
	
	return dic;
	
}

+ (NSDictionary *)changeUserEditCallpermit:(BOOL)yesno
{
	DrRequest *drRequest = [[DrRequest alloc]init];
	return [drRequest changeUserEditCallpermitRequest:yesno];
}

+ (NSDictionary *)changeUserEditInroom:(BOOL)yesno
{
	DrRequest *drRequest = [[DrRequest alloc]init];
	return [drRequest changeUserEditInroomRequest:yesno];
}


@end
