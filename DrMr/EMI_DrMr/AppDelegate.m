//
//  AppDelegate.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/07/23.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "PermissionObserver.h"
#import "StateObserver.h"
#import <AudioToolbox/AudioServices.h>

@implementation AppDelegate

/**
 *  apnsデバイストークンを取得
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

	NSString *devToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""]
						  stringByReplacingOccurrencesOfString: @" " withString: @""];
	PrintLog(@"deviceToken: %@", devToken);
	
	[Configuration setPushDeviceToken:devToken];
	
}

/**
 *  apnsデバイストークンを取得に失敗
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    /**
     * Change for iOS 8
     * Added by SonTQ on 2015/01/21
     */
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        //プッシュ通知があった場合の設定
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound)];
    }
    
	//windowの設定
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];

	//キー監視の開始
	[[StateObserver sharedManager]startStateObserver];
	[[PermissionObserver sharedManager]startPermissionObserver];
	
	//デフォルトの通知センターを取得する
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(permissionStatusChange)
												 name:@"PermissionStatusChange"
											   object:nil];
	
	//テーマの設定
	[Utility setupAppTheme];
	
	//アプリ起動時のキーボード表示が遅いための処理
	UITextField *lagFreeField = [[UITextField alloc] init];
	[self.window addSubview:lagFreeField];
	[lagFreeField becomeFirstResponder];
	[lagFreeField resignFirstResponder];
	[lagFreeField removeFromSuperview];
		
	//初期表示画面の設定
	UINavigationController *rootNavigationController = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
	self.window.rootViewController = rootNavigationController;

	[self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
		
	UIApplication*   app = [UIApplication sharedApplication];
	__block UIBackgroundTaskIdentifier bgTask;
	bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
		dispatch_async(dispatch_get_main_queue(), ^{
			
			if (bgTask != UIBackgroundTaskInvalid) {
				bgTask = UIBackgroundTaskInvalid;
			}
		});
	}];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		dispatch_async(dispatch_get_main_queue(), ^{
			
			if (bgTask != UIBackgroundTaskInvalid) {
				bgTask = UIBackgroundTaskInvalid;
			}
		});
	});
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
		
	[self permissionStatusChange];
	
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
		
	//アプリがフォアグラウンドで起動している時にPUSH通知を受信した場合
	if (application.applicationState == UIApplicationStateActive) {
		
		//メッセージ:0001
		//コミュニケート申請:0002
		//コミュニケート申請承認:0003
		//MR呼出:0004
		NSString *push_type = [userInfo objectForKey:@"mcls"];
		
		if ([push_type isEqualToString:@"0001"] || [push_type isEqualToString:@"0004"]) {

			//アプリ内通知を行う
			NSNotification *notification = [NSNotification notificationWithName:@"PushNotification" object:self];
			[[NSNotificationCenter defaultCenter] postNotification:notification];
			
		}
		else if ([push_type isEqualToString:@"0002"]) {

			NSNotification *notification = [NSNotification notificationWithName:@"PushNotification0002" object:self];
			[[NSNotificationCenter defaultCenter] postNotification:notification];
			
		}
		else if ([push_type isEqualToString:@"0003"]) {

			NSNotification *notification = [NSNotification notificationWithName:@"PushNotification0003" object:self];
			[[NSNotificationCenter defaultCenter] postNotification:notification];
			
		}
		
		//フォアグラウンド時に音声をならす
		AudioServicesPlaySystemSound (1002);
	}
	
}

- (void)permissionStatusChange
{
	
	[CATransaction begin];
	
	if (![Configuration gpsPermission] || ![Configuration bluetoothPermission]) {

		if (!self.cautionViewController) {

			dispatch_async(dispatch_get_main_queue(), ^{
			
				CautionViewController *cautionViewController = [[CautionViewController alloc] init];
				cautionViewController.delegate = self;
				self.cautionViewController = cautionViewController;
				[self.window.rootViewController presentViewController:self.cautionViewController animated:NO completion:nil];
			});
				
		}
		else {
			[self.cautionViewController refreshState];
		}
		
	}
	else {
		if (self.cautionViewController) {
			
			[self dismissCautionViewController:nil];
			
		}
	}
	
	[CATransaction commit];
	
}

- (void)dismissCautionViewController:(CautionViewController *)cautionViewController
{
		
	dispatch_async(dispatch_get_main_queue(), ^{
	
		[self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
		self.cautionViewController = nil;

	});
				
}


@end
