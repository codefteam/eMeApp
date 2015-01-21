//
//  MrApprovalTableViewCell.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/09/01.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "MrApprovalTableViewCell.h"

@implementation MrApprovalTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self initalizeView];
	}
	return self;
}

- (void)initalizeView
{
	// Initialization code
	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 80)];

	
	self.areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	self.areaBtn.frame = CGRectMake(30, 0, 25, 80);
	[self.areaBtn setImage:[UIImage imageNamed:@"icon2_1.png"] forState:UIControlStateNormal];
	[self.areaBtn setImage:[UIImage imageNamed:@"icon2_1.png"] forState:UIControlStateDisabled];
	[view addSubview:self.areaBtn];
	
	
	self.calledBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	self.calledBtn.frame = CGRectMake(0, 0, 25, 80);
	[self.calledBtn setImage:[UIImage imageNamed:@"icon2_2.png"] forState:UIControlStateNormal];
	[self.calledBtn setImage:[UIImage imageNamed:@"icon2_2.png"] forState:UIControlStateDisabled];
	[view addSubview:self.calledBtn];
	
	
	self.messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	self.messageBtn.frame = CGRectMake(30+30, 0, 25, 80);
	[self.messageBtn setImage:[UIImage imageNamed:@"icon2_3.png"] forState:UIControlStateNormal];
	[self.messageBtn setImage:[UIImage imageNamed:@"icon2_3.png"] forState:UIControlStateDisabled];
	[view addSubview:self.messageBtn];
	
	self.accessoryView = view;
	

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
