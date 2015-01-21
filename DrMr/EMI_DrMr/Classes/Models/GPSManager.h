//
//  GPSManager.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/09/12.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSManager : NSObject

+ (GPSManager *)sharedManager;
- (void)startMonitoring;
- (void)stopMonitoring;


@end
