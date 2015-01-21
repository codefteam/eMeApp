//
//  Utility.m
//  EMI_Pt
//
//  Created by esukei on 2014/08/27.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (void)setupAppTheme
{

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		//テーマ
		[UINavigationBar appearance].barTintColor = RGB(57,211,111);
		[UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
	}
#endif
	
}

/**
 *  メッセージを表示する
 */
+ (void)showMessage:(NSString*)title message:(NSString*)message
{
	UIAlertView *_alertView = nil;
	_alertView=[[UIAlertView alloc]initWithTitle:title
										 message:message
										delegate:nil
							   cancelButtonTitle:nil
							   otherButtonTitles:BtnCommonConfirm,nil,nil];
	[_alertView show];
}

+ (NSMutableArray *)sortArray:(NSMutableArray*)array withKey:(NSString*)key ascending:(BOOL)yesno
{
	
	NSSortDescriptor *sortDescNumber;
	sortDescNumber = [[NSSortDescriptor alloc] initWithKey:key ascending:yesno];
	
	// NSSortDescriptorは配列に入れてNSArrayに渡す
	NSArray *sortDescArray;
	sortDescArray = [NSArray arrayWithObjects:sortDescNumber, nil];
	
	// ソートの実行
	NSArray *sortArray;
	sortArray = [array sortedArrayUsingDescriptors:sortDescArray];

	return [sortArray mutableCopy];
}

@end
