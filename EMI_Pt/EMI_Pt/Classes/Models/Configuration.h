//
//  Configuration.h
//  EMI_Pt
//
//  Created by esukei on 2014/07/22.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
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


+ (NSDictionary *)selectCompany;
+ (void)setSelectCompany:(NSDictionary *)dic;

//病院+診察券番号データ
+ (NSDictionary *)numberTickets;
+ (void)setNumberTickets:(NSDictionary *)dic;

//診察券番号
+ (NSString *)numberTicket;
+ (void)setNumberTicket:(NSString *)value;


/**
 *  マスタデータ
 */
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


@end
