//
//  PermissionObserver.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/10.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "PermissionObserver.h"

@implementation PermissionObserver
static PermissionObserver *sharedPermissionObserver = nil;

+ (PermissionObserver *)sharedManager
{
	//①シングルトンオブジェクト生成
	@synchronized(self) {
		if (sharedPermissionObserver == nil) {
			sharedPermissionObserver = [[self alloc] init];
		}
	}
	return sharedPermissionObserver;
}

- (id)init
{
	//②初期設定
	if (self = [super init]) {
		
	}
	return self;
}

- (void)startPermissionObserver
{
	
	[[NSUserDefaults standardUserDefaults] addObserver:self
											forKeyPath:@"GPS_Permission"
											   options:NSKeyValueObservingOptionNew
											   context:nil];
	
	[[NSUserDefaults standardUserDefaults] addObserver:self
											forKeyPath:@"Bluetooth_Permission"
											   options:NSKeyValueObservingOptionNew
											   context:nil];
	
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	
	
	//アプリ内通知を行う
	NSNotification *notification = [NSNotification notificationWithName:@"PermissionStatusChange" object:self];
	// 通知実行！
	[[NSNotificationCenter defaultCenter] postNotification:notification];
	
	
}

@end
