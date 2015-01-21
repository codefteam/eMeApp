//
//  AlertFactory.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/07.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "AlertFactory.h"

@implementation AlertFactory

/**
 *  メッセージを表示する
 *
 *  @param title   UIAlertView title
 *  @param message UIAlertView message
 */
+ (void)showMessage:(NSString *)title message:(NSString *)message
{
	UIAlertView *_alertView = nil;
	_alertView=[[UIAlertView alloc]initWithTitle:title
										 message:message
										delegate:nil
							   cancelButtonTitle:nil
							   otherButtonTitles:BtnCommonConfirm,nil,nil];
	[_alertView show];
}

+ (UIAlertView *)defaultAlert:(NSString *)title message:(NSString *)message
{
	UIAlertView *_alertView;
	
	_alertView = [[UIAlertView alloc] initWithTitle:title
											message:message
										   delegate:nil
								  cancelButtonTitle:nil
								  otherButtonTitles:nil];
	
	return _alertView;
}


@end
