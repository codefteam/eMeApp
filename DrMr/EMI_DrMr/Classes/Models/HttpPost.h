//
//  HttpPost.h
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/06.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NotConnectingToNetworkCode 999

@interface HttpPost : NSObject

@property (nonatomic) NSURL *url;
@property (nonatomic) NSString *body;

@property (nonatomic, readonly) NSUInteger status_code;
@property (nonatomic, readonly) NSError *request_error;
@property (nonatomic, readonly) NSData *response_data;

- (NSData *)submit;

@end
