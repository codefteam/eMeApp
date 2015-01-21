//
//  AppDelegate.h
//  EMI_Pt
//
//  Created by esukei on 2014/07/18.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CautionViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CautionViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CautionViewController *cautionViewController;

@end
