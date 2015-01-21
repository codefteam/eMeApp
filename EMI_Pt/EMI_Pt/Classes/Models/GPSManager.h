//
//  GPSManager.h
//  EMI_Pt
//
//  Created by esukei on 2014/08/07.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSManager : NSObject

+ (GPSManager *)sharedManager;
- (void)startMonitoring;
- (void)stopMonitoring;
- (BOOL)isMonitoringActivated;

@end
