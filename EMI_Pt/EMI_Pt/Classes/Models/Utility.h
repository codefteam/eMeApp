//
//  Utility.h
//  EMI_Pt
//
//  Created by esukei on 2014/08/27.
//  Copyright (c) 2014年 EMI_Pt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (void)setupAppTheme;
+ (void)showMessage:(NSString*)title message:(NSString*)message;

+ (NSMutableArray *)sortArray:(NSMutableArray*)array withKey:(NSString*)key ascending:(BOOL)yesno;


@end
