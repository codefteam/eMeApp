//
//  StateObserver.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/15.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateObserver : NSObject

+ (StateObserver *)sharedManager;
- (void)startStateObserver;

@end
