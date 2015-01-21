//
//  ButtonFactory.m
//  EMI_DrMr
//
//  Created by Esukei Company on 2014/10/07.
//  Copyright (c) 2014年 ESUKEI Co.,Ltd. All rights reserved.
//

#import "ButtonFactory.h"

@implementation ButtonFactory

/**
 *  院内外ステートを表示・切り替えボタンを作成
 *
 *  @return UIButton
 */
+ (UIButton *)defaultAreaButton
{
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//	btn.frame = CGRectMake(0.f, 0.f, 106.f, 50.f);
	btn.frame = CGRectMake((106.f+1.f)*2, 0.f, 106.f, 50.f);
	btn.backgroundColor = RGB(230, 230, 230);
	[btn setTitle:@"院外" forState:UIControlStateNormal];
	[btn setTitleColor:RGB(247, 141, 101) forState:UIControlStateNormal];
	btn.enabled = YES;
	
	return btn;
}

/**
 *  連絡可否ステートを表示・切り替えボタンを作成
 *
 *  @return UIButton
 */
+ (UIButton *)defaultRenrakuButton
{
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = CGRectMake(106.f+1.f, 0.f, 106.f, 50.f);
	btn.backgroundColor = RGB(230, 230, 230);
	btn.showsTouchWhenHighlighted = YES;
	btn.exclusiveTouch = YES;
	[btn setTitle:@"連絡可" forState:UIControlStateNormal];
	[btn setTitleColor:RGB(247, 141, 101) forState:UIControlStateNormal];
	[btn setTitleColor:RGB(170, 0, 0) forState:UIControlStateHighlighted];

	
	return btn;
}

/**
 *  通知ボタンを作成
 *
 *  @return UIButton
 */
+ (UIButton *)defaultTuchiButton
{
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//	btn.frame = CGRectMake((106.f+1.f)*2, 0.f, 106.f, 50.f);
	btn.frame = CGRectMake(0.f, 0.f, 106.f, 50.f);
	btn.backgroundColor = RGB(230, 230, 230);
	btn.showsTouchWhenHighlighted = YES;
	btn.exclusiveTouch = YES;
	[btn setTitle:@"通知" forState:UIControlStateNormal];
	[btn setTitleColor:RGB(247, 141, 101) forState:UIControlStateNormal];
	[btn setTitleColor:RGB(170, 0, 0) forState:UIControlStateHighlighted];

	
	return btn;
}


@end
