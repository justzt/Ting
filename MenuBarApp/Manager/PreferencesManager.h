//
//  PreferencesManager.h
//  MenuBarApp
//
//  Created by zhang ting on 9/9/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreferencesManager : NSObject

+(id)manager;

-(BOOL)needDownloadLrc;
-(void)saveNeedDownloadLrcSate:(BOOL)state;

-(BOOL)needRememberChannel;
-(void)saveNeedRememberChannelState:(BOOL)state;

-(NSString*)mp3Path;
-(void)saveMp3Path:(NSString*)path;

-(BOOL)isFirstUseApp;

-(NSDictionary*)channelInfo;
- (void)saveChanneCid:(NSString*)cid item:(NSString*)item;

- (BOOL)needUseShortCat;
- (void)saveNeedUseShortCat:(BOOL)value;

- (BOOL)needNotification;
- (void)saveNeedNotificationState:(BOOL)state;
@end
