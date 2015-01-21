//
//  GPSManager.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/09/12.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "GPSManager.h"
#import <MapKit/MapKit.h>

@interface GPSManager()<CLLocationManagerDelegate>
{
	BOOL isFirstState;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@end


@implementation GPSManager
static GPSManager *sharedGPSManager = nil;


#pragma mark - Initialization
+ (GPSManager *)sharedManager
{
	//①シングルトンオブジェクト生成
	@synchronized(self) {
		if (sharedGPSManager == nil) {
			sharedGPSManager = [[self alloc] init];
		}
	}
	return sharedGPSManager;
}

/**
 *  初期化
 */
- (id)init
{
	//②初期設定
	if (self = [super init]) {
		
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		[_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
		[_locationManager setDistanceFilter:kCLDistanceFilterNone];
	
	}
	return self;
}

/**
 *  領域観測地を設定
 */
- (void)setGeofencing
{
	
	NSMutableArray *_value_list = [NSMutableArray array];
	
	NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:[Configuration company]];

	for (NSString *key in mdic.allKeys) {
		
		NSMutableDictionary *entry = [[NSDictionary dictionaryWithDictionary:[mdic objectForKey:key]]mutableCopy];
		[entry setObject:key forKey:@"parent_cd"];
		[_value_list addObject:entry];

		NSString *identifier = key;
		NSString *geofence = [entry objectForKey:@"geofence"];
		NSString *longlat = [entry objectForKey:@"latitude-longitude"];
		NSArray *ary = [longlat componentsSeparatedByString:@"∀"];
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[ary objectAtIndex:0]floatValue], [[ary objectAtIndex:1]floatValue]);
		CLLocationDistance radiusOnMeter = [geofence floatValue];
		
		CLRegion *_grRegion = [self makeRegion:coordinate radiusOnMeter:radiusOnMeter identifier:identifier];
		
		[_locationManager startMonitoringForRegion:_grRegion];
		
	}
	
	//③監視領域設定
	PrintLog(@"観測数=%d", (int)[self.locationManager.monitoredRegions allObjects].count);

}

/**
 *  領域観測の開始
 */
- (void)startMonitoring
{

	isFirstState = NO;
	[Configuration setCurrentGPSLocation:@""];
	
	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
	
	switch (status) {
		// 位置情報サービスへのアクセスが許可されている
		// 位置情報サービスへのアクセスが許可が確認されていない
		case kCLAuthorizationStatusAuthorized:

			[Configuration setGpsPermission:YES];
			[self setGeofencing];
			
			break;
			
		case kCLAuthorizationStatusNotDetermined:
			[Configuration setGpsPermission:NO];
			[self setGeofencing];
	
			break;
			
		// 設定 > 一般 > 機能制限で利用が制限されている
		// ユーザーがこのアプリでの位置情報サービスへのアクセスを許可していない
		case kCLAuthorizationStatusRestricted:
		case kCLAuthorizationStatusDenied:
			
			[Configuration setGpsPermission:NO];

			break;
			
		default:
			break;
	}

}

/**
 *  領域観測の終了
 */
- (void)stopMonitoring
{
	
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		
		if ([CLLocationManager isMonitoringAvailableForClass:[CLRegion class]]) {
			// （不必要になったら）位置情報サービスの停止
			for (CLRegion *region in self.locationManager.monitoredRegions) {
				// 登録してある地点を全て取得し、停止
				[self.locationManager stopMonitoringForRegion:region];
			}

		}
	}
	else {
		if ([CLLocationManager regionMonitoringAvailable]) {
			// （不必要になったら）位置情報サービスの停止
			for (CLRegion *region in self.locationManager.monitoredRegions) {
				// 登録してある地点を全て取得し、停止
				[self.locationManager stopMonitoringForRegion:region];
			}
		}
	}
	
	[Configuration setCurrentGpsState:NO];
	
}

#pragma mark - CLLocationManager delegate
// 領域観測が正常に開始されると呼ばれる
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
	//④現在の状態を取得する
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		[self.locationManager requestStateForRegion:region];
	}
}

// 初回領域に関する状態を取得する
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
	//⑤領域の判定
	switch (state) {
		case CLRegionStateInside:
			
			isFirstState = YES;
			[Configuration setCurrentGPSLocation:[region identifier]];
			
			break;
			
		case CLRegionStateOutside:
				
			isFirstState = NO;
			[Configuration setCurrentGPSLocation:@""];
			
			break;
			
		case CLRegionStateUnknown:

			isFirstState = NO;
			[Configuration setCurrentGPSLocation:@""];
			
			break;
			
		default:

			break;

	}

	[Configuration setCurrentGpsState:isFirstState];
	
}

// 領域に入ると呼ばれる
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
	//⑥領域に入った際に呼ばれる
	[Configuration setCurrentGPSLocation:[region identifier]];
	[Configuration setCurrentGpsState:YES];
}

// 領域から出ると呼ばれる
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
	//⑥領域から出る際に呼ばれる
	[Configuration setCurrentGPSLocation:@""];
	[Configuration setCurrentGpsState:NO];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
	//⑤位置情報サービスに許可を与えていない or エラー時に呼ばれる
	[Configuration setCurrentGpsState:NO];
	
	switch (error.code) {
		case kCLErrorDenied: // 確認ダイアログで許可しないを選択した
		{
			[Configuration setGpsPermission:NO];
		}
			break;
			
		default:
		{
			if (error.code == 4) {
				
				[Configuration setGpsPermission:NO];
			}
			else if ((error.domain != kCLErrorDomain || error.code != 5) &&
				[manager.monitoredRegions containsObject:region]) {
				
				[Configuration setGpsPermission:NO];
			}
		}
			break;
	}
	
}

/**
 *  位置情報サービスのアクセス制限が変更した時に呼ばれる
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	switch (status) {
		// 設定 > 一般 > 機能制限で利用が制限されている
		// ユーザーがこのアプリでの位置情報サービスへのアクセスを許可していない
		case kCLAuthorizationStatusRestricted:
		case kCLAuthorizationStatusDenied:

			[Configuration setGpsPermission:NO];
			[Configuration setCurrentGPSLocation:@""];

			break;

		case kCLAuthorizationStatusNotDetermined:
			
			[Configuration setGpsPermission:NO];
			[Configuration setCurrentGPSLocation:@""];
			
			break;
			
		case kCLAuthorizationStatusAuthorized:
			
			[Configuration setGpsPermission:YES];

			[self stopMonitoring];
			[self startMonitoring];
			
			break;
			
		default:


			break;
	}
}


#pragma mark - Private methods
- (CLRegion *)makeRegion:(CLLocationCoordinate2D)coordinate radiusOnMeter:(CLLocationDistance)radiusOnMeter identifier:(NSString *)identifier
{
	
	CLRegion *_grRegion;
	
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		
		_grRegion = (CLRegion *)[[CLCircularRegion alloc] initWithCenter:coordinate
																  radius:radiusOnMeter
															  identifier:identifier];
		
	}else {
		_grRegion = [[CLRegion alloc] initCircularRegionWithCenter:coordinate
															radius:radiusOnMeter
														identifier:identifier];
		
	}
	
	return _grRegion;
}


@end
