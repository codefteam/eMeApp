//
//  LoginViewController.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/07/23.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "DrMainViewController.h"
#import "MrMainViewController.h"

#import "GPSManager.h"
#import "BluetusManager.h"

#import "AccountService.h"
#import "AlertFactory.h"


@interface LoginViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
	UITableView *_tableView;
	NSMutableArray *_value_list;

}
@property (nonatomic,strong)NSString *login_id;
@property (nonatomic,strong)NSString *password;

@end

@implementation LoginViewController


#pragma mark - View lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = LoginTitle;
	self.view.backgroundColor = RGB(142, 211, 209);

	//ver表示
	UILabel *verlbl = [[UILabel alloc] init];
	verlbl.frame = CGRectMake(10, 10, 100, 50);
	verlbl.backgroundColor = [UIColor clearColor];
	verlbl.textColor = [UIColor whiteColor];
	verlbl.font = [UIFont systemFontOfSize:10];
	verlbl.textAlignment = NSTextAlignmentRight;
	verlbl.text = [NSString stringWithFormat:@"ver.β.%@ ", [Utility version]];
	UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:verlbl];
	self.navigationItem.rightBarButtonItem = barBtnItem;
	
	
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.f*2)
											  style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.scrollEnabled = NO;
	[self.view addSubview:_tableView];

	
	UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	loginBtn.frame = CGRectMake(15.f, 44.f*3+10.f, 290.f, 53.f);
	loginBtn.backgroundColor = [UIColor whiteColor];
	loginBtn.alpha = 0.7;
	[loginBtn setImage:[UIImage imageNamed:@"btn-login.png"]
			  forState:UIControlStateNormal];
	[loginBtn addTarget:self
				 action:@selector(loginBtnClick:)
	   forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:loginBtn];
	
	_value_list = [@[@"ユーザID", @"パスワード"]mutableCopy];

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	_login_id = [Configuration loginID];
	_password = [Configuration password];

	[_tableView reloadData];

	
}

- (void)viewDidAppear:(BOOL)animated
{
	
	[self autoLogin];
	
	[super viewDidAppear:animated];
}

#pragma mark - Action
/**
 *  ログインボタンが押されたときの処理
 *
 *  @param sender UIButton
 */
- (void)loginBtnClick:(id)sender
{
	//編集を終了させる
	[self.view endEditing:YES];
	//アカウント認証処理
	[self loginAuthentication];
	
}

/**
 *  アカウント認証処理
 */
- (void)loginAuthentication
{
	
	NSDictionary *dic = [AccountService isLoginValidate:self.login_id
										password:self.password];
	
	if (([dic[@"status"]isEqualToString:APIResponseNormalStatusCode])) {

		//通信中のメッセージ表示
		UIAlertView *_alertView = nil;
				
		_alertView = [[UIAlertView alloc] initWithTitle:TitleUserAuthenticated
												message:MsgCommonPleaseWait
											   delegate:nil
									  cancelButtonTitle:nil
									  otherButtonTitles:nil];
		[_alertView show];
		
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
		
		//ログイン認証処理
		dic = [AccountService loginAuthentication:Const_tenantid
										loginid:self.login_id
									   password:self.password];
		
		[_alertView dismissWithClickedButtonIndex:0 animated:NO];
		
		
		if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
			
			[Configuration setLoginID:self.login_id];
			[Configuration setPassword:self.password];
			
			//領域観測の停止・リセット(観測中のものがあった場合はリセットを行う)
			[[GPSManager sharedManager]stopMonitoring];
			//領域観測の開始
			[[GPSManager sharedManager]startMonitoring];
			//Bluetuth観測の開始
			[[BluetusManager sharedManager]startScanning];
			
			[self showNextViewController];
			
		}
		else {
			[AlertFactory showMessage:dic[@"result_title"] message:dic[@"result_message"]];
		}
	}
	else {
		[AlertFactory showMessage:dic[@"result_title"] message:dic[@"result_message"]];
	}
}

- (void)autoLogin
{
	if (self.login_id.length!=0 && self.password.length!=0) {
		
		[self loginAuthentication];
		
	}
}

/**
 *  次画面を表示
 */
- (void)showNextViewController
{

	/**
	 *  DrかMRによって表示画面を変更
	 */
	if ([[UserFactory userHighClassCd] isEqualToString:Dr_user_high_class_cd]) {
		
		[self.navigationController pushViewController:[[DrMainViewController alloc]init]
											 animated:YES];
	}else {
		[self.navigationController pushViewController:[[MrMainViewController alloc]init]
											 animated:YES];
	}
}

#pragma mark - UITextField delegate
/**
 *  UITextFieldの入力が終了する際に呼ばれる
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	
	switch (textField.tag) {
		case 0:
			_login_id = textField.text;
			break;
		case 1:
			_password = textField.text;
			break;
			
		default:
			break;
	}

}

/**
 *  キーボードのリターンキーを押されたときの処理
 *  フォーカスの変更の処理も行う
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

	switch (textField.tag) {
		case 0:
		{
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
			UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
			UITextField *myTextField = (UITextField *)[cell viewWithTag:1];
			[myTextField becomeFirstResponder];
		}
			_login_id = textField.text;
			
			break;
		case 1:
			
			[textField resignFirstResponder];
			
			_password = textField.text;
			
			break;
			
		default:
			break;
	}
	
	
	return YES;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _value_list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
								   reuseIdentifier:CellIdentifier];;
	}

	//入力用
	UITextField *_textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 300, cell.frame.size.height)];
	_textField.delegate = self;
	_textField.tag = indexPath.row;
	_textField.placeholder = [_value_list objectAtIndex:indexPath.row];
	_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	_textField.textAlignment = NSTextAlignmentLeft;
	//先頭大文字を無効
	_textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_textField.keyboardType = UIKeyboardTypeDefault;

	//アイコン
	UIImageView *iconImage;
	
	if (indexPath.row==0) {
		iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-login-user.png"]];
		_textField.text = self.login_id;
		_textField.returnKeyType = UIReturnKeyNext;
	}
	else if (indexPath.row==1) {
		iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-login-pass.png"]];
		_textField.text = self.password;
		_textField.returnKeyType = UIReturnKeyDone;
		_textField.secureTextEntry = YES;
	}
	

	iconImage.contentMode = UIViewContentModeCenter;
	iconImage.frame = CGRectMake(iconImage.frame.origin.x+10, iconImage.frame.origin.y-5, iconImage.frame.size.width+10, iconImage.frame.size.height-10);

	//UITextFieldにアイコン設置
	_textField.leftViewMode = UITextFieldViewModeAlways;
	_textField.leftView = iconImage;
	
	cell.accessoryView =_textField;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

@end
