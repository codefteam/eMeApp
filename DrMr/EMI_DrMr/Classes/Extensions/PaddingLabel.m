//
//  PaddingLabel.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/07/25.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "PaddingLabel.h"

@implementation PaddingLabel

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self) {
	
	}
	
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	// Drawing code
}
*/


- (void)drawTextInRect:(CGRect)rect
{
	// top, left, bottom, right
	UIEdgeInsets insets = {5, 10, 5, 10};
	return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
