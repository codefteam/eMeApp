//
//  Configuration.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/07/28.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "Configuration.h"

@implementation Configuration

# pragma mark - 初回起動フラグ
+ (BOOL)firstboot
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults setObject:@"YES" forKey:@"First_Boot"];
	[userDefaults registerDefaults:defaults];
	
	return [userDefaults boolForKey:@"First_Boot"];
}

+ (void)setFirstboot:(BOOL)yesno
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:yesno forKey:@"First_Boot"];
	[userDefaults synchronize];
}

# pragma mark - Apnsデバイストークン
+ (NSString *)pushDeviceToken
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	//初期値の設定
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"" forKey:@"PushDeviceToken"];
	[userDefaults registerDefaults:appDefaults];
	
	return [userDefaults objectForKey:@"PushDeviceToken"];
}

+ (void)setPushDeviceToken:(NSString *)value
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:value forKey:@"PushDeviceToken"];
	[userDefaults synchronize];
}

# pragma mark - 位置情報サービスアクセス許可フラグ
+ (BOOL)gpsPermission
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	return [userDefaults boolForKey:@"GPS_Permission"];
}

+ (void)setGpsPermission:(BOOL)yesno
{
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:yesno forKey:@"GPS_Permission"];
	[userDefaults synchronize];
}

# pragma mark - bluetoothサービスアクセス許可フラグ
+ (BOOL)bluetoothPermission
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	return [userDefaults boolForKey:@"Bluetooth_Permission"];
}

+ (void)setBluetoothPermission:(BOOL)yesno
{
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:yesno forKey:@"Bluetooth_Permission"];
	[userDefaults synchronize];
}

# pragma mark - 院内・院外ステート
+ (BOOL)currentState
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults setObject:@"NO" forKey:@"Current_State"];
	[userDefaults registerDefaults:defaults];
	
	return [userDefaults boolForKey:@"Current_State"];
}

+ (void)setCurrentState:(BOOL)yesno
{
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:yesno forKey:@"Current_State"];
	[userDefaults synchronize];
}

# pragma mark - 領域観測のステート
+ (BOOL)currentGpsState
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	return [userDefaults boolForKey:@"GPS_State"];
}

+ (void)setCurrentGpsState:(BOOL)yesno
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:yesno forKey:@"GPS_State"];
	[userDefaults synchronize];
}

# pragma mark - Beaconのステート
+ (BOOL)currentBeaconState
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	return [userDefaults boolForKey:@"Beacon_State"];

}

+ (void)setCurrentBeaconState:(BOOL)yesno
{
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:yesno forKey:@"Beacon_State"];
	[userDefaults synchronize];
}

# pragma mark - ログインID
+ (NSString *)loginID
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	//初期値の設定
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"" forKey:@"loginID"];
	[userDefaults registerDefaults:appDefaults];
	
	return [userDefaults objectForKey:@"loginID"];
}

+ (void)setLoginID:(NSString *)value
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:value forKey:@"loginID"];
	[userDefaults synchronize];
}


# pragma mark - パスワード
+ (NSString *)password
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	//初期値の設定
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"" forKey:@"password"];
	[userDefaults registerDefaults:appDefaults];
	
	return [userDefaults objectForKey:@"password"];
}

+ (void)setPassword:(NSString *)value
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:value forKey:@"password"];
	[userDefaults synchronize];
}


# pragma mark - 現在位置の病院・会社コード
+ (NSString *)currentLocation
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	//初期値の設定
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"" forKey:@"CurrentLocation"];
	[userDefaults registerDefaults:appDefaults];
	
	return [userDefaults objectForKey:@"CurrentLocation"];
}

+ (void)setCurrentLocation:(NSString *)value
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:value forKey:@"CurrentLocation"];
	[userDefaults synchronize];
}

# pragma mark - GPSで取得した現在位置の病院・会社コード
+ (NSString *)currentGPSLocation
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	//初期値の設定
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"" forKey:@"CurrentGPSLocation"];
	[userDefaults registerDefaults:appDefaults];
	
	return [userDefaults objectForKey:@"CurrentGPSLocation"];
}

+ (void)setCurrentGPSLocation:(NSString *)value
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:value forKey:@"CurrentGPSLocation"];
	[userDefaults synchronize];
}

# pragma mark - Bluetusで取得した現在位置の病院・会社コード
+ (NSString *)currentBeaconLocation
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	//初期値の設定
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"" forKey:@"CurrentBeaconLocation"];
	[userDefaults registerDefaults:appDefaults];
	
	return [userDefaults objectForKey:@"CurrentBeaconLocation"];
}

+ (void)setCurrentBeaconLocation:(NSString *)value
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:value forKey:@"CurrentBeaconLocation"];
	[userDefaults synchronize];
}

# pragma mark - ログイン情報
+ (NSDictionary *)loginInfo
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [userDefaults objectForKey:@"LoginInfo"];
	NSDictionary *dic= [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	return dic;
}

+ (void)setLoginInfo:(NSDictionary *)dic
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
	[userDefaults setObject:data forKey:@"LoginInfo"];
	[userDefaults synchronize];
}

# pragma mark - 病院・会社マスタ
+ (NSDictionary *)company
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [userDefaults objectForKey:@"Company"];
	NSDictionary *dic= [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	return dic;
}

+ (void)setCompany:(NSDictionary *)dic
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
	[userDefaults setObject:data forKey:@"Company"];
	[userDefaults synchronize];
}

# pragma mark - 診療所・部門マスタ
+ (NSDictionary *)department
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [userDefaults objectForKey:@"Department"];
	NSDictionary *dic= [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	return dic;
}

+ (void)setDepartment:(NSDictionary *)dic
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
	[userDefaults setObject:data forKey:@"Department"];
	[userDefaults synchronize];
}

# pragma mark - 病院契約会社マスタ
+ (NSDictionary *)contract
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [userDefaults objectForKey:@"Contract"];
	NSDictionary *dic= [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	return dic;
}

+ (void)setContract:(NSDictionary *)dic
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
	[userDefaults setObject:data forKey:@"Contract"];
	[userDefaults synchronize];
}


# pragma mark - タクシーマスタ
+ (NSDictionary *)taxi
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [userDefaults objectForKey:@"Taxi"];
	NSDictionary *dic= [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	return dic;
}

+ (void)setTaxi:(NSDictionary *)dic
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
	[userDefaults setObject:data forKey:@"Taxi"];
	[userDefaults synchronize];
}

# pragma mark - beaconマスタ
+ (NSDictionary *)beacon
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [userDefaults objectForKey:@"Beacon"];
	NSDictionary *dic= [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	return dic;
}

+ (void)setBeacon:(NSDictionary *)dic
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
	[userDefaults setObject:data forKey:@"Beacon"];
	[userDefaults synchronize];
}

# pragma mark - 利用者情報
+ (NSDictionary *)userMaster
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [userDefaults objectForKey:@"userMaster"];
	NSDictionary *dic= [NSKeyedUnarchiver unarchiveObjectWithData:data];

	return dic;
}

+ (void)setUserMaster:(NSDictionary *)dic
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
	[userDefaults setObject:data forKey:@"userMaster"];
	[userDefaults synchronize];
}

# pragma mark - 利用者一覧情報
+ (NSDictionary *)userListMaster
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [userDefaults objectForKey:@"userListMaster"];
	NSDictionary *dic= [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	return dic;

}

+ (void)setUserListMaster:(NSDictionary *)dic
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
	[userDefaults setObject:data forKey:@"userListMaster"];
	[userDefaults synchronize];
}

# pragma mark - 連絡可否フラグ
+ (BOOL)enabledContact
{
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	//初期値の設定
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"0" forKey:@"EnabledContact"];
	[userDefaults registerDefaults:appDefaults];
	
	return [userDefaults boolForKey:@"EnabledContact"];
}

+ (void)setEnabledContact:(BOOL)value
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:value forKey:@"EnabledContact"];
	[userDefaults synchronize];
}

# pragma mark - 未読メッセージ情報
+ (NSDictionary *)unreadMessages
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [userDefaults objectForKey:@"unreadMessages"];
	NSDictionary *dic= [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	return dic;

}

+ (void)setUnreadMessages:(NSDictionary *)dic
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
	[userDefaults setObject:data forKey:@"unreadMessages"];
	[userDefaults synchronize];
}

@end
