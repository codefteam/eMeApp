//
//  StartPageViewController.m
//  EMI_Pt
//
//  Created by esukei on 2014/08/26.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "StartPageViewController.h"
#import "ByoinSentakuViewController.h"

#import "MasterService.h"


#import <MapKit/MapKit.h>

@interface StartPageViewController ()

@end

@implementation StartPageViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];

	UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	enterBtn.frame = self.view.frame;
	enterBtn.titleLabel.font = [UIFont systemFontOfSize:22.0];
	enterBtn.backgroundColor = [UIColor whiteColor];
	[enterBtn setBackgroundImage:[UIImage imageNamed:@"btn-base.png"] forState:UIControlStateNormal];
	[enterBtn setTitle:@"開始" forState:UIControlStateNormal];
	[enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[enterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	[enterBtn addTarget:self action:@selector(startUp) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:enterBtn];
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
	[self startUp];
	
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	self.navigationController.navigationBarHidden = NO;
	[super viewDidDisappear:animated];
}


#pragma mark - Action
- (void)startUp
{
	//通信中のメッセージ表示
	UIAlertView *_alertView = nil;
	
	_alertView = [[UIAlertView alloc] initWithTitle:TitleCommonInitialization
											message:MsgCommonPleaseWait
										   delegate:self
								  cancelButtonTitle:nil
								  otherButtonTitles:nil];
	[_alertView show];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
	
	/**
	 *  各マスタを取得する
	 *  病院・会社マスタ+診療科・部門+病院契約会社+タクシー会社+Beacon情報
	 */
	
	NSDictionary *dic;
	//病院・会社一覧取得
	dic = [MasterService getCompanyMaster];
	
	if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
		
		//タクシー一覧取得
		dic = [MasterService getTaxiMaster];
			
	}
	
	[_alertView dismissWithClickedButtonIndex:0 animated:NO];
	
	if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {

		[self showNextViewController];
	}
	else {
		[Utility showMessage:dic[@"result_title"] message:dic[@"result_message"]];
	}
    	
}

- (void)showNextViewController
{

	ByoinSentakuViewController *byoinSentakuViewController = [[ByoinSentakuViewController alloc]init];
	UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:byoinSentakuViewController];

	[self presentViewController:nav animated:NO completion:nil];
	
}

@end
