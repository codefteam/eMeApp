//
//  PermissionObserver.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/10.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PermissionObserver : NSObject

+ (PermissionObserver *)sharedManager;
- (void)startPermissionObserver;

@end
