//
//  StateObserver.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/15.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "StateObserver.h"
#import "DrService.h"
#import "MrService.h"
#import "AlertFactory.h"


@implementation StateObserver
static StateObserver *sharedStateObserver = nil;

+ (StateObserver *)sharedManager
{
	//①シングルトンオブジェクト生成
	@synchronized(self) {
		if (sharedStateObserver == nil) {
			sharedStateObserver = [[self alloc] init];
		}
	}
	return sharedStateObserver;
}

- (id)init
{
	if (!self) {
		self = [super init];
	}
	return self;
}

- (void)startStateObserver
{
	[[NSUserDefaults standardUserDefaults] addObserver:self
											forKeyPath:@"GPS_State"
											   options:NSKeyValueObservingOptionNew
											   context:nil];

	[[NSUserDefaults standardUserDefaults] addObserver:self
											forKeyPath:@"Beacon_State"
											   options:NSKeyValueObservingOptionNew
											   context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	
	
	BOOL isCurrentState = NO;

	if ([Configuration currentGpsState] || [Configuration currentBeaconState]) {
		
		isCurrentState = YES;
	}

	if ([Configuration currentState] != isCurrentState) {
		

		/**
		 *  ①DRかMRか判定
		 *  ②MRの場合現在の病院コード取得
		 *  ③院内外ステータス更新API
		 *  ④アプリ内に通知を行う
		 */
		
		NSDictionary *dic;
		
		if ([[UserFactory userHighClassCd] isEqualToString:Dr_user_high_class_cd]) {
			
			dic = [DrService changeUserEditInroom:isCurrentState];
		}
		else {
			
			dic = [MrService changeUserEditInroom:isCurrentState];
		}
		
		if ([dic[@"status"]isEqualToString:APIResponseNormalStatusCode]) {
			
			//利用者情報を取得する
			dic = [MasterService getUserInfo];
			
			//アプリ内通知を行う
			NSNotification *notification = [NSNotification notificationWithName:@"RegionStatusChange" object:self];
			// 通知実行！
			[[NSNotificationCenter defaultCenter] postNotification:notification];
			
			[Configuration setCurrentState:isCurrentState];
			
		}
	}
}


@end
