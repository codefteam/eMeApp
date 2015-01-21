//
//  SettingViewController.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/07/24.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingPasswordViewController.h"
#import "AccountService.h"
#import "AlertFactory.h"
#import "Reachability.h"

#define alert_execute_flag	1

@interface SettingViewController ()
{
	int alert_flg;
	BOOL alert_execute_flg;
	BOOL alert_finished_flg;
}
@end

@implementation SettingViewController


#pragma mark - View lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"設定";
	self.view.backgroundColor = RGB(142, 211, 209);

	CGFloat height = 0.f;
	//パスワード変更ボタン
	UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	changeBtn.frame = CGRectMake(15.f, height+10.f, 290.f, 53.f);
	[changeBtn setImage:[UIImage imageNamed:@"btn-pass.png"] forState:UIControlStateNormal];
	changeBtn.tag = 0;
	[changeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:changeBtn];

	height += 10.f+changeBtn.frame.size.height;
	
	//ログアウトボタン
	UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	enterBtn.frame = CGRectMake(15.f, height+10.f, 290.f, 53.f);
	enterBtn.tag = 1;
	[enterBtn setBackgroundImage:[UIImage imageNamed:@"btn-base.png"] forState:UIControlStateNormal];
	[enterBtn setTitle:@"ログアウト" forState:UIControlStateNormal];
	enterBtn.titleLabel.font = [UIFont systemFontOfSize:22.0];
	[enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[enterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	[enterBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:enterBtn];

	
}

#pragma mark - Action
/**
 *  ボタンを押した時に呼ばれる
 */
- (void)btnClick:(id)sender
{
	UIButton *btn = (UIButton *)sender;
	
	if (btn.tag == 0) {
		[self showChangePassword];
	}
	else if (btn.tag == 1) {
		
		//ネットワーク使用可否チェック
		Reachability *reachability = [Reachability reachabilityForInternetConnection];
		NetworkStatus status = [reachability currentReachabilityStatus];

		if (NotReachable == status) {
			[AlertFactory showMessage:@"" message:MsgLogoutNetWorkValidateError];
		}
		else {
			[self logout];
		}
			
	}
}

/**
 *  パスワード変更ページに遷移
 */
- (void)showChangePassword
{
	[self.navigationController pushViewController:[[SettingPasswordViewController alloc]init] animated:YES];
}

/**
 *  ログアウト確認メッセージ表示
 */
- (void)logout
{
	UIAlertView *_alertView = nil;
	// メッセージalertでOKを押下された場合にYESになるフラグ
	self->alert_execute_flg = NO;
	
	// メッセージalertでボタンが押下されるまでの待機用フラグ
	self->alert_finished_flg = NO;
	
	_alertView=[[UIAlertView alloc]initWithTitle:TitleLogoutAsk
										 message:MsgLogoutAsk
										delegate:self
							   cancelButtonTitle:BtnLogoutCancel
							   otherButtonTitles:BtnLogoutDone,nil];
	self->alert_flg = alert_execute_flag;
	[_alertView show];
	
	//メッセージalertでボタンを押下するまで0.2秒間隔で待機
	while (NO == self->alert_finished_flg) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
	}
	
	// ログアウトする場合の処理
	if (YES == self->alert_execute_flg) {
		
		_alertView = [[UIAlertView alloc] initWithTitle:TitleCommonConnecting
												message:MsgCommonPleaseWait
											   delegate:nil
									  cancelButtonTitle:nil
									  otherButtonTitles:nil];
		[_alertView show];
		
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];

		NSDictionary *dic = [AccountService logout];
	
		// データ送信中alertを閉じる
		[_alertView dismissWithClickedButtonIndex:0 animated:NO];
		
		if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
		
			[MasterService clearData];
			[self.navigationController popToRootViewControllerAnimated:NO];
			
		}
		else {
			
			[AlertFactory showMessage:TitleCommonError message:MsgLogoutError];
		}
	}
	
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if (1==buttonIndex) {
		if (alert_execute_flag == self->alert_flg) {
			
			self->alert_execute_flg = YES;
		}
	}
	
	self->alert_finished_flg = YES;

}

@end
