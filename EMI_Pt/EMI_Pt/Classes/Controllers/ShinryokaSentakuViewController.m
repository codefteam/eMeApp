//
//  ShinryokaSentakuViewController.m
//  EMI_Pt
//
//  Created by esukei on 2014/10/30.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "ShinryokaSentakuViewController.h"
#import "BrowserViewController.h"

@interface ShinryokaSentakuViewController ()<UITableViewDelegate, UITableViewDataSource>
{
	UITableView *_tableView;
	NSMutableArray *_value_list;
}
@end


@implementation ShinryokaSentakuViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"診療科目案内";
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
	
	
	NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:[[Configuration department]valueForKeyPath:@"contents.data"]];
	
	for (NSString *key in mdic.allKeys) {
		[_value_list addObject:[mdic objectForKey:key]];
	}
	
	_value_list = [Utility sortArray:_value_list withKey:@"sort_no.intValue" ascending:YES];
	
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSections
{
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"▼確認したい診療科を選択してください";
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
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *urlStr = [[_value_list objectAtIndex:indexPath.row]objectForKey:@"company_hp"];
	
	if (urlStr.length != 0) {
		
		BrowserViewController *browserViewController = [[BrowserViewController alloc]init];
		browserViewController.title = [[_value_list objectAtIndex:indexPath.row]objectForKey:@"label"];
		browserViewController.requestURL =urlStr;
		
		[self.navigationController pushViewController:browserViewController animated:YES];
		
	}
	else {
		
		[Utility showMessage:TitleCommonConfirm message:MsgDepartmentZero];
		
	}
	
}


@end
