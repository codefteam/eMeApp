//
//  Configuration.m
//  EMI_Pt
//
//  Created by esukei on 2014/07/22.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "Configuration.h"

@implementation Configuration

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


+ (NSDictionary *)selectCompany
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [userDefaults objectForKey:@"SelectCompany"];
	NSDictionary *dic= [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	return dic;
}

+ (void)setSelectCompany:(NSDictionary *)dic
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
	[userDefaults setObject:data forKey:@"SelectCompany"];
	[userDefaults synchronize];
}

//病院+診察券番号データ
+ (NSDictionary *)numberTickets
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:[NSKeyedArchiver archivedDataWithRootObject:[NSDictionary dictionary]] forKey:@"NumberTickets"];
	[userDefaults registerDefaults:appDefaults];
	
	NSData *data = [userDefaults objectForKey:@"NumberTickets"];
	NSDictionary *dic= [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	
	return dic;
}

+ (void)setNumberTickets:(NSDictionary *)dic
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
	[userDefaults setObject:data forKey:@"NumberTickets"];
	[userDefaults synchronize];
}

+ (NSString *)numberTicket
{

	NSString *numberTicket = @"";
	
	NSString *tempStr = [[Configuration numberTickets]objectForKey:[[Configuration selectCompany]valueForKey:@"parent_cd"]];
	
	if (tempStr.length != 0) {
		numberTicket = tempStr;
	}
	
	return numberTicket;
	
//	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//	//初期値の設定
//	NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"" forKey:@"NumberTicket"];
//	[userDefaults registerDefaults:appDefaults];
//	
//	return [userDefaults objectForKey:@"NumberTicket"];
}

+ (void)setNumberTicket:(NSString *)value
{
	
//	NSString *tempStr = [[Configuration numberTickets]objectForKey:[[Configuration selectCompany]valueForKey:@"parent_cd"]];
	
	NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[Configuration numberTickets]];
	NSMutableDictionary *mdic = [dic mutableCopy];
	[mdic setObject:value forKey:[[Configuration selectCompany]valueForKey:@"parent_cd"]];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mdic];
	[userDefaults setObject:data forKey:@"NumberTickets"];
	
	[userDefaults synchronize];
	
	
//	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//	[userDefaults setObject:value forKey:@"NumberTicket"];
//	[userDefaults synchronize];
}

//病院・会社マスタ
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

//診療所・部門マスタ
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

//病院契約会社マスタ
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


//タクシーマスタ
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

@end
