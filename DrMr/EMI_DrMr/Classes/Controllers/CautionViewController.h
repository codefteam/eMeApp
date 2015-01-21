//
//  CautionViewController.h
//  EMI_Pt
//
//  Created by Esukei Company on 2014/09/11.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CautionViewControllerDelegate;
@interface CautionViewController : UIViewController


@property id<CautionViewControllerDelegate> delegate;

- (void)refreshState;

@end

@protocol CautionViewControllerDelegate <NSObject>;

- (void)dismissCautionViewController:(CautionViewController *)cautionViewController;

@end