//
//  GPSManager.m
//  EMI_Pt
//
//  Created by Esukei Company on 2014/08/07.
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
	
	NSString *identifier = [[Configuration selectCompany]objectForKey:@"short_name"];
	NSString *geofence = [[Configuration selectCompany]objectForKey:@"geofence"];
	NSString *longlat = [[Configuration selectCompany]objectForKey:@"latitude-longitude"];
	NSArray *ary = [longlat componentsSeparatedByString:@"∀"];
	
	CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[ary objectAtIndex:0]doubleValue], [[ary objectAtIndex:1]doubleValue]);
	CLLocationDistance radiusOnMeter = [geofence doubleValue];
		
	if (radiusOnMeter > self.locationManager.maximumRegionMonitoringDistance) {
		radiusOnMeter = self.locationManager.maximumRegionMonitoringDistance;
	}
	
	CLRegion *_grRegion = [self makeRegion:coordinate radiusOnMeter:radiusOnMeter identifier:identifier];
		
	[_locationManager startMonitoringForRegion:_grRegion];

	
	//③監視領域設定
	NSLog(@"観測数=%d", [self.locationManager.monitoredRegions allObjects].count);
	
}

- (void)startMonitoring
{
	isFirstState = NO;

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

#pragma mark - CLLocationManagerDelegate
// 領域観測が正常に開始されると呼ばれる
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
	//④現在の状態を取得する
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		[self.locationManager requestStateForRegion:region];
	}
	else {
		[self.locationManager startUpdatingLocation];
	}
}

// 初回領域に関する状態を取得する
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
	//⑤領域の判定
	switch (state) {
		case CLRegionStateInside:

			isFirstState = YES;
			
			break;
			
		case CLRegionStateOutside:
			
			isFirstState = NO;
			
			break;
			
		case CLRegionStateUnknown:

			isFirstState = NO;
			
			break;
			
		default:
			
			break;
			
	}
	
	[Configuration setCurrentGpsState:isFirstState];
	
}

// 領域に入ると呼ばれる
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
	[Configuration setCurrentGpsState:YES];
//	[self sendLocalNotificationForMessage:@"エリア内に入りました"];
}

// 領域から出ると呼ばれる
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
//	[self sendLocalNotificationForMessage:@"エリア外になりました"];
	[Configuration setCurrentGpsState:NO];
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	static BOOL firstTime=YES;
	
	if (firstTime) {
		
		firstTime = NO;
		NSSet * monitoredRegions = _locationManager.monitoredRegions;
		
		if (monitoredRegions) {
			
			[monitoredRegions enumerateObjectsUsingBlock:^(CLRegion *region,BOOL *stop) {
				
				CLLocation *location = [locations lastObject];
				
				NSString *identifer = region.identifier;
				CLLocationCoordinate2D centerCoords =region.center;
				CLLocationCoordinate2D currentCoords= CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
				CLLocationDistance radius = region.radius;

				NSNumber * currentLocationDistance =[self calculateDistanceInMetersBetweenCoord:currentCoords coord:centerCoords];

				if ([currentLocationDistance floatValue] < radius) {
					
					NSLog(@"Invoking didEnterRegion Manually for region: %@",identifer);
					//stop Monitoring Region temporarily
					[_locationManager stopMonitoringForRegion:region];
					[self locationManager:_locationManager didEnterRegion:region];
					//start Monitoing Region again.
					[_locationManager startMonitoringForRegion:region];
				}
				
			}];
		}
		//Stop Location Updation, we dont need it now.
		[_locationManager stopUpdatingLocation];
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
			
			break;
			
		case kCLAuthorizationStatusNotDetermined:

			[Configuration setGpsPermission:NO];
			
			[self stopMonitoring];
			[self startMonitoring];
			
			break;
		default:
			[Configuration setGpsPermission:YES];
			[self stopMonitoring];
			[self startMonitoring];
			break;
	}
}

#pragma mark - Private methods
- (NSNumber*)calculateDistanceInMetersBetweenCoord:(CLLocationCoordinate2D)coord1 coord:(CLLocationCoordinate2D)coord2
{
	NSInteger nRadius = 6371; // Earth's radius in Kilometers
	double latDiff = (coord2.latitude - coord1.latitude) * (M_PI/180);
	double lonDiff = (coord2.longitude - coord1.longitude) * (M_PI/180);
	double lat1InRadians = coord1.latitude * (M_PI/180);
	double lat2InRadians = coord2.latitude * (M_PI/180);
	double nA = pow ( sin(latDiff/2), 2 ) + cos(lat1InRadians) * cos(lat2InRadians) * pow ( sin(lonDiff/2), 2 );
	double nC = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
	double nD = nRadius * nC;
	// convert to meters
	return @(nD*1000);
}


- (CLRegion *)makeRegion:(CLLocationCoordinate2D)coordinate radiusOnMeter:(CLLocationDistance)radiusOnMeter identifier:(NSString *)identifier
{
	
	CLRegion *_grRegion;
	
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		
		_grRegion = (CLRegion *)[[CLCircularRegion alloc] initWithCenter:coordinate
																  radius:radiusOnMeter
															  identifier:identifier];
		
	}
	else {
		
		_grRegion = [[CLRegion alloc] initCircularRegionWithCenter:coordinate
															radius:radiusOnMeter
														identifier:identifier];
		
	}
	
	return _grRegion;
}


- (void)sendLocalNotificationForMessage:(NSString *)message
{
	UILocalNotification *localNotification = [[UILocalNotification alloc]init];
	localNotification.fireDate = [NSDate date];
	localNotification.timeZone = [NSTimeZone localTimeZone];
	localNotification.alertBody = message;
	localNotification.soundName = UILocalNotificationDefaultSoundName;
	NSDictionary *infoDict = [NSDictionary dictionaryWithObject:message forKey:@"GPSStateChange"];
	localNotification.userInfo = infoDict;
	
	[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (BOOL)isMonitoringActivated
{
	NSArray *regionArray = [[self.locationManager monitoredRegions] allObjects];
	return [regionArray count] > 0;
}


@end
