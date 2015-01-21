//
//  NoticeTableViewCell.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/24.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "NoticeTableViewCell.h"

@implementation NoticeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {

	}
	return self;
}

- (void)awakeFromNib
{
	// Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.imageView.frame = CGRectMake(5.0, 18.0, 44.0, 44.0);
	float limgW =  self.imageView.image.size.width;
	
	if(limgW > 0) {
		self.textLabel.frame = CGRectMake(55,self.textLabel.frame.origin.y,150.0,self.textLabel.frame.size.height);
		self.detailTextLabel.frame = CGRectMake(55,self.detailTextLabel.frame.origin.y,150.0,self.detailTextLabel.frame.size.height);
	}
}

@end
