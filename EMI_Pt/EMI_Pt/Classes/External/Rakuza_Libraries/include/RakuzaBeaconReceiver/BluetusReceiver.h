//
//  BluetusReceiver.h
//  BluetusReceiver
//
//  Created by ERi-mizuno on 2013/02/07.
//  Copyright (c) 2013年 ERi-iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


//=========================================================
// 定数定義
//=========================================================
// エラーコード
#define ENON        (0)     /* エラーなし */
#define EINFODATA   (-1)    /* 配信情報有効範囲外 */

// データ取得キー
#define KEY_FOR_TARNAME             @"keyForDeviceID"
#define KEY_FOR_ID                  @"keyForID"
#define KEY_FOR_LATITUDE            @"keyForLatitude"
#define KEY_FOR_LONGITUDE           @"keyForLongitude"
#define KEY_FOR_SHORTURL            @"keyForShortURL"
#define KEY_FOR_URL                 @"keyForURL"
#define KEY_FOR_THRESHOLDRSSI_IDX
#define KEY_FOR_THRESHOLDRSSI_DBM
#define KEY_FOR_AVERAGERSSI


//=========================================================
// メソッド・変数
//=========================================================
@protocol BluetusReceiverDelegate <NSObject>
@optional
// BLUETUS発見時に呼ばれる
- (void)didDiscoverBluetus:(NSDictionary *)getDataSet
                      RSSI:(NSNumber *)RSSI
                      Time:(NSDate *)receivedTime
                       Err:(int)errnum;

// CoreBluetoothフレームワークのCBCentralManagerクラスのステートが変化したときに呼ばれる
- (void)bluetusReceiverCentralManagerDidUpdateState:(CBCentralManagerState)state;
@end


@interface BluetusReceiver : NSObject
@property (nonatomic, assign) id<BluetusReceiverDelegate> delegate;

- (id)initWithDecryptKey:(NSString *)decryptkey;
- (void)startScanning;
- (void)stopScanning;
- (NSString *)readVersion;

@end

