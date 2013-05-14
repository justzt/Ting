//
//  UserNotiManager.m
//  MenuBarApp
//
//  Created by zhang ting on 9/10/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "UserNotiManager.h"
#import "../AppDelegate.h"
#import "PreferencesManager.h"

static UserNotiManager *manager = nil;

@implementation UserNotiManager

+(UserNotiManager*)manager{
    if (manager == nil) {
        manager = [[UserNotiManager alloc] init];
    }
    return  manager;
}

- (id)init{
    if (manager == nil) {
        manager = [super init];
        [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    }
    return manager;
}

- (void)postUserNotificationWithTitle:(NSString*)title subTitle:(NSString*)subTitle infoText:(NSString*)text{
    if([[PreferencesManager manager] needNotification] == NO){
        return;
    }
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = title;
    notification.subtitle = subTitle;
    notification.informativeText = text;
//    notification.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

@end
