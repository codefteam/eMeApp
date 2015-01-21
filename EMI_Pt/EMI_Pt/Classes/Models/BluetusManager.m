//
//  BluetusManager.m
//  EMI_Pt
//
//  Created by Esukei Company on 2014/09/16.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "BluetusManager.h"
#import "RakuzaBeaconReceiver.h"


@interface BluetusManager()<RakuzaBeaconReceiverDelegate>
{
	RakuzaBeaconReceiver *rakuzaReceiver;
	NSMutableArray *discoverList;
	int count;
}
@property (nonatomic, strong)NSTimer *repeatTimer;

@end


@implementation BluetusManager
static BluetusManager *sharedBeaconManager = nil;


#pragma mark - Initialization
+ (BluetusManager *)sharedManager
{
	@synchronized(self) {
		if (sharedBeaconManager == nil) {
			sharedBeaconManager = [[self alloc] init];
		}
	}
	return sharedBeaconManager;
}

- (id)init
{
	if (self = [super init]) {
		
		rakuzaReceiver = [[RakuzaBeaconReceiver alloc] initWithRakuzaApiKey:RakuzaApiKey];
		rakuzaReceiver.delegate = self;
		discoverList = [[NSMutableArray alloc] init];
		
	}
	return self;
}

//監視の開始
- (void)startScanning
{
	
	if (!rakuzaReceiver) {
		rakuzaReceiver = [[RakuzaBeaconReceiver alloc] initWithRakuzaApiKey:RakuzaApiKey];
		rakuzaReceiver.delegate = self;
	}
	
	[Configuration setCurrentBeaconState:NO];
	
	[self stopRepeatTimer];
	
	[self startRepeatTimer];
}

//監視の終了
- (void)stopScanning
{
	[self stopRepeatTimer];

	[Configuration setCurrentBeaconState:NO];
	[self searchStop];

}

//タイマーの開始
- (void)startRepeatTimer
{
	
	NSTimer *_timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
													   target:self
													 selector:@selector(eventRepeatTimer:)
													 userInfo:nil
													  repeats:YES];
	
	self.repeatTimer = _timer;
}

- (void)stopRepeatTimer
{
	
	if ([self.repeatTimer isValid]) {
		[self.repeatTimer invalidate];
		self.repeatTimer = nil;
	}
	
}

- (void)eventRepeatTimer:(NSTimer *)timer
{
	count++;
	NSLog(@"非受信期間 = %d秒", count);
	
	if (count==20) {
		
		[Configuration setCurrentBeaconState:NO];
		
	}
}

#pragma mark - BluetusReceiverDelegate
// Beacon検知準備完了時の処理を実装する
- (void)didFinishReadyForSearchBeacons
{
	[self searchStart];
}

// RakuzaBeaconRecieverからの配信情報を受信したときの処理を実装する
- (void)didDiscoverBeacon:(NSDictionary *)getDataSet RSSI:(NSNumber *)RSSI Time:(NSDate *)receivedTime Err:(int)errnum
{
	if ((errnum == ENON) || (errnum == EINFODATA)) {
				
		// -----受信エラーなし-----
		NSLog(@"RSSI---%@",RSSI);
		NSLog(@"BEACON_ID---%@",[NSString stringWithString:[getDataSet objectForKey:KEY_FOR_ID]]);
		

		NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:[[Configuration beacon]valueForKeyPath:@"contents.data"]];
		
		for (NSString *key in mdic.allKeys) {
			
			NSMutableDictionary *entry = [[NSDictionary dictionaryWithDictionary:[mdic objectForKey:key]]mutableCopy];
			
			if ([[entry objectForKey:@"beacon_id"]isEqualToString:[NSString stringWithString:[getDataSet objectForKey:KEY_FOR_ID]]]) {


				NSDictionary *comDic = [[[Configuration company]valueForKeyPath:@"contents.data"]objectForKey:[entry objectForKey:@"company"]];
				
				if (comDic != nil) {
				
					if ([RSSI floatValue] >= [[entry objectForKey:@"beacon_area"]floatValue]) {
						count = 0;
						[Configuration setCurrentBeaconState:YES];
												
					}
					
				}
			}
		}
			
		if (self.repeatTimer != nil) {
			
			if (![self.repeatTimer isValid]) {
				
				[self startRepeatTimer];
			}
			
		}
		
	} else {
		// -----データ受信なし-----
	}
}

// CoreBluetoothの状態が変わった時の処理を実装する
- (void)beaconReceiverCentralManagerDidUpdateState:(CBCentralManagerState)state
{
	switch (state) {
			// CoreBluetooth フレームワークがパワーオンしたときの処理
		case CBCentralManagerStatePoweredOn:
			
			[Configuration setBluetoothPermission:YES];
			
			break;
			
			// iOS 端末の Bluetooth 設定がオフのときの処理
		case CBCentralManagerStatePoweredOff:
			
			[Configuration setBluetoothPermission:NO];
			
			break;
			
		case CBCentralManagerStateResetting:
			
			[Configuration setBluetoothPermission:NO];
			
			break;
			
			// アプリケーションが Bluetooth Low Energy を使う認可がないときの処理
		case CBCentralManagerStateUnauthorized:
			
			[Configuration setBluetoothPermission:NO];
			
			break;
			
			// iOS 端末が Bluetooth Low Energy 非対応のときの処理
		case CBCentralManagerStateUnsupported:
			
			[Configuration setBluetoothPermission:NO];
			
			break;
			
		case CBCentralManagerStateUnknown:
			
			[Configuration setBluetoothPermission:NO];
			
			break;
			
		default:
			break;
	}
}

//Bluetus電波測定開始
- (void)searchStart
{
	[rakuzaReceiver searchStart];
}

//Bluetus電波測定終了
- (void)searchStop
{
	[rakuzaReceiver searchStop];
	rakuzaReceiver.delegate = nil;
	rakuzaReceiver = nil;
}

@end
