//
//  MrMainViewController.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/07/28.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "MrMainViewController.h"
#import "SettingViewController.h"
#import "NoticeViewController.h"
#import "SOMessageViewController.h"
#import "MrApprovalTableViewCell.h"
#import "MrNonrecognitionTableViewCell.h"
#import "MasterService.h"
#import "MrService.h"
#import "PaddingLabel.h"
#import "LKBadgeView.h"
#import "UIImageView+WebCache.h"
#import "ButtonFactory.h"
#import "AlertFactory.h"


#define alert_type_callMR		0
#define alert_type_approval		1


@interface MrMainViewController ()<UITableViewDataSource, UITableViewDelegate>
{
	UIView *_headerView;
	UIView *_footerView;
	UITableView *_tableView;
	UIRefreshControl *_refreshControl;
	UIButton *_areaBtn;
	UIButton *_renrakuBtn;
	UIButton *_tuchiBtn;
	LKBadgeView* _tuchiBadgeView;

	NSMutableArray *_info_list;
	NSMutableArray *_request_info;

}
@property (nonatomic, strong)NSIndexPath *current_indexPath;
@end


@implementation MrMainViewController
#pragma mark - View lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];

	self.title = @"";
	self.view.backgroundColor = [UIColor whiteColor];

	//戻るボタンの非表示
	self.navigationItem.hidesBackButton = YES;
	
	
	//設定ボタンの生成
	UIBarButtonItem *settingButton = [[UIBarButtonItem alloc]initWithTitle:@"設定" style:UIBarButtonItemStyleBordered target:self action:@selector(setting:)];
	self.navigationItem.rightBarButtonItem = settingButton;

	//ステート変更ボタン領域
	_headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 50.f)];
	//一覧表示エリア領域
	_footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 50.f, self.view.frame.size.width, self.view.frame.size.height-_headerView.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)];

	[self.view addSubview:_headerView];
	[self.view addSubview:_footerView];
	
	[self setupHeaderViewLayout];
	[self setupFooterViewLayout];

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(sendRequest)
												 name:@"RegionStatusChange"
											   object:nil];
	
	//プッシュ通知を受け取る
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(sendRequest)
												 name:@"PushNotification"
											   object:nil];
	
	//コミュニケート申請を受け取った際の通知を取得
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(sendRequest)
												 name:@"PushNotification0003"
											   object:nil];
	
	//フォアグラウンドになった際の通知を取得
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(sendRequest)
												 name:UIApplicationWillEnterForegroundNotification
											   object:[UIApplication sharedApplication]];
}

- (void)viewDidAppear:(BOOL)animated
{

	//同期一覧取得
	[self sendRequest];

	[super viewDidAppear:animated];	
	
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self];

	[super viewDidDisappear:animated];
}

#pragma mark - Setup Layout
- (void)setupHeaderViewLayout
{
	_headerView.backgroundColor = [UIColor whiteColor];
	
	//院内外ステートを表示・切り替えボタン
	_areaBtn = [ButtonFactory defaultAreaButton];
	[_headerView addSubview:_areaBtn];
	
	//連絡可否ステートを表示・切り替えボタン
	_renrakuBtn = [ButtonFactory defaultRenrakuButton];
	[_renrakuBtn addTarget:self action:@selector(renrakuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[_headerView addSubview:_renrakuBtn];
	
	//通知一覧遷移ボタン
	_tuchiBtn = [ButtonFactory defaultTuchiButton];
	[_tuchiBtn addTarget:self action:@selector(tuchiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[_headerView addSubview:_tuchiBtn];
}

- (void)setupFooterViewLayout
{
	
	_footerView.backgroundColor = [UIColor clearColor];

	// UITableViewを作成
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, _footerView.frame.size.height)
											  style:UITableViewStylePlain];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	[_footerView addSubview:_tableView];

	//cell.imageviewの下線が表示されるようにするため
	if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[_tableView setSeparatorInset:UIEdgeInsetsZero];
	}

	// UIRefreshControlを作成
	_refreshControl = [[UIRefreshControl alloc]init];
	
	// 更新アクションを設定
	[_refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
	
	// UITableViewにUIRefreshControlを追加
	[_tableView addSubview:_refreshControl];
	
}

/**
 *  UIRefreshControlの動作
 */
- (void)onRefresh:(UIRefreshControl *)sender
{
	// 更新開始
	[_refreshControl beginRefreshing];
	
	// 更新処理実行
	[self sendRequest];
	
	// 更新終了
	[_refreshControl endRefreshing];
}

#pragma mark - Action
/**
 *  同期で一覧情報を取得する
 */
- (void)sendRequest
{
	
	//アラートを表示
	UIAlertView *_alertView = nil;
	_alertView = [[UIAlertView alloc] initWithTitle:TitleCommonConnecting
											message:MsgCommonPleaseWait
										   delegate:nil
								  cancelButtonTitle:nil
								  otherButtonTitles:nil];
	[_alertView show];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
	
	
	//Dr一覧取得を行う
	NSDictionary *dic = [MrService getDrList];
	
	[_alertView dismissWithClickedButtonIndex:0 animated:YES];
	
	if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {

		//一覧情報取得の成功した場合、テーブルを更新
		[self refreshTableView];
		
		//院内・院外ステートの変更
		[self refreshAreaBtn];
		
		//連絡可否ステートの変更
		[self refreshRenrakuBtn];
		
		//未読通知件数の変更
		[self refreshTuchiBtn];
		
		self.title = [NSString stringWithFormat:@"%@ 専用ページ",[[Configuration userMaster]valueForKeyPath:@"contents.user_info.user_name"]];		
		
	}
	else {
		//一覧情報取得に失敗した場合、メッセージ表示
		[AlertFactory showMessage:dic[@"result_title"] message:dic[@"result_message"]];
	}

}

/**
 *  テーブルのデータソースを取得して再描画する
 */
- (void)refreshTableView
{
	_info_list = [[NSMutableArray alloc] initWithArray:[[Configuration userListMaster] valueForKeyPath:@"contents.info"]];
	_request_info = [[NSMutableArray alloc] initWithArray:[[Configuration userListMaster] valueForKeyPath:@"contents.request_info"]];
	
	[_tableView reloadData];
}

/**
 *  院内外ボタンの表示を変更する
 */
- (void)refreshAreaBtn
{
	//院内外ステートの取得
	NSString *callpermit_flg = [UserFactory inRoomFlg];
	
	if ([callpermit_flg isEqualToString:@"1"]) {
		
		[_areaBtn setTitle:@"院内" forState:UIControlStateNormal];
		[Configuration setCurrentState:YES];
	}
	else {
		[_areaBtn setTitle:@"院外" forState:UIControlStateNormal];
		[Configuration setCurrentState:NO];
	}
	
}

/**
 *  連絡可否ボタンの表示を変更する
 */
- (void)refreshRenrakuBtn
{
	
	//連絡可否ステートの取得
	NSString *callpermit_flg = [NSString stringWithString:[[Configuration userMaster] valueForKeyPath:@"contents.user_info.callpermit_flg"]];
	
	if ([callpermit_flg isEqualToString:@"1"]) {
		
		[_renrakuBtn setTitle:@"連絡可" forState:UIControlStateNormal];
		[Configuration setEnabledContact:YES];
	}
	else {
		[_renrakuBtn setTitle:@"連絡不可" forState:UIControlStateNormal];
		[Configuration setEnabledContact:NO];
	}
}

/**
 *  通知ボタンの件数表示を変更する
 */
- (void)refreshTuchiBtn
{
	
	//通知ボタンの件数取得
	NSString *badge_count = [NSString stringWithFormat:@"%@",[[Configuration userListMaster] valueForKeyPath:@"contents.all_message_cnt"]];
		
	for (id obj in [_tuchiBtn subviews]) {
		
		if ([obj isKindOfClass:[LKBadgeView class]]) {
			[obj removeFromSuperview];
		}
	}
	
	if (![badge_count isEqualToString:@"0"]) {
		
		_tuchiBadgeView = [[LKBadgeView alloc] initWithFrame:CGRectMake(_tuchiBtn.frame.size.width-30.f, 9.f, 40, 30)];
		[_tuchiBtn addSubview:_tuchiBadgeView];
		_tuchiBadgeView.badgeColor = RGB(246,95,61);
		_tuchiBadgeView.textColor = [UIColor whiteColor];
		_tuchiBadgeView.text = badge_count;
		_tuchiBadgeView.horizontalAlignment = LKBadgeViewHorizontalAlignmentLeft;
		_tuchiBadgeView.widthMode = LKBadgeViewWidthModeSmall;

		
	}

}

/**
 *  設定画面に遷移
 */
- (void)setting:(id)sender
{
	[self.navigationController pushViewController:[[SettingViewController alloc]init] animated:YES];
}

/**
 *  連絡可否ボタンが押されたときの処理
 */
- (void)renrakuBtnClick:(id)sender
{
	UIAlertView *_alertView = nil;
	_alertView = [[UIAlertView alloc] initWithTitle:TitleCommonConnecting
											message:MsgCommonPleaseWait
										   delegate:self
								  cancelButtonTitle:nil
								  otherButtonTitles:nil];
	[_alertView show];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
	
	//連絡可否ステータス更新API
	NSDictionary *dic = [MrService changeUserEditCallpermit:![Configuration enabledContact]];
	
	//更新の成功
	if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
		
		//利用者情報を取得する
		dic = [MasterService getUserInfo];
		
		//アラートを閉じる
		[_alertView dismissWithClickedButtonIndex:0 animated:NO];
		
		//利用者情報取得の成功
		if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
			
			//連絡可否ステートの変更
			[self refreshRenrakuBtn];
			
		}
		else {
			//一覧情報取得に失敗した場合、メッセージ表示
			[AlertFactory showMessage:dic[@"result_title"] message:dic[@"result_message"]];
		}
	}
	else {
		
		//アラートを閉じる
		[_alertView dismissWithClickedButtonIndex:0 animated:NO];
		
		//ステータス更新に失敗した場合、メッセージ表示
		[AlertFactory showMessage:dic[@"result_title"] message:dic[@"result_message"]];
	}

}

/**
 *  通知ボタンが押されたときの処理
 *
 *  @param sender オブジェクト
 */
- (void)tuchiBtnClick:(id)sender
{

	NSString *badge_count = [NSString stringWithFormat:@"%@",[[Configuration userListMaster] valueForKeyPath:@"contents.all_message_cnt"]];
	
	if ([badge_count isEqualToString:@"0"]) {
		
		UIAlertView *_alertView = nil;
		_alertView = [[UIAlertView alloc] initWithTitle:TitleCommonConfirm
												message:MsgUnreadMessagesZero
											   delegate:nil
									  cancelButtonTitle:nil
									  otherButtonTitles:BtnCommonConfirm, nil];
		[_alertView show];
		
		
	}
	else {
		[self.navigationController pushViewController:[[NoticeViewController alloc]init] animated:YES];
	}
}

#pragma mark - TableView Button Action
- (void)applyRequest:(NSDictionary *)drDic
{
	//アラートを表示
	UIAlertView *_alertView = nil;
	_alertView = [[UIAlertView alloc] initWithTitle:TitleCommonConnecting
											message:MsgCommonPleaseWait
										   delegate:self
								  cancelButtonTitle:nil
								  otherButtonTitles:nil];
	[_alertView show];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];


	NSDictionary *dic = [MrService applyRequest:drDic];

	[_alertView dismissWithClickedButtonIndex:0 animated:NO];
	
	if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
		
		//データの取得+テーブルの更新
		[self sendRequest];
	
	}

		
	//コミュニケート申請処理の成否メッセージ表示
	[AlertFactory showMessage:dic[@"result_title"] message:dic[@"result_message"]];

}

/**
 *  コンタクト申請ボタンを押したときの処理
 */
- (void)applyBtnClick:(id)sender event:(UIEvent *)event
{
	
	_current_indexPath = [self indexPathForControlEvent:event];
	
	UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:TitleApprovalAsk
														 message:MsgApprovalAsk
														delegate:self
											   cancelButtonTitle:BtnApprovalCancel
											   otherButtonTitles:BtnApprovalDone,nil];
	_alertView.tag = alert_type_approval;
	[_alertView show];
}

/**
 *  呼び出しボタンを押したときの処理
 */
- (void)calledBtnClick:(id)sender event:(UIEvent *)event
{
	_current_indexPath = [self indexPathForControlEvent:event];
	
	UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:TitleCalledAsk
														 message:MsgCalledAsk
														delegate:self
											   cancelButtonTitle:BtnCalledDone
											   otherButtonTitles:nil,nil];
	_alertView.tag = alert_type_callMR;
	[_alertView show];
	
}

/**
 *  メッセージボタンが押されたときの処理
 */
- (void)messageBtnClick:(id)sender event:(UIEvent *)event
{

	_current_indexPath = [self indexPathForControlEvent:event];
	
	SOMessageViewController *controller = [[SOMessageViewController alloc]init];
	controller.userDic = [NSDictionary dictionaryWithDictionary:[_info_list objectAtIndex:_current_indexPath.row]];
	
	
	[self.navigationController pushViewController:controller animated:YES];

}

// UIControlEventからタッチ位置のindexPathを取得する
- (NSIndexPath *)indexPathForControlEvent:(UIEvent *)event
{
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint p = [touch locationInView:_tableView];
	NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:p];
	return indexPath;
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if (alertView.tag == alert_type_callMR) {

		SOMessageViewController *controller = [[SOMessageViewController alloc]init];
		controller.userDic = [NSDictionary dictionaryWithDictionary:[_info_list objectAtIndex:_current_indexPath.row]];

		[self.navigationController pushViewController:controller animated:YES];
		
		
	}
	else if (alertView.tag == alert_type_approval) {
		
		switch (buttonIndex) {
			case 1:
				
				[self applyRequest:[_request_info objectAtIndex:_current_indexPath.row]];
				
				break;
		}

	}
	
}

#pragma mark - UITableView delegate
//ヘッダセクションの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

	CGFloat height= 0.0;
	
	if ((section==0) && (_info_list.count!=0)) {
		height = 30.0;
	}

	if ((section==1) && (_request_info.count!=0)) {
		height = 30.0;
	}

	return height;
}

//ヘッダセクションのレイアウトをカスタマイズ
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *containerView = [[UIView alloc] init];
	
	PaddingLabel *titleLabel = [[PaddingLabel alloc] init];
	titleLabel.frame = CGRectMake(0, 0, 320, 30);
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:14];
	
	switch (section) {
		case 0:
			titleLabel.text = @"承認済Dr一覧";
			titleLabel.backgroundColor = RGB(243, 119, 84);
			break;
		case 1:
			titleLabel.text = @"未承認Dr一覧";
			titleLabel.backgroundColor = RGB(78, 146, 218);
			break;
			
		default:
			break;
	}
	
	containerView.alpha = 0.7;
	[containerView addSubview:titleLabel];
	return containerView;
}

//ヘッダセクションの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows;
	
	switch (section) {
		case 0:
			rows = _info_list.count;
			break;
		case 1:
			rows = _request_info.count;
			break;
		default:
			rows = 0;
			break;
	}
	
	return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static const id identifiers[3] = {@"approval", @"nonrecognition", @"cell"};
	NSString *CellIdentifier = identifiers[indexPath.section];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	//再利用できるセルがなければ新規作成
	if (cell == nil) {
		switch (indexPath.section) {
			case 0:
				cell = [[MrApprovalTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
				break;
			case 1:
				cell = [[MrNonrecognitionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
				break;
			default:
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
				break;
		}
	}


	if (indexPath.section==0) {
		
		MrApprovalTableViewCell *cell1 = (MrApprovalTableViewCell *)cell;

		//サムネイル
		[cell1.imageView sd_setImageWithURL:[NSURL URLWithString:[[_info_list objectAtIndex:indexPath.row]valueForKey:@"user_logo_url_thumbnailurl"]] placeholderImage:[UIImage imageNamed:@"no-image.png"]];

		cell1.imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		//名前
		cell1.textLabel.text = [NSString stringWithFormat:@"%@", [[_info_list objectAtIndex:indexPath.row]valueForKey:@"user_name"]];
		
		//部門
		cell1.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@",
									  [Utility changeNullOrEmpty:[[_info_list objectAtIndex:indexPath.row]valueForKey:@"company_name"]],
									  [Utility changeNullOrEmpty:[[_info_list objectAtIndex:indexPath.row]valueForKey:@"hospital_department_cd_name"]]];
		
		cell1.detailTextLabel.numberOfLines = 2;
		cell1.detailTextLabel.textColor = RGB(159, 159, 159);

		//院内外フラグ
		NSString *inroom_flg = [Utility changeNullOrEmpty:[[_info_list objectAtIndex:indexPath.row]valueForKey:@"inroom_flg"]];
		//連絡可否フラグ
		NSString *callpermit_flg = [Utility changeNullOrEmpty:[[_info_list objectAtIndex:indexPath.row]valueForKey:@"callpermit_flg"]];

		cell1.areaBtn.enabled = NO;
		
		if (([inroom_flg isEqualToString:@"1"]&&[callpermit_flg isEqualToString:@"1"])) {
			//院内外アイコン
			cell1.areaBtn.hidden = NO;
		}
		else {
			cell1.areaBtn.hidden = YES;
		}
	
		//呼出のバッジ処理
		if (![[[[_info_list objectAtIndex:indexPath.row]valueForKey:@"call_message_cnt"]stringValue]isEqualToString:@"0"]) {

			cell1.calledBtn.hidden = NO;
			
			LKBadgeView* badgeView = [[LKBadgeView alloc] initWithFrame:CGRectMake(cell1.calledBtn.frame.size.width-10.f, 10.f, 35, 30)];
			[cell1.calledBtn addSubview:badgeView];
			badgeView.badgeColor = RGB(246,95,61);
			badgeView.textColor = [UIColor whiteColor];
			badgeView.text = [NSString stringWithFormat:@"%@", [[_info_list objectAtIndex:indexPath.row]valueForKey:@"call_message_cnt"]];
			badgeView.horizontalAlignment = LKBadgeViewHorizontalAlignmentLeft;
			badgeView.widthMode = LKBadgeViewWidthModeSmall;

		}
		else {
			
			for (id obj in [cell1.calledBtn subviews]) {

				if ([obj isKindOfClass:[LKBadgeView class]]) {
					[obj removeFromSuperview];
				}
			}

			cell1.calledBtn.hidden = YES;
		}
		
		//MR呼出され処理
		[cell1.calledBtn addTarget:self action:@selector(calledBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
	

		//メッセージ
		if (![[[[_info_list objectAtIndex:indexPath.row]valueForKey:@"message_cnt"]stringValue]isEqualToString:@"0"]) {
						
			LKBadgeView* badgeView = [[LKBadgeView alloc] initWithFrame:CGRectMake(cell1.messageBtn.frame.size.width-10.f, 10.f, 35, 30)];
			[cell1.messageBtn addSubview:badgeView];
			badgeView.badgeColor = RGB(246,95,61);
			badgeView.textColor = [UIColor whiteColor];
			badgeView.text = [NSString stringWithFormat:@"%@", [[_info_list objectAtIndex:indexPath.row]valueForKey:@"message_cnt"]];
			badgeView.horizontalAlignment = LKBadgeViewHorizontalAlignmentLeft;
			badgeView.widthMode = LKBadgeViewWidthModeSmall;
		}
		else {
						
			for (id obj in [cell1.messageBtn subviews]) {
				
				if ([obj isKindOfClass:[LKBadgeView class]]) {
					[obj removeFromSuperview];
				}
			}
		}
		
		//メッセージ遷移
		[cell1.messageBtn addTarget:self action:@selector(messageBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
		
		
		[[cell1.areaBtn imageView] setContentMode:UIViewContentModeScaleAspectFit];
		[[cell1.calledBtn imageView] setContentMode:UIViewContentModeScaleAspectFit];
		[[cell1.messageBtn imageView] setContentMode:UIViewContentModeScaleAspectFit];
		
		
	}
	else if (indexPath.section==1) {

		MrNonrecognitionTableViewCell *cell1 = (MrNonrecognitionTableViewCell *)cell;

		//サムネイル
		[cell1.imageView sd_setImageWithURL:[NSURL URLWithString:[[_request_info objectAtIndex:indexPath.row]valueForKey:@"user_logo_url_thumbnailurl"]] placeholderImage:[UIImage imageNamed:@"no-image.png"]];

		cell1.imageView.contentMode = UIViewContentModeScaleAspectFit;		
		
		//名前
		cell1.textLabel.text = [NSString stringWithFormat:@"%@", [[_request_info objectAtIndex:indexPath.row]valueForKey:@"user_name"]];

		//部門
		cell1.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@",
									  [Utility changeNullOrEmpty:[[_request_info objectAtIndex:indexPath.row]valueForKey:@"company_name"]],
									  [Utility changeNullOrEmpty:[[_request_info objectAtIndex:indexPath.row]valueForKey:@"hospital_department_cd_name"]]];
		cell1.detailTextLabel.numberOfLines = 2;
		cell1.detailTextLabel.textColor = RGB(159, 159, 159);
	
		cell1.areaBtn.hidden = YES;

	
		//申請
		if ([Utility changeNullOrEmpty:[[_request_info objectAtIndex:indexPath.row]valueForKey:@"comm_apply_flg"]].length != 0) {
		
			if ([[[_request_info objectAtIndex:indexPath.row]valueForKey:@"comm_apply_flg"]isEqualToString:@"1"]) {

				cell1.applyBtn.hidden = YES;
			}
			else {
				
				cell1.applyBtn.hidden = NO;
				//申請
				cell1.applyBtn.tag = indexPath.row;
				[cell1.applyBtn addTarget:self action:@selector(applyBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
			}
			
		}

		[[cell1.areaBtn imageView] setContentMode:UIViewContentModeScaleAspectFit];
		[[cell1.applyBtn imageView] setContentMode:UIViewContentModeScaleAspectFit];
		
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

@end
