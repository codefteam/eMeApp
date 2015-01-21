//
//  ShinsatsuTourokuViewController.m
//  EMI_Pt
//
//  Created by esukei on 2014/10/30.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "ShinsatsuTourokuViewController.h"

@interface ShinsatsuTourokuViewController ()<UITextFieldDelegate>
{
	UITextField *_textField;
	UIButton *_doneBtn;
}
@end


@implementation ShinsatsuTourokuViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"診察券番号登録";
	self.view.backgroundColor = RGB(142, 211, 209);
	
	UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 30.0)];
	titleLbl.text = @" 診察券番号";
	titleLbl.backgroundColor = RGB(244,161,122);
	[self.view addSubview:titleLbl];
	
	_textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0, titleLbl.frame.size.height, self.view.frame.size.width, 44.f)];
	_textField.borderStyle = UITextBorderStyleNone;
	_textField.placeholder = @"診察券番号を入力してください";
	_textField.backgroundColor = [UIColor whiteColor];
	_textField.keyboardType = UIKeyboardTypeNumberPad;
	_textField.returnKeyType = UIReturnKeyDone;
	_textField.delegate = self;
	_textField.text = [Configuration numberTicket];
	
	
	[self.view addSubview:_textField];
	
	//余白
	UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
	paddingView.opaque = NO;
	paddingView.backgroundColor = [UIColor clearColor];
	_textField.leftView = paddingView;
	// leftViewは常に表示されるように設定します。
	_textField.leftViewMode = UITextFieldViewModeAlways;
	
	_doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	_doneBtn.frame = CGRectMake(15.f, titleLbl.frame.size.height+10.f+_textField.frame.size.height, 290.f, 53.f);
	_doneBtn.exclusiveTouch = YES;
	_doneBtn.backgroundColor = [UIColor whiteColor];
	_doneBtn.alpha = 0.7;
	[_doneBtn setBackgroundImage:[UIImage imageNamed:@"btn-base.png"] forState:UIControlStateNormal];
	[_doneBtn setTitle:@"完了" forState:UIControlStateNormal];
	_doneBtn.titleLabel.font = [UIFont systemFontOfSize:22.0];
	[_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	
	[_doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_doneBtn];
	
	
}

- (void)doneBtnClick:(id)sender
{
	
	if ([self isValidate]) {
		
		NSString *numberTicket = [NSString stringWithFormat:@"%010d",[_textField.text intValue]];
		_textField.text = numberTicket;
		
		[self.view endEditing:YES];
		
		[Configuration setNumberTicket:_textField.text];
		[self.navigationController popViewControllerAnimated:YES];
		
	}
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	BOOL flag = NO;
	
	//未入力チェック
	if ([self isValidate]) {
		
		NSLog(@"%@", _textField.text);
		
		NSString *numberTicket = [NSString stringWithFormat:@"%10@",_textField.text];
		
		// キーボードを隠す
		[self.view endEditing:YES];
		[Configuration setNumberTicket:numberTicket];
		
		[self.navigationController popViewControllerAnimated:YES];
		
		flag = YES;
	}
	
	return flag;
	
}

- (BOOL)isValidate
{
	BOOL flag = NO;
	
	//未入力チェック
	if (![self isNullOrEmpty:_textField.text]) {
		
		UIAlertView *_alertView = nil;
		_alertView=[[UIAlertView alloc]initWithTitle:TitleCommonConfirm
											 message:MsgNumberTicketNotEntered
											delegate:nil
								   cancelButtonTitle:nil
								   otherButtonTitles:BtnCommonConfirm,nil,nil];
		[_alertView show];
		
	}//数値チェック
	else if (![self isDigit:_textField.text]) {
		
		UIAlertView *_alertView = nil;
		_alertView=[[UIAlertView alloc]initWithTitle:TitleCommonConfirm
											 message:MsgNumberTicketErrorFormat
											delegate:nil
								   cancelButtonTitle:nil
								   otherButtonTitles:BtnCommonConfirm,nil,nil];
		[_alertView show];
		
	}//文字数チェック
	else if (![self isLength:_textField.text  max:10 min:1]) {
		
		UIAlertView *_alertView = nil;
		_alertView=[[UIAlertView alloc]initWithTitle:TitleCommonConfirm
											 message:MsgNumberTicketErrorDigits
											delegate:nil
								   cancelButtonTitle:nil
								   otherButtonTitles:BtnCommonConfirm,nil,nil];
		[_alertView show];
		
		
	}
	else {
		flag = YES;
	}
	
	
	return flag;
}

- (BOOL)isNullOrEmpty:(NSString *)text
{
	BOOL flag = NO;
	
	if (text.length != 0) {
		flag = YES;
	}
	
	return flag;
	
}

- (BOOL)isDigit:(NSString *)text
{
	
	NSCharacterSet *digitCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	
	NSScanner *aScanner = [NSScanner localizedScannerWithString:text];
	[aScanner setCharactersToBeSkipped:nil];
	[aScanner scanCharactersFromSet:digitCharSet intoString:NULL];
	
	return [aScanner isAtEnd];
	
}

- (BOOL)isLength:(NSString *)text max:(int)max min:(int)min
{
	int length = (int)text.length;
	
	if(length < min) { // 最小文字数よりも少なかった場合
		return NO;
	}
	if(length > max) { // 最大文字数よりも多かった場合
		return NO;
	}
	
	return YES;
}


@end
