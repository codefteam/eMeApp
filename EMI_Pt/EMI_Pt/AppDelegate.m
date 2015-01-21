//
//  AppDelegate.m
//  EMI_Pt
//
//  Created by esukei on 2014/07/18.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "AppDelegate.h"
#import "StartPageViewController.h"
#import "InsideViewController.h"
#import "OutsideViewController.h"

#import "PermissionObserver.h"
#import "StateObserver.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
		
	//window設定
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];
	

	//領域の入った/出たなどでアプリが起動された
	if([[launchOptions allKeys] containsObject:UIApplicationLaunchOptionsLocationKey]) {
		
		[self changeIndication];
		
	}
	
	//キー監視
	[[StateObserver sharedManager]startStateObserver];
	[[PermissionObserver sharedManager]startPermissionObserver];
	//ナビゲーションのテーマの設定
	[Utility setupAppTheme];
//	//アプリ起動時のキーボード表示が遅いための処理
	UITextField *lagFreeField = [[UITextField alloc] init];
	[self.window addSubview:lagFreeField];
	[lagFreeField becomeFirstResponder];
	[lagFreeField resignFirstResponder];
	[lagFreeField removeFromSuperview];
	
	
	UINavigationController *navigationController;
	navigationController = [[UINavigationController alloc]initWithRootViewController:[[StartPageViewController alloc]init]];
		
	self.window.rootViewController = navigationController;

	//アクセス制限変更の通知センターを取得する
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(permissionStatusChange)
												 name:@"PermissionStatusChange"
											   object:nil];
	
	//院内院外変更の通知センターを取得する
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(changeIndication)
												 name:@"RegionStatusChange"
											   object:nil];
	
	
	[self.window makeKeyAndVisible];
	return YES;
}

#pragma mark - Ation
- (void)changeIndication
{
		
	UINavigationController *navigationController;
	
	if ([Configuration currentState]) {
			
		navigationController = [[UINavigationController alloc]initWithRootViewController:[[InsideViewController alloc]init]];
			
	}
	else {

		navigationController = [[UINavigationController alloc]initWithRootViewController:[[OutsideViewController alloc]init]];
	}
	
	self.window.rootViewController = navigationController;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
//	[self changeIndication];
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

/**
 *  URL Schemeが呼ばれたときの処理
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	
	// 通知を作成する
	NSNotification *notification;
	notification = [NSNotification notificationWithName:@"RegionStatusChange"
												 object:self
											   userInfo:nil];
	// 通知実行
	[[NSNotificationCenter defaultCenter] postNotification:notification];
	
	return YES;
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
