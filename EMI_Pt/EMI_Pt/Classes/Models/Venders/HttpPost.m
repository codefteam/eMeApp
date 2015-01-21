//
//  HttpPost.m
//  EMI_Pt
//
//  Created by esukei on 2014/10/28.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import "HttpPost.h"
#import "Reachability.h"

@implementation HttpPost

- (NSData *)submit
{
	
	_response_data = nil;
	
	//ネットワーク使用可否チェック
	Reachability *reachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus status = [reachability currentReachabilityStatus];
	if (NotReachable == status) {
		_status_code = NotConnectingToNetworkCode;
		return nil;
	}
	
	NSMutableData *post_data = [NSMutableData dataWithLength:0];
	
	
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:self.url
													   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
												   timeoutInterval:90];
	
	req.HTTPMethod = @"POST";
	
	[post_data appendData:[self.body dataUsingEncoding:NSUTF8StringEncoding]];
	[req setHTTPBody:post_data];
	
	//サーバーリクエスト
	NSHTTPURLResponse *response;
	NSError *request_error;
	
	NSData *response_data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&request_error];
	
	//成功時
	if (NULL == request_error) {
		_response_data = response_data;
	}
	
	return _response_data;
}

@end
