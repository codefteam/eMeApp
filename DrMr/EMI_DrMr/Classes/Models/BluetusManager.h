//
//  BluetusManager.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/09/16.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BluetusManager : NSObject

+ (BluetusManager *)sharedManager;
- (void)startScanning;
- (void)stopScanning;

@end
