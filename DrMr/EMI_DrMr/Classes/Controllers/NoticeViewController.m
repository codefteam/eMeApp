//
//  NoticeViewController.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/07/25.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "NoticeViewController.h"
#import "SOMessageViewController.h"
#import "NoticeTableViewCell.h"

#import "UIImageView+WebCache.h"

#import "MessageService.h"
#import "DrService.h"
#import "AlertFactory.h"


#define not_data		5

#define type_message	0
#define type_apply		1
#define type_approval	2
#define type_callMR		3


@interface NoticeViewController ()<UITableViewDataSource, UITableViewDelegate>
{
	UITableView *_tableView;
	NSMutableArray *_value_list;
}
@property (nonatomic, strong)NSIndexPath *current_indexPath;

@end

@implementation NoticeViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"通知";
	self.view.backgroundColor = [UIColor whiteColor];
	
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)
											  style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	[self.view addSubview:_tableView];
	
	//cell.imageviewの下線が表示されるようにするため
	if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[_tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//プッシュ通知を受け取る
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(refreshTableView)
												 name:@"PushNotification"
											   object:nil];

	//コミュニケート申請を受け取った際の通知を取得
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(refreshTableView)
												 name:@"PushNotification0003"
											   object:nil];
	
	//フォアグラウンドになった際の通知を取得
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(refreshTableView)
												 name:UIApplicationWillEnterForegroundNotification
											   object:[UIApplication sharedApplication]];
	
}

- (void)viewDidAppear:(BOOL)animated
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
	
	[self refreshTableView];
	
	[_alertView dismissWithClickedButtonIndex:0 animated:NO];
	
	if (_value_list.count==0) {

		//通知一覧がなかったときの処理
		UIAlertView *_alertView=[[UIAlertView alloc]initWithTitle:@""
														  message:MsgUnreadMessagesZero
														 delegate:self
												cancelButtonTitle:nil
												otherButtonTitles:BtnCommonConfirm,nil,nil];
	
		_alertView.tag = not_data;
		[_alertView show];
	}
	
	[super viewDidAppear:animated];
	
}

- (void)viewDidDisappear:(BOOL)animated
{
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self];
	
	[super viewDidDisappear:animated];
}

#pragma mark - Action
- (void)refreshTableView
{
	
	NSDictionary *dic = [MessageService getUnreadMessages];
	
	_value_list = [NSMutableArray array];
	
	if ([[dic valueForKeyPath:@"contents.message_list"]isKindOfClass:[NSArray class]]) {
		
		for (NSDictionary *obj_dic in [dic valueForKeyPath:@"contents.message_list"]) {
			
			NSDictionary *temp_dic = [NSDictionary dictionaryWithDictionary:obj_dic];
			[_value_list addObject:temp_dic];
			
		}
	}
	
	[_tableView reloadData];
	
}

- (void)accessoryButtonClick:(id)sender event:(UIEvent *)event
{
	
	_current_indexPath = [self indexPathForControlEvent:event];
	
	UIButton *btn = (UIButton *)sender;
	//メッセージ
	if (btn.tag==type_message) {
		
		NSString *user_id = [[_value_list objectAtIndex:_current_indexPath.row]valueForKey:@"from_user_id"];
		
		NSDictionary *userDic;
		
		//DrかMRか判定
		if ([[UserFactory userHighClassCd] isEqualToString:Dr_user_high_class_cd]) {
			
			NSMutableArray *temp_ary = [[NSMutableArray alloc] initWithArray:[[Configuration userListMaster] valueForKeyPath:@"contents.member_info"]];
			
			for (NSDictionary *temp_dic in temp_ary) {
		
				if ([user_id isEqualToString:temp_dic[@"user_id"]]) {
					userDic = temp_dic;
					break;
				}
				
			}

		}
		else {
			
			NSMutableArray *temp_ary = [[NSMutableArray alloc] initWithArray:[[Configuration userListMaster] valueForKeyPath:@"contents.info"]];
			
			for (NSDictionary *temp_dic in temp_ary) {
							
				if ([user_id isEqualToString:temp_dic[@"user_id"]]) {
					userDic = temp_dic;
					break;
				}
				
			}
			
		}
				
		SOMessageViewController *controller = [[SOMessageViewController alloc]init];
		controller.userDic = userDic;
		
		[self.navigationController pushViewController:controller animated:YES];
		
	}
	else if (btn.tag==type_apply) {
		
		UIAlertView *_alertView=[[UIAlertView alloc]initWithTitle:TitleApprovalAgreeAsk
														  message:MsgApprovalAgreeAsk
														 delegate:self
												cancelButtonTitle:BtnApprovalAgreeCancel
												otherButtonTitles:BtnApprovalAgreeDone,nil,nil];
		_alertView.tag = type_apply;
		[_alertView show];
		
	}
	else if (btn.tag==type_approval) {
		
		UIAlertView *_alertView=[[UIAlertView alloc]initWithTitle:@"確認"
														  message:@"コミュニケート申請が承認されました"
														 delegate:self
												cancelButtonTitle:nil
												otherButtonTitles:BtnCommonConfirm,nil,nil];
		_alertView.tag = type_approval;
		[_alertView show];
		
	}
	else if (btn.tag==type_callMR) {
		
		UIAlertView *_alertView=[[UIAlertView alloc]initWithTitle:TitleCalledAsk
														  message:MsgCalledAsk
														 delegate:self
												cancelButtonTitle:nil
												otherButtonTitles:BtnCalledDone,nil,nil];
		_alertView.tag = type_callMR;
		[_alertView show];
		
	}
	
}

// UIControlEventからタッチ位置のindexPathを取得する
- (NSIndexPath *)indexPathForControlEvent:(UIEvent *)event
{
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint p = [touch locationInView:_tableView];
	NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:p];
	return indexPath;
}

#pragma mark - TableView Button Action
- (void)applyAgree:(NSDictionary *)mrDic
{

	NSDictionary *dic = [DrService applyAgree:mrDic];
	
	if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {

		//コミュニケート申請承認した場合
		[self refreshTableView];
		
		if (_value_list.count==0) {
			
			//通知一覧がなかったときの処理
			UIAlertView *_alertView=[[UIAlertView alloc]initWithTitle:@""
															  message:MsgUnreadMessagesZero
															 delegate:self
													cancelButtonTitle:nil
													otherButtonTitles:BtnCommonConfirm,nil,nil];
			
			_alertView.tag = not_data;
			[_alertView show];
		}
			
	}
	else {
		[AlertFactory showMessage:dic[@"result_title"] message:dic[@"result_message"]];
	}
	
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	switch (buttonIndex) {
		case 0:
			
			if (alertView.tag == not_data) {
				//通知一覧がなかったときの処理
				[self.navigationController popViewControllerAnimated:YES];
				
			}
			else if (alertView.tag == type_callMR) {
				
				NSString *user_id = [[_value_list objectAtIndex:_current_indexPath.row]valueForKey:@"from_user_id"];
				
				NSDictionary *userDic;
				
				//DrかMRか判定
				if ([[UserFactory userHighClassCd] isEqualToString:Dr_user_high_class_cd]) {
					
					NSMutableArray *temp_ary = [[NSMutableArray alloc] initWithArray:[[Configuration userListMaster] valueForKeyPath:@"contents.member_info"]];
					
					for (NSDictionary *temp_dic in temp_ary) {
												
						if ([user_id isEqualToString:temp_dic[@"user_id"]]) {
							userDic = temp_dic;
							break;
						}
						
					}
					
				}
				else {
					
					NSMutableArray *temp_ary = [[NSMutableArray alloc] initWithArray:[[Configuration userListMaster] valueForKeyPath:@"contents.info"]];
					
					for (NSDictionary *temp_dic in temp_ary) {
											
						if ([user_id isEqualToString:temp_dic[@"user_id"]]) {
							userDic = temp_dic;
							break;
						}
						
					}
					
				}
				
				SOMessageViewController *controller = [[SOMessageViewController alloc]init];
				controller.userDic = userDic;
				
				[self.navigationController pushViewController:controller animated:YES];
			}
			
			break;
		case 1:
			
			if (alertView.tag == type_apply) {
				//コミュニケート申請承認処理
				NSString *user_id = [[_value_list objectAtIndex:_current_indexPath.row]valueForKey:@"from_user_id"];
				
				NSDictionary *userDic;
				
				NSDictionary *dic =[NSDictionary dictionaryWithDictionary:[Configuration userListMaster]];
				
				NSMutableArray *temp_ary = [[NSMutableArray alloc] initWithArray:[dic valueForKeyPath:@"contents.request_info"]];
				
				for (NSDictionary *temp_dic in temp_ary) {
										
					if ([user_id isEqualToString:temp_dic[@"user_id"]]) {
						userDic = temp_dic;
						break;
					}
					
				}
				
				//コミュニケート申請で承認する場合
				[self applyAgree:userDic];
				
			}
			else if (alertView.tag == type_approval) {
				//コミュニケート申請承認OK通知処理?
			}
			else if (alertView.tag == type_callMR) {
				
				NSString *user_id = [[_value_list objectAtIndex:_current_indexPath.row]valueForKey:@"from_user_id"];
				
				NSDictionary *userDic;
				
				//DrかMRか判定
				if ([[UserFactory userHighClassCd] isEqualToString:Dr_user_high_class_cd]) {
					
					NSMutableArray *temp_ary = [[NSMutableArray alloc] initWithArray:[[Configuration userListMaster] valueForKeyPath:@"contents.member_info"]];
					
					for (NSDictionary *temp_dic in temp_ary) {
						
						if ([user_id isEqualToString:temp_dic[@"user_id"]]) {
							userDic = temp_dic;
							break;
						}
						
					}
					
				}
				else {
					
					NSMutableArray *temp_ary = [[NSMutableArray alloc] initWithArray:[[Configuration userListMaster] valueForKeyPath:@"contents.info"]];
					
					for (NSDictionary *temp_dic in temp_ary) {
						
						if ([user_id isEqualToString:temp_dic[@"user_id"]]) {
							userDic = temp_dic;
							break;
						}
						
					}
					
				}
				
				SOMessageViewController *controller = [[SOMessageViewController alloc]init];
				controller.userDic = userDic;
				
				[self.navigationController pushViewController:controller animated:YES];
			}
			else if (alertView.tag == not_data) {
				//通知一覧がなかったときの処理
				[self.navigationController popViewControllerAnimated:YES];
				
			}

			break;
	}

}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

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
	return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"Cell";
	
	NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[NoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
	
	cell.textLabel.text = [[_value_list objectAtIndex:indexPath.row]objectForKey:@"user_name"];
	cell.detailTextLabel.text = [[_value_list objectAtIndex:indexPath.row]objectForKey:@"delivery_dte"];
	cell.detailTextLabel.textColor = RGB(159, 159, 159);
	
	[cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[_value_list objectAtIndex:indexPath.row]objectForKey:@"user_logo_uri"]] placeholderImage:[UIImage imageNamed:@"no-image.png"]];
	cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
	

	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(0, 0, 80, 35);

	NSString *notice_type = [[_value_list objectAtIndex:indexPath.row]objectForKey:@"message_class"];
	
	
	//メッセージ
	if ([notice_type isEqualToString:@"0001"]) {
		[button setImage:[UIImage imageNamed:@"btn1_1.png"] forState:UIControlStateNormal];
		button.tag = type_message;
	}
	//コミュニケート申請
	else if ([notice_type isEqualToString:@"0002"]) {
		[button setImage:[UIImage imageNamed:@"btn1_2.png"] forState:UIControlStateNormal];
		button.tag = type_apply;
		
	}
	//コミュニケート申請承認
	else if ([notice_type isEqualToString:@"0003"]) {
		[button setImage:[UIImage imageNamed:@"btn1_3.png"] forState:UIControlStateNormal];
		button.tag = type_approval;
		
	}
	//MR呼出
	else if ([notice_type isEqualToString:@"0004"]) {
		[button setBackgroundImage:[UIImage imageNamed:@"btn1_4.png"] forState:UIControlStateNormal];
		button.tag = type_callMR;
		
	}
	
	
	[button setTitleColor:RGB(244,161,122) forState:UIControlStateNormal];
	button.backgroundColor = [UIColor clearColor];
	[button addTarget:self
			   action:@selector(accessoryButtonClick:event:)
	 forControlEvents:UIControlEventTouchUpInside];
	cell.accessoryView = button;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}


@end
