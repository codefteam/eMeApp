//
//  Utility.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/08/21.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "Utility.h"

@implementation Utility


+ (NSString *)version
{
	NSString *version = (NSString *)[NSString stringWithString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];

	return version;
	
}

+ (void)setupAppTheme
{
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		
			//テーマ
			[UINavigationBar appearance].barTintColor = RGB(244,161,122);
			[UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
		
		}
	#endif
	
}


/**
 *  Nullを判定し空文字を返す
 *
 *  @param obj オブジェクト
 *
 *  @return NSString
 */
+ (NSString *)changeNullOrEmpty:(id)obj
{

	if (obj == [NSNull null] || obj == nil) {
		obj = @"";
	}
	
	return obj;
}

+ (NSString *)currentDate:(NSString *)formatStr
{
	//NSDateFormatterクラスを出力する。
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	//Localeを指定。ここでは日本を設定。
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
	//出力形式を文字列で指定する。
	[dateFormatter setDateFormat:formatStr];
	// 現在時刻を取得しつつ、NSDateFormatterクラスをかませて、文字列を出力する。
	NSString *StTime = [dateFormatter stringFromDate:[NSDate date]];
	
	return StTime;
}

@end
