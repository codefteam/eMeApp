//
//  BaseViewController.m
//  EMI_Pt
//
//  Created by esukei on 2014/07/18.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	//戻るボタンの文言を設定
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
	barButtonItem.title = @"戻る";
	self.navigationItem.backBarButtonItem = barButtonItem;
	

	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {

//		self.navigationController.navigationBar.translucent = NO;
		self.navigationController.navigationBar.translucent = YES;
		self.edgesForExtendedLayout = UIRectEdgeNone;
		self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	}
#endif
	
	
}

@end
