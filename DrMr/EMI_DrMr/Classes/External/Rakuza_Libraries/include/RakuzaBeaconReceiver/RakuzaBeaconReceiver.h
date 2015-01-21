//
//  RakuzaBeaconReceiver.h
//  RakuzaBeaconReceiver
//
//  Created by psc shunsuke ikumi on 2014/09/05.
//  Copyright (c) 2014年 PeopleSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BluetusReceiver.h"

@protocol RakuzaBeaconReceiverDelegate <NSObject>

// BEACON検知準備完了後に呼ばれる
- (void)didFinishReadyForSearchBeacons;

// BEACON発見時に呼ばれる
- (void)didDiscoverBeacon:(NSDictionary *)getDataSet RSSI:(NSNumber *)RSSI Time:(NSDate *)receivedTime Err:(int)errnum;

// CoreBluetoothフレームワークのCBCentralManagerクラスのステートが変化したときに呼ばれる
- (void)beaconReceiverCentralManagerDidUpdateState:(CBCentralManagerState)state;

@end

@interface RakuzaBeaconReceiver : NSObject<BluetusReceiverDelegate>
@property (nonatomic, assign) id<RakuzaBeaconReceiverDelegate> delegate;

- (id)initWithRakuzaApiKey:(NSString *)rakuzaApiKey;
- (void)searchStart;
- (void)searchStop;

@end
