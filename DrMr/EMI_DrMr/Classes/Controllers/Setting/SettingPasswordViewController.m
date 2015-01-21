//
//  SettingPasswordViewController.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/08/14.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "SettingPasswordViewController.h"
#import "AccountService.h"
#import "AlertFactory.h"


@interface SettingPasswordViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
	UITableView *_tableView;
	NSMutableArray *_value_list;
	
}
@property (nonatomic,strong)NSString *password_now;
@property (nonatomic,strong)NSString *password_new;
@property (nonatomic,strong)NSString *password_check;


@end

@implementation SettingPasswordViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"パスワード変更";
	self.view.backgroundColor = RGB(142, 211, 209);
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.f*3) style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.scrollEnabled = NO;
	[self.view addSubview:_tableView];
	
	
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(15.f, 44.f*3+10.f, 290.f, 53.f);
	doneBtn.backgroundColor = [UIColor whiteColor];
	doneBtn.tag = 1;
	[doneBtn setBackgroundImage:[UIImage imageNamed:@"btn-base.png"] forState:UIControlStateNormal];
	[doneBtn setTitle:@"パスワード変更" forState:UIControlStateNormal];
	
	doneBtn.titleLabel.font = [UIFont systemFontOfSize:22.0];
	[doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	[doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:doneBtn];
	
	_value_list = [@[@"現在のパスワード", @"新しいパスワード", @"新しいパスワード(確認)"]mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

#pragma mark - Action
/**
 *  パスワード変更処理
 */
- (void)doneBtnClick:(id)sender
{
	
	//編集を終了させる
	[self.view endEditing:YES];
	
	NSDictionary *dic = [AccountService isPasswordValidate:self.password_now
											  password_new:self.password_new
											password_check:self.password_check];
	
	
	if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
		
		//通信中のメッセージ表示
		UIAlertView *_alertView = nil;
		
		_alertView = [[UIAlertView alloc] initWithTitle:TitleCommonConnecting
												message:MsgCommonPleaseWait
											   delegate:nil
									  cancelButtonTitle:nil
									  otherButtonTitles:nil];
		[_alertView show];
		
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];		
		
		//パスワード変更処理
		dic = [AccountService changePassword:self.password_now password_new:self.password_new];
		
		[_alertView dismissWithClickedButtonIndex:0 animated:NO];

		//パスワード変更の成功
		if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
					
			//利用者情報を取得する
			NSDictionary *user_info_dic = [MasterService getUserInfo];
			
			if ([user_info_dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
				
				UIAlertView *_alertView = nil;
				_alertView = [[UIAlertView alloc] initWithTitle:@""
														message:dic[@"result_message"]
													   delegate:self
											  cancelButtonTitle:BtnCommonConfirm
											  otherButtonTitles:nil];
				[_alertView show];
				
			}
			else {
				[AlertFactory showMessage:TitleCommonError message:user_info_dic[@"result_message"]];
			}
			
		}
		else {
			[AlertFactory showMessage:TitleCommonError message:dic[@"result_message"]];
		}
	}
	else {
		[AlertFactory showMessage:dic[@"result_title"] message:dic[@"result_message"]];
	}
}

/**
 *  次画面を表示
 */
- (void)showNextViewController
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self showNextViewController];
}

#pragma mark - UITextField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	
	switch (textField.tag) {
		case 0:
			_password_now = textField.text;
			break;
		case 1:
			_password_new = textField.text;
			break;
		case 2:
			_password_check = textField.text;
			break;
			
		default:
			break;
	}
	
}

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
			_password_now = textField.text;
			
			break;
		case 1:
		{
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
			UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
			UITextField *myTextField = (UITextField *)[cell viewWithTag:2];
			[myTextField becomeFirstResponder];
		}
			_password_new = textField.text;
			
			break;
		case 2:
			
			[textField resignFirstResponder];
			
			_password_check = textField.text;
			
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
		cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];;
	}
	
	//入力用
	UITextField *_textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 300, cell.frame.size.height)];
	_textField.delegate = self;
	_textField.tag = indexPath.row;
	_textField.placeholder = [_value_list objectAtIndex:indexPath.row];
	_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	_textField.textAlignment = NSTextAlignmentLeft;
	_textField.autocapitalizationType = UITextAutocapitalizationTypeNone;//先頭大文字を無効
	_textField.secureTextEntry = YES;
	
	//アイコン
	UIImageView *iconImage;
	
	if (indexPath.row==0) {
		_textField.text = self.password_now;
		_textField.returnKeyType = UIReturnKeyNext;
	}
	else if (indexPath.row==1) {
		_textField.text = self.password_new;
		_textField.returnKeyType = UIReturnKeyNext;
	}
	else if (indexPath.row==2) {

		_textField.text = self.password_check;
		_textField.returnKeyType = UIReturnKeyDone;

	}
	
	iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-login-pass.png"]];
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
