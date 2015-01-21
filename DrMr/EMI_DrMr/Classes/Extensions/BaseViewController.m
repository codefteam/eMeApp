//
//  BaseViewController.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/07/23.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	//戻るボタンの文言を設定
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
	barButtonItem.title = @"戻る";
	self.navigationItem.backBarButtonItem = barButtonItem;

	//ナビゲーションの半透明を禁止にする
	self.navigationController.navigationBar.translucent = NO;
	
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		
		self.edgesForExtendedLayout = UIRectEdgeNone;
		self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	}

#endif
	
}

@end
