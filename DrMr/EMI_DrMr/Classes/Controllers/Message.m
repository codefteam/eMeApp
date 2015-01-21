//
//  Message.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/09/03.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "Message.h"

@implementation Message
@synthesize attributes,text,date,fromMe,media,thumbnail,type;

- (id)init
{
	if (self = [super init]) {
		self.date = [NSDate date];
	}
	
	return self;
}

@end
