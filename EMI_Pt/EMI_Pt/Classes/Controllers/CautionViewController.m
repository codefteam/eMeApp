//
//  CautionViewController.m
//  EMI_Pt
//
//  Created by Esukei Company on 2014/09/11.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "CautionViewController.h"

@interface CautionViewController ()
{
	
}
@property (nonatomic,strong)UIImageView *gpsImageView;
@property (nonatomic,strong)UIImageView *bluetoothImageView;
@end

@implementation CautionViewController


- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	UIImage *gpsImage;
	UIImage *bluetoothImage;
	
	if ([Configuration gpsPermission]) {
		gpsImage = [UIImage imageNamed:@"icon1-1.png"];
	}
	else {
		gpsImage = [UIImage imageNamed:@"icon1-2.png"];
	}
	
	if ([Configuration bluetoothPermission]) {
		bluetoothImage = [UIImage imageNamed:@"icon2-1.png"];
	}
	else {
		bluetoothImage = [UIImage imageNamed:@"icon2-2.png"];
	}
	
	_gpsImageView = [[UIImageView alloc] initWithImage:gpsImage];
	_gpsImageView.frame = CGRectMake(20.f,80.f,130.f,190.f);
	[self.view addSubview:_gpsImageView];
	
	UILabel *gpslabel = [[UILabel alloc] init];
	gpslabel.frame = CGRectMake(10.f,80.f+10.f+190.f,150.f,30.f);
	gpslabel.text = @"位置情報サービス";
	gpslabel.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:gpslabel];
	
	
	_bluetoothImageView = [[UIImageView alloc] initWithImage:bluetoothImage];
	_bluetoothImageView.frame = CGRectMake(20.f+20.f+130.f,80.f,130.f,190.f);
	[self.view addSubview:_bluetoothImageView];
	
	UILabel *bluetoothlabel = [[UILabel alloc] init];
	bluetoothlabel.frame = CGRectMake(10.f+150.f,80.f+10.f+190.f,150.f,30.f);
	bluetoothlabel.text = @"Bluetooth";
	bluetoothlabel.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:bluetoothlabel];
	
	
	
	UILabel *txtLbl = [[UILabel alloc] initWithFrame:CGRectMake(20.f,320.f,self.view.frame.size.width-40.f,100.f)];
	txtLbl.text = @"このアプリは位置情報サービスと\nBluetoothの設定を'ON'にする\n必要があります\n設定を確認してください";
	txtLbl.textAlignment = NSTextAlignmentCenter;
	txtLbl.numberOfLines = 0;
	[self.view addSubview:txtLbl];
	
	
	UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	enterBtn.frame = self.view.frame;
	enterBtn.titleLabel.font = [UIFont systemFontOfSize:22.0];
	[enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[enterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	[enterBtn addTarget:self action:@selector(enterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:enterBtn];
	
	
}

#pragma mark - Action
- (void)refreshState
{
	UIImage *gpsImage;
	UIImage *bluetoothImage;
	
	
	if ([Configuration gpsPermission]) {
		gpsImage = [UIImage imageNamed:@"icon1-1.png"];
	}
	else {
		gpsImage = [UIImage imageNamed:@"icon1-2.png"];
	}
	_gpsImageView.image = gpsImage;
	
	if ([Configuration bluetoothPermission]) {
		bluetoothImage = [UIImage imageNamed:@"icon2-1.png"];
	}
	else {
		bluetoothImage = [UIImage imageNamed:@"icon2-2.png"];
	}
	
	_bluetoothImageView.image = bluetoothImage;
}

- (void)enterBtnClick:(id)sender
{
	if (self.delegate &&
		[self.delegate respondsToSelector:@selector(dismissCautionViewController:)]) {
		
		if ([Configuration gpsPermission]&&[Configuration bluetoothPermission]) {
			[self.delegate dismissCautionViewController:self];
		}
		
	}
}

- (BOOL)shouldAutorotate
{
	
	return NO;
}

@end