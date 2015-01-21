//
//  SOMessageViewController.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/09/03.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "SOMessageViewController.h"
#import "MessageService.h"
#import "Message.h"
#import "AlertFactory.h"


@interface SOMessageViewController ()
{
	int _page_count;
}

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;

@end

@implementation SOMessageViewController


#pragma mark - View lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = [self.userDic valueForKey:@"user_name"];
	
	self.view.backgroundColor = RGB(142, 211, 209);

	UIImage *img;
	NSData *dt = [NSData dataWithContentsOfURL:
				  [NSURL URLWithString:[self.userDic valueForKey:@"user_logo_url_thumbnailurl"]]];
	if (dt.length==0) {
		img = [UIImage imageNamed:@"no-image.png"];
	}
	else {
		img = [[UIImage alloc] initWithData:dt];
	}
	
	self.partnerImage = img;
	
	
	//         Customizing input view
	//--------------------------------------------------
	self.inputView.textInitialHeight = 45;
	self.inputView.textView.font = [UIFont systemFontOfSize:17];
	
	// Apply changes
	[self.inputView adjustInputView];
	//--------------------------------------------------
	
	_page_count = 0;
	
	[self loadMessages:0];


	//自身の院内外フラグ
	NSString *my_inroom_flg = [UserFactory inRoomFlg];
	//自身の連絡可否フラグ
	NSString *my_callpermit_flg = [NSString stringWithString:[[Configuration userMaster] valueForKeyPath:@"contents.user_info.callpermit_flg"]];

	
	//相手の院内外フラグ
	NSString *other_inroom_flg = self.userDic[@"inroom_flg"];
	//相手の連絡可否フラグ
	NSString *other_callpermit_flg = self.userDic[@"callpermit_flg"];

	
	if ([my_inroom_flg isEqualToString:@"1"]&&
		[my_callpermit_flg isEqualToString:@"1"]&&
		[other_inroom_flg isEqualToString:@"1"]&&
		[other_callpermit_flg isEqualToString:@"1"]) {
		self.inputView.hidden = NO;
	}
	else {
		self.inputView.hidden = YES;
	}

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//apnsプッシュ通知を受け取った際の通知を取得
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateByNotice)
												 name:@"PushNotification"
											   object:nil];
	//フォアグラウンドになった際の通知を取得
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateByNotice)
												 name:UIApplicationWillEnterForegroundNotification
											   object:[UIApplication sharedApplication]];
	
	
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self];
	
	
	[super viewDidDisappear:animated];
}

- (void)updateByNotice
{
	if (_page_count==0) {
		[self loadMessages:0];
	}
}

- (void)loadMessages:(int)add_page
{
	
	self.tableView.tableHeaderView = [self tableHeaderViewFactory];
	
	NSString *start_page_num = [NSString stringWithFormat:@"%d", (_page_count + (add_page)) * 50];
	
	NSDictionary *dic = [MessageService getMessages:self.userDic displayCt:@"50" pageNm:start_page_num];

	NSMutableArray *result = [NSMutableArray new];
	
	
	if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {

		NSString *total_ct = [[dic valueForKeyPath:@"contents.total_ct"] stringValue];
		
		//一覧情報取得の成功した場合、テーブルを更新
		if (![total_ct isEqualToString:@"0"]) {
			
			NSMutableArray *mary = [[NSMutableArray alloc] initWithArray:[dic valueForKeyPath:@"contents.message_list"]];
			
			if (mary.count != 0) {
				
				for (NSDictionary *tDic in mary) {
					
					Message *message = [[Message alloc] init];
					
					if ([[UserFactory userID]isEqualToString:[tDic objectForKey:@"from_user_id"]]) {
						message.fromMe = YES;
					}
					else {
						message.fromMe = NO;
					}
					
					message.text = [NSString stringWithString:tDic[@"message_body"]];
					message.type = SOMessageTypeText;
					
					
					NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
					[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
					
					NSDate *formatterDate = [formatter dateFromString:tDic[@"delivery_dte"]];
					message.date = formatterDate;
					
					[result addObject:message];
				}
				
				self.dataSource = [result mutableCopy];
				
				_page_count = _page_count+add_page;
				
			}
		}
		else {
			//メッセージがなかったときの処理
			[AlertFactory showMessage:TitleCommonConfirm message:MsgMessagesZero];

		}

		if (_page_count == 0) {
			self.tableView.tableFooterView = nil;
		}
		else {
			self.tableView.tableFooterView = [self tableFooterViewFactory];
		}
		
	}
	else {
		//一覧情報取得に失敗した場合、メッセージ表示
		[AlertFactory showMessage:dic[@"result_title"] message:dic[@"result_message"]];
	}
	
	[self refreshMessages];
}


- (void)backBtnClick:(id)sender
{
	if (_page_count>=0) {

		[self loadMessages:-1];
	}
	else {
		[self loadMessages:0];
	}
		
	[self.tableView reloadData];
}

- (void)nextBtnClick:(id)sender
{
	
	[self loadMessages:1];
	[self.tableView reloadData];
}

#pragma mark - Factory
- (UIView *)tableHeaderViewFactory
{
	UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 73.0)];
	
	UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	nextBtn.frame = CGRectMake(15.f, 10.f, 290.f, 53.f);
	[nextBtn setTitle:@"前の50件" forState:UIControlStateNormal];
	[nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[tableViewHeaderView addSubview:nextBtn];
	
	return tableViewHeaderView;
}

- (UIView *)tableFooterViewFactory
{
	UIView *tableViewFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 73.0)];

	UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	backBtn.frame = CGRectMake(15.f, 10.f, 290.f, 53.f);
	[backBtn setTitle:@"次の50件" forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[tableViewFooterView addSubview:backBtn];
	
	return tableViewFooterView;
}


#pragma mark - SOMessaging data source
- (NSMutableArray *)messages
{
	return self.dataSource;
}

- (CGFloat)heightForMessageForIndex:(NSInteger)index
{
	CGFloat height = [super heightForMessageForIndex:index];
	
	height += 15;
	
	return height;
}

- (void)configureMessageCell:(SOMessageCell *)cell forMessageAtIndex:(NSInteger)index
{
	Message *message = self.dataSource[index];
	
	// Adjusting content for 4pt. (In this demo the width of bubble's tail is 8pt)
	if (!message.fromMe) {
		cell.contentInsets = UIEdgeInsetsMake(0, 4.0f, 0, 0); //Move content for 4 pt. to right
		cell.textView.textColor = [UIColor blackColor];
	}
	else {
		cell.contentInsets = UIEdgeInsetsMake(0, 0, 0, 4.0f); //Move content for 4 pt. to left
		cell.textView.textColor = [UIColor whiteColor];
	}
	

	
	cell.userImageView.layer.cornerRadius = 3;
	
	// Fix user image position on top or bottom.
	cell.userImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	
	// Setting user images
	cell.userImage = message.fromMe ? self.myImage : self.partnerImage;
	
	
	// Disabling left drag functionality
	cell.panGesture.enabled = NO;
	
	
	//-----------------------------------------------//
	//     Adding datetime label under balloon
	//-----------------------------------------------//
	[self generateLabelForCell:cell];
	//-----------------------------------------------//
}

- (void)generateLabelForCell:(SOMessageCell *)cell
{
	static NSInteger labelTag = 90;
	
	Message *message = (Message *)cell.message;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	UILabel *label = (UILabel *)[cell.contentView viewWithTag:labelTag];
	
	if (!label) {
		label = [[UILabel alloc] init];
		label.font = [UIFont systemFontOfSize:10];
		label.textColor = [UIColor grayColor];
		label.tag = labelTag;
		[cell.contentView addSubview:label];
	}
	
	label.text = [formatter stringFromDate:message.date];
	[label sizeToFit];
	CGRect frame = label.frame;
	
	CGFloat topMargin = 5.0f;
	CGFloat leftMargin = 15.0f;
	CGFloat rightMargin = 20.0f;
	
	if (message.fromMe) {
		frame.origin.x = cell.contentView.frame.size.width - cell.userImageView.frame.size.width - frame.size.width - rightMargin;
		frame.origin.y = cell.containerView.frame.origin.y + cell.containerView.frame.size.height + topMargin;
		label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	}
	else {
		frame.origin.x = cell.containerView.frame.origin.x + cell.userImageView.frame.origin.x + cell.userImageView.frame.size.width + leftMargin;
		frame.origin.y = cell.containerView.frame.origin.y + cell.containerView.frame.size.height + topMargin;
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
	}
	
	label.frame = frame;
}

- (UIImage *)balloonImageForSending
{

	UIImage *bubble = [UIImage imageNamed:@"bubble2_r.png"];
	UIColor *color = [UIColor colorWithRed:72.0/255.0 green:185.0/255.0 blue:251.0/255.0 alpha:1.0];
	bubble = [self tintImage:bubble withColor:color];
	
	return [bubble resizableImageWithCapInsets:UIEdgeInsetsMake(17, 21, 16, 27)];
}

- (UIImage *)balloonImageForReceiving
{

	UIImage *bubble = [UIImage imageNamed:@"bubble2_l.png"];
	UIColor *color = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:234.0/255.0 alpha:1.0];
	bubble = [self tintImage:bubble withColor:color];
	
	return [bubble resizableImageWithCapInsets:UIEdgeInsetsMake(17, 27, 21, 17)];
	
}

- (CGFloat)messageMaxWidth
{
	return 140;
}

- (CGSize)userImageSize
{
	return CGSizeMake(60, 60);
}

- (CGFloat)balloonMinHeight
{
	return 60;
}

- (CGFloat)balloonMinWidth
{
	return 243;
}

#pragma mark - SOMessaging delegate
- (void)didSelectMedia:(NSData *)media inMessageCell:(SOMessageCell *)cell
{
	// Show selected media in fullscreen
	[super didSelectMedia:media inMessageCell:cell];
}

- (void)messageInputView:(SOMessageInputView *)inputView didSendMessage:(NSString *)message
{
	if (![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
		return;
	}
	
	
	//通信中のメッセージ表示
	UIAlertView *_alertView = nil;
	
	_alertView = [[UIAlertView alloc] initWithTitle:TitleCommonConnecting
											message:MsgCommonPleaseWait
										   delegate:nil
								  cancelButtonTitle:nil
								  otherButtonTitles:nil];
	[_alertView show];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
	
	
	
	NSDictionary *dic = [MessageService sendMessage:self.userDic message:message];
	
	[_alertView dismissWithClickedButtonIndex:0 animated:NO];
	
	
	if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
		
		[self loadMessages:0];
		[self.tableView reloadData];
		
	}
	else {
		
		inputView.textView.text = message;
		
		//一覧情報取得に失敗した場合、メッセージ表示
		[AlertFactory showMessage:dic[@"result_title"] message:dic[@"result_message"]];
		
	}

}

- (void)messageInputViewDidSelectMediaButton:(SOMessageInputView *)inputView
{
	// Take a photo/video or choose from gallery
}

#pragma mark - Helper methods
- (UIImage *)tintImage:(UIImage *)image withColor:(UIColor *)color
{
	UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0, image.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextSetBlendMode(context, kCGBlendModeNormal);
	CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
	CGContextClipToMask(context, rect, image.CGImage);
	[color setFill];
	CGContextFillRect(context, rect);
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

@end