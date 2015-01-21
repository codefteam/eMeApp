//
//  BluetusManager.h
//  EMI_Pt
//
//  Created by esukei on 2014/08/06.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BluetusManager : NSObject

+ (BluetusManager *)sharedManager;
- (void)startScanning;
- (void)stopScanning;


@end
