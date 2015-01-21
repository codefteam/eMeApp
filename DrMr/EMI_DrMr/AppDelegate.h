//
//  AppDelegate.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/07/23.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CautionViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CautionViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CautionViewController *cautionViewController;
@end
