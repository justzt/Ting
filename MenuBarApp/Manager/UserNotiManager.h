//
//  UserNotiManager.h
//  MenuBarApp
//
//  Created by zhang ting on 9/10/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserNotiManager : NSObject<NSUserNotificationCenterDelegate>


+(UserNotiManager*)manager;
- (void)postUserNotificationWithTitle:(NSString*)title subTitle:(NSString*)subTitle infoText:(NSString*)text;
@end
