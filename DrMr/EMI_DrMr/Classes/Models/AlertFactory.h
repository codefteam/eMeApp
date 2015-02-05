//
//  AlertFactory.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/07.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertFactory : NSObject

+ (void)showMessage:(NSString *)title message:(NSString *)message;
+ (void)showMessage:(NSString *)title message:(NSString *)message view:(UIViewController *)view;
+ (UIAlertView *)defaultAlert:(NSString *)title message:(NSString *)message;

@end
