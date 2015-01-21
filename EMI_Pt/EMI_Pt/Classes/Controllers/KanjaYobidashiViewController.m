//
//  KanjaYobidashiViewController.m
//  EMI_Pt
//
//  Created by esukei on 2014/10/30.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "KanjaYobidashiViewController.h"
#import "ShinsatsuTourokuViewController.h"
#import "BrowserViewController.h"

@interface KanjaYobidashiViewController ()
{
	UIView *_headerView;
	UIView *_footerView;
	UIButton *confirmBtn;
}
@end

@implementation KanjaYobidashiViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"診察順番お知らせ";
	self.view.backgroundColor = [UIColor whiteColor];
	
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

- (void)viewWillAppear:(BOOL)animated
{

	[super viewWillAppear:animated];
	
	
	if ([Configuration numberTicket].length!=0) {
		
		[confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
		
		confirmBtn.enabled = YES;
		
	}
	else {
		
		[confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		[confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
		
		confirmBtn.enabled = NO;
		
	}

	
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

#pragma mark - layout
- (void)setupHeaderViewLayout
{
	//	UIImage *logoImage;
	//	logoImage = [UIImage imageNamed:@"logo-dummy2.png"];
	//
	//	_headerView.backgroundColor = [UIColor colorWithPatternImage:logoImage];
	
	_headerView.backgroundColor = RGB(142, 211, 209);
	
}

- (void)setupFooderViewLayout
{
	
	CGFloat contentMargin=10.f;
	
	UIButton *entryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	entryBtn.frame = CGRectMake(15.f, contentMargin, 290.f, 53.f);
	entryBtn.exclusiveTouch = YES;
	entryBtn.backgroundColor = [UIColor whiteColor];
	entryBtn.alpha = 0.7;
	[entryBtn setBackgroundImage:[UIImage imageNamed:@"btn-base.png"] forState:UIControlStateNormal];
	[entryBtn setTitle:@"診察券番号登録" forState:UIControlStateNormal];
	
	entryBtn.titleLabel.font = [UIFont systemFontOfSize:22.0];
	[entryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[entryBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	
	[entryBtn addTarget:self action:@selector(entryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[_footerView addSubview:entryBtn];
	
	contentMargin += entryBtn.frame.size.height+10.f;
	
	confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	confirmBtn.frame = CGRectMake(15.f, contentMargin, 290.f, 53.f);
	confirmBtn.exclusiveTouch = YES;
	confirmBtn.backgroundColor = [UIColor grayColor];
	confirmBtn.alpha = 0.7;
	[confirmBtn setTitle:@"診察順番確認" forState:UIControlStateNormal];
	confirmBtn.titleLabel.font = [UIFont systemFontOfSize:22.0];
	
	[confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn-base.png"] forState:UIControlStateNormal];
	[confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[_footerView addSubview:confirmBtn];
	
}

#pragma mark - Action
- (void)entryBtnClick:(id)sender
{
	ShinsatsuTourokuViewController *shinsatsuTourokuViewController = [[ShinsatsuTourokuViewController alloc]init];
	
	[self.navigationController pushViewController:shinsatsuTourokuViewController animated:YES];
}

- (void)confirmBtnClick:(id)sender
{
	if ([Configuration numberTicket].length!=0) {
		
		BrowserViewController *browserViewController = [[BrowserViewController alloc]init];
		browserViewController.title = @"診察順番表示";
		browserViewController.requestURL = [NSString stringWithFormat:@"%@%@", OrderURL, [Configuration numberTicket]];
		
		[self.navigationController pushViewController:browserViewController animated:YES];
	}
	else {
		[Utility showMessage:@"" message:MsgNumberTicketZero];
	}
}


@end
