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

/**
 * show alert on iOS 8 using UIAlertViewController (UIAlertView has been deprecated on iOS 8)
 * add by SonTQ on 2015/01/22
 */

+(void)showMessage:(NSString *)title message:(NSString *)message view:(UIViewController *)view{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title
                                                                              message:message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:BtnCommonConfirm
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          // open something
                                                      }]];
    
    //        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
    //                                                            style:UIAlertActionStyleCancel
    //                                                          handler:nil]];
    
    [view presentViewController:alertController animated:YES completion:nil];
}

@end
