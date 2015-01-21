//
//  OutsideViewController.m
//  EMI_Pt
//
//  Created by esukei on 2014/07/22.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "OutsideViewController.h"
#import "BrowserViewController.h"
#import "ByoinSentakuViewController.h"


@interface OutsideViewController ()
{
	
	UIView *_headerView;
	UIView *_footerView;
	
}
@end

@implementation OutsideViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = @"院外サービス情報";
	self.view.backgroundColor = [UIColor whiteColor];
	
	//病院一覧表示
	UIBarButtonItem *byoinSentakuBtn;
	byoinSentakuBtn = [[UIBarButtonItem alloc]initWithTitle:BtnCommonSelect
													  style:UIBarButtonItemStyleBordered
													 target:self
													 action:@selector(byoinSentakuBtnClick:)];
	self.navigationItem.leftBarButtonItem = byoinSentakuBtn;
	
	

	_headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 175.f)];
	_footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 175.f,
														   self.view.frame.size.width,
														   self.view.frame.size.height-_headerView.frame.size.height- self.navigationController.navigationBar.frame.size.height)];
	
	_footerView.backgroundColor = RGB(142, 211, 209);
	
	[self.view addSubview:_headerView];
	[self.view addSubview:_footerView];
	
	[self setupHeaderViewLayout];
	[self setupFooterViewLayout];

}

- (void)viewDidAppear:(BOOL)animated
{
	
	//通知の受け取り処理
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(shouldRegionStatusChange)
												 name:@"WillRegionStatusChange"
											   object:nil];
	
	
	if ([Configuration currentState]) {
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
	logoImage = [UIImage imageNamed:@"logo-dummy.png"];
	_headerView.backgroundColor = [UIColor colorWithPatternImage:logoImage];
}

- (void)setupFooterViewLayout
{
	
	CGFloat contentMargin=10.f;
	
	
	UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	infoBtn.frame = CGRectMake(15.f, contentMargin, 290.f, 53.f);
	infoBtn.exclusiveTouch = YES;
	infoBtn.backgroundColor = [UIColor whiteColor];
	infoBtn.alpha = 0.7;
	[infoBtn setTitle:@"病院案内" forState:UIControlStateNormal];
	[infoBtn setImage:[UIImage imageNamed:@"btn-hospital.png"] forState:UIControlStateNormal];
	[infoBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[_footerView addSubview:infoBtn];

	
	contentMargin += infoBtn.frame.size.height+10.f;
	
	
	UIButton *taxiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	taxiBtn.frame = CGRectMake(15.f, contentMargin, 290.f, 53.f);
	taxiBtn.exclusiveTouch = YES;
	taxiBtn.backgroundColor = [UIColor whiteColor];
	taxiBtn.alpha = 0.7;
	[taxiBtn setTitle:@"タクシー呼出" forState:UIControlStateNormal];
	[taxiBtn setImage:[UIImage imageNamed:@"btn-taxi.png"] forState:UIControlStateNormal];
	[taxiBtn addTarget:self action:@selector(taxiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[_footerView addSubview:taxiBtn];
	
	
	contentMargin += taxiBtn.frame.size.height+10.f;
	
	
	UIButton *guidanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	guidanceBtn.frame = CGRectMake(15.f, contentMargin, 290.f, 53.f);
	guidanceBtn.exclusiveTouch = YES;
	guidanceBtn.backgroundColor = [UIColor whiteColor];
	guidanceBtn.alpha = 0.7;
	[guidanceBtn setTitle:@"行き先案内" forState:UIControlStateNormal];
	[guidanceBtn setImage:[UIImage imageNamed:@"btn-navi.png"] forState:UIControlStateNormal];
	[guidanceBtn addTarget:self action:@selector(guidanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[_footerView addSubview:guidanceBtn];
	
}

#pragma mark - Action
- (void)byoinSentakuBtnClick:(id)sender
{
	ByoinSentakuViewController *byoinSentakuViewController = [[ByoinSentakuViewController alloc]init];
	UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:byoinSentakuViewController];
	
	[self presentViewController:nav animated:NO completion:nil];
}


- (void)guidanceBtnClick:(id)sender
{
	
	if ([[UIApplication sharedApplication] canOpenURL:
		 [NSURL URLWithString:@"comgooglemaps-x-callback://"]]) {

		
		NSString *str = [[Configuration selectCompany]objectForKey:@"label"];

		NSString *urlString = [NSString stringWithFormat:@"comgooglemaps-x-callback://x-callback-url/open/?x-source=アプリ&x-success=open-emi-pt:&daddr=%@&directionsmode=transit&resume=true",str];
		
		
		//日本語をエスケープ
		NSURL* url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		[[UIApplication sharedApplication] openURL:url];

	}
	else {
		
		UIAlertView *alert =
		[[UIAlertView alloc] initWithTitle:@""
								   message:MsgMapZero
								  delegate:self
						 cancelButtonTitle:nil
						 otherButtonTitles:BtnCommonConfirm, nil];
		[alert show];
	}
	
	
}

- (void)taxiBtnClick:(id)sender
{
	
	BrowserViewController *browserViewController = [[BrowserViewController alloc]init];
	browserViewController.title = @"タクシー呼出";
	browserViewController.requestURL = @"http://www.taxisite.com/";
	
	[self.navigationController pushViewController:browserViewController animated:YES];

}

- (void)infoBtnClick:(id)sender
{
	
	NSLog(@"%@", [Configuration selectCompany]);
	BrowserViewController *browserViewController = [[BrowserViewController alloc]init];
	browserViewController.title = @"病院案内";
	NSString *strUrl = [[Configuration selectCompany]objectForKey:@"homepage"];
	
	if (strUrl.length!=0) {
		browserViewController.requestURL = strUrl;
		[self.navigationController pushViewController:browserViewController animated:YES];
	}
	else {
		[Utility showMessage:@"" message:MsgURLZero];
	}
	
}

@end
