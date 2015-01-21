//
//  InsideViewController.m
//  EMI_Pt
//
//  Created by esukei on 2014/07/22.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "InsideViewController.h"
#import "ShinryokaSentakuViewController.h"
#import "KanjaYobidashiViewController.h"
#import "BrowserViewController.h"
#import "ByoinSentakuViewController.h"


@interface InsideViewController ()
{
	
	UIView *_headerView;
	UIView *_footerView;
	
}
@end

@implementation InsideViewController

- (void)check:(id)sender
{
	
	NSString *geoStr = @"";
	NSString *bleStr = @"";
	
	if ([Configuration currentGpsState]) {
		geoStr = @"領域観測:領域内";
	}
	else {
		geoStr = @"領域観測:領域外";
	}

	if ([Configuration currentBeaconState]) {
		bleStr = @"Beacon:範囲中";
	}
	else {
		bleStr = @"Beacon:範囲外";
	}
	
	NSString *name = [[Configuration selectCompany]objectForKey:@"label"];
	
	
	NSString *message = [NSString  stringWithFormat:@"%@\n現在のステート\n%@\n%@",name,geoStr,bleStr];
	
	UIAlertView *alert =
	[[UIAlertView alloc] initWithTitle:@"領域確認"
							   message:message
							  delegate:nil
					 cancelButtonTitle:nil
					 otherButtonTitles:@"はい", nil];
	[alert show];

}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"院内サービス情報";
	self.view.backgroundColor = [UIColor whiteColor];

	//病院一覧表示
	UIBarButtonItem *byoinSentakuBtn;
	byoinSentakuBtn = [[UIBarButtonItem alloc]initWithTitle:BtnCommonSelect
													  style:UIBarButtonItemStyleBordered
													 target:self
													 action:@selector(byoinSentakuBtnClick:)];
	self.navigationItem.leftBarButtonItem = byoinSentakuBtn;
	
	
	//設定ボタンの生成
//	UIBarButtonItem *settingButton = [[UIBarButtonItem alloc]initWithTitle:@"確認" style:UIBarButtonItemStyleBordered target:self action:@selector(check:)];
//	self.navigationItem.rightBarButtonItem = settingButton;
	
	
	
	_headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 175.f)];
	_footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 175.f,
														   self.view.frame.size.width,
														   self.view.frame.size.height-_headerView.frame.size.height- self.navigationController.navigationBar.frame.size.height)];
	
	_footerView.backgroundColor = RGB(142, 211, 209);
	
	[self.view addSubview:_headerView];
	[self.view addSubview:_footerView];
	
	[self setupHeaderViewLayout];
	[self setupFooderViewLayout];
	
}

- (void)viewDidAppear:(BOOL)animated
{

	//通知の受け取り処理
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(shouldRegionStatusChange)
												 name:@"WillRegionStatusChange"
											   object:nil];
	
	if (![Configuration currentState]) {

		[self shouldRegionStatusChange];
		
	}
	
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	
	if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
		self.navigationController.interactivePopGestureRecognizer.delegate = nil;
	}
	
	[[NSNotificationCenter defaultCenter] removeObserver: self];	
	
	[super viewDidDisappear:animated];
}

- (void)shouldRegionStatusChange
{
	//アプリ内通知を行う
	NSNotification *notification = [NSNotification notificationWithName:@"RegionStatusChange" object:self];
	// 通知実行！
	[[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark - layout
- (void)setupHeaderViewLayout
{
	UIImage *logoImage;
	logoImage = [UIImage imageNamed:@"logo-dummy2.png"];

	_headerView.backgroundColor = [UIColor colorWithPatternImage:logoImage];
}

- (void)setupFooderViewLayout
{
	
	CGFloat contentMargin=10.f;
	
	
	UIButton *shinryokaSentakuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	shinryokaSentakuBtn.frame = CGRectMake(15.f, contentMargin, 290.f, 53.f);
	shinryokaSentakuBtn.exclusiveTouch = YES;
	shinryokaSentakuBtn.backgroundColor = [UIColor whiteColor];
	shinryokaSentakuBtn.alpha = 0.7;
	[shinryokaSentakuBtn setImage:[UIImage imageNamed:@"btn-01.png"] forState:UIControlStateNormal];
	[shinryokaSentakuBtn addTarget:self action:@selector(shinryokaSentakuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[_footerView addSubview:shinryokaSentakuBtn];
	
	contentMargin += shinryokaSentakuBtn.frame.size.height+10.f;
	
	
	UIButton *kanjaYobidashiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	kanjaYobidashiBtn.frame = CGRectMake(15.f, contentMargin, 290.f, 53.f);
	kanjaYobidashiBtn.exclusiveTouch = YES;
	kanjaYobidashiBtn.backgroundColor = [UIColor whiteColor];
	kanjaYobidashiBtn.alpha = 0.7;
	[kanjaYobidashiBtn setImage:[UIImage imageNamed:@"btn-02.png"] forState:UIControlStateNormal];
	[kanjaYobidashiBtn addTarget:self action:@selector(kanjaYobidashiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[_footerView addSubview:kanjaYobidashiBtn];
	
}

#pragma mark - Action
- (void)byoinSentakuBtnClick:(id)sender
{
	ByoinSentakuViewController *byoinSentakuViewController = [[ByoinSentakuViewController alloc]init];
	UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:byoinSentakuViewController];
	
	
	[self presentViewController:nav animated:NO completion:nil];
}

- (void)shinryokaSentakuBtnClick:(id)sender
{
	
	NSLog(@"%@", [Configuration department]);
	
	NSDictionary *departmentDic = [[Configuration department]valueForKeyPath:@"contents.data"];
	
	
	if (departmentDic.count!=0) {

		ShinryokaSentakuViewController *shinryokaSentakuViewController = [[ShinryokaSentakuViewController alloc]init];
		[self.navigationController pushViewController:shinryokaSentakuViewController animated:YES];
		
	}
	else {
		
		[Utility showMessage:TitleCommonConfirm message:MsgDepartmentListZero];
		
	}

}

- (void)kanjaYobidashiBtnClick:(id)sender
{
	
	KanjaYobidashiViewController *kanjaYobidashiViewController = [[KanjaYobidashiViewController alloc]init];
	[self.navigationController pushViewController:kanjaYobidashiViewController animated:YES];
	
}

@end
