//
//  StateObserver.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/15.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "StateObserver.h"


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
		
		
		[Configuration setCurrentState:isCurrentState];
		/**
		 *  ①アプリ内に通知を行う
		 */
		
		//アプリ内通知を行う
		NSNotification *notification = [NSNotification notificationWithName:@"WillRegionStatusChange" object:self];
		// 通知実行！
		[[NSNotificationCenter defaultCenter] postNotification:notification];
			
		
		
	}
	
}


@end
