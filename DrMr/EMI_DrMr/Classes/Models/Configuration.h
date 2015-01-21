//
//  Configuration.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/07/28.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject


//初回起動フラグ
+ (BOOL)firstboot;
+ (void)setFirstboot:(BOOL)yesno;

//Apnsデバイストークン
+ (NSString *)pushDeviceToken;
+ (void)setPushDeviceToken:(NSString *)value;

//位置情報サービスアクセス許可フラグ
+ (BOOL)gpsPermission;
+ (void)setGpsPermission:(BOOL)yesno;

//bluetoothサービスアクセス許可フラグ
+ (BOOL)bluetoothPermission;
+ (void)setBluetoothPermission:(BOOL)yesno;

//院内・院外ステート
+ (BOOL)currentState;
+ (void)setCurrentState:(BOOL)yesno;

//領域観測のステート
+ (BOOL)currentGpsState;
+ (void)setCurrentGpsState:(BOOL)yesno;

//Beaconのステート
+ (BOOL)currentBeaconState;
+ (void)setCurrentBeaconState:(BOOL)yesno;

//ログインID
+ (NSString *)loginID;
+ (void)setLoginID:(NSString *)value;

//パスワード
+ (NSString *)password;
+ (void)setPassword:(NSString *)value;

//現在位置の病院・会社コード
+ (NSString *)currentLocation;
+ (void)setCurrentLocation:(NSString *)value;

//GPSで取得した現在位置の病院・会社コード
+ (NSString *)currentGPSLocation;
+ (void)setCurrentGPSLocation:(NSString *)value;

//Bluetusで取得した現在位置の病院・会社コード
+ (NSString *)currentBeaconLocation;
+ (void)setCurrentBeaconLocation:(NSString *)value;


/**
 *  マスタデータ
 */
//ログイン情報
+ (NSDictionary *)loginInfo;
+ (void)setLoginInfo:(NSDictionary *)dic;

//病院・会社マスタ
+ (NSDictionary *)company;
+ (void)setCompany:(NSDictionary *)dic;

//診療所・部門マスタ
+ (NSDictionary *)department;
+ (void)setDepartment:(NSDictionary *)dic;

//病院契約会社マスタ
+ (NSDictionary *)contract;
+ (void)setContract:(NSDictionary *)dic;

//タクシーマスタ
+ (NSDictionary *)taxi;
+ (void)setTaxi:(NSDictionary *)dic;

//Beaconマスタ
+ (NSDictionary *)beacon;
+ (void)setBeacon:(NSDictionary *)dic;

//利用者情報
+ (NSDictionary *)userMaster;
+ (void)setUserMaster:(NSDictionary *)dic;

//利用者一覧情報
+ (NSDictionary *)userListMaster;
+ (void)setUserListMaster:(NSDictionary *)dic;

//連絡可フラグ
+ (BOOL)enabledContact;
+ (void)setEnabledContact:(BOOL)value;

//未読メッセージ情報
+ (NSDictionary *)unreadMessages;
+ (void)setUnreadMessages:(NSDictionary *)dic;


@end
