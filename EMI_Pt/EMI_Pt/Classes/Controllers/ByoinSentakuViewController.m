//
//  ByoinSentakuViewController.m
//  EMI_Pt
//
//  Created by esukei on 2014/10/30.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "ByoinSentakuViewController.h"
#import "MasterService.h"
#import "GPSManager.h"
#import "BluetusManager.h"


@interface ByoinSentakuViewController ()<UITableViewDelegate, UITableViewDataSource>
{
	UITableView *_tableView;
	NSMutableArray *_value_list;
}
@end

@implementation ByoinSentakuViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"病院一覧";
	self.view.backgroundColor = [UIColor whiteColor];
	
	
	CGRect rect = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		
		rect.size.height = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
		
	}
#endif
	
	_tableView = [[UITableView alloc] initWithFrame:rect
											  style:UITableViewStylePlain];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	[self.view addSubview:_tableView];
	
	_value_list = [NSMutableArray array];
	
	[self getList];
	
}

#pragma mark - action
- (void)getList
{
	NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:[[Configuration company]valueForKeyPath:@"contents.data"]];
	
	for (NSString *key in mdic.allKeys) {
		
		NSMutableDictionary *entry = [[NSDictionary dictionaryWithDictionary:[mdic objectForKey:key]]mutableCopy];
		[entry setObject:key forKey:@"parent_cd"];
		[_value_list addObject:entry];
		
	}
	
	_value_list = [Utility sortArray:_value_list withKey:@"sort_no.intValue" ascending:YES];
}

- (NSDictionary *)setup
{
	
	//通信中のメッセージ表示
	UIAlertView *_alertView = nil;
	
	_alertView = [[UIAlertView alloc] initWithTitle:TitleCommonSetting
											message:MsgCommonPleaseWait
										   delegate:self
								  cancelButtonTitle:nil
								  otherButtonTitles:nil];
	[_alertView show];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
	
	
	/**
	 *  各マスタを取得する
	 *  診療科・部門+Beacon情報
	 */
	NSDictionary *dic;
	
	dic = [MasterService getDepartmentMaster];
	
	if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
		
		dic = [MasterService getBeaconMaster];
	}
	
	[_alertView dismissWithClickedButtonIndex:0 animated:NO];
	

	return dic;

}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSections
{
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"▼利用する病院を選択してください";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _value_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	cell.textLabel.text = [[_value_list objectAtIndex:indexPath.row]objectForKey:@"label"];
//	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	//領域観測の停止
	[[GPSManager sharedManager]stopMonitoring];
	
	[Configuration setSelectCompany:[_value_list objectAtIndex:indexPath.row]];
	
	NSDictionary *dic = [self setup];
	
	
	if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {

		//Bluetuth観測の開始
		[[BluetusManager sharedManager]startScanning];
		
		//領域観測の開始
		[[GPSManager sharedManager]startMonitoring];
		
		// 通知を作成する
		NSNotification *notification;
		notification = [NSNotification notificationWithName:@"RegionStatusChange"
													 object:self
												   userInfo:nil];
		// 通知実行
		[[NSNotificationCenter defaultCenter] postNotification:notification];
		
	}
	else {
		[Utility showMessage:dic[@"result_title"] message:dic[@"result_message"]];
	}

}

@end
