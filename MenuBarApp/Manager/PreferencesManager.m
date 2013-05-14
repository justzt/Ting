//
//  PreferencesManager.m
//  MenuBarApp
//
//  Created by zhang ting on 9/9/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "PreferencesManager.h"
#import "LocalFileManager.h"

@implementation PreferencesManager

#define kFirstUse @"kFirstUse"
#define kShowLrcState @"lrcState"
#define kNeedDownloadLrc @"kNeedDownloadLrc"
#define kNeedRememberChannelState @"needRememberChannelState"
#define kMp3SaveToPath @"kMp3SaveToPath"
#define kChannelCid @"kChannelCid"
#define kChannellItem @"kChannelChannelItem"
#define kNeedUseShortCat @"kNeedUseShortCat"
#define kNeedNotification @"kNeedNotification"


static PreferencesManager *manager = nil;

+(id)manager{
    if (manager == nil) {
        manager = [[PreferencesManager alloc] init];
    }
    return manager;
}

- (id)init{
    if (manager == nil) {
        if ([self isFirstUseApp] == YES) {
            [self defaultPreferences];
        }
        manager = [super init];
    }
    return manager;
}

-(void)defaultPreferences{
    // 默认启用消息中心
    [self saveNeedNotificationState:YES];
    // 默认不下载歌词
    [self saveNeedDownloadLrcSate:NO];
    // 默认记录频道
    [self saveNeedDownloadLrcSate:NO];
    // 默认下载到桌面
    NSString *path = [[LocalFileManager manager] defaultMp3SaveToPath];
    [self saveMp3Path:path];
    // 默认开启快捷键
    [self saveNeedUseShortCat:YES];
}

-(BOOL)isFirstUseApp{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *firstUse = [ud objectForKey:kFirstUse];
    DLog(firstUse);
    if (firstUse == nil) {
        [ud setObject:kFirstUse forKey:kFirstUse];
        [ud synchronize];
        return YES;
    }else{
        return NO;
    }
}

- (NSUserDefaults*)UD{
    if ([self isFirstUseApp] == YES) {
        [self defaultPreferences];
    }
    return [NSUserDefaults standardUserDefaults];
}

- (void)syncUD{
    [[self UD] synchronize];
}




-(BOOL)needDownloadLrc{
    BOOL value = [[self UD] boolForKey:kNeedDownloadLrc];
    return value;
}

-(void)saveNeedDownloadLrcSate:(BOOL)state{
    [[self UD] setBool:state forKey:kNeedDownloadLrc];
    [self syncUD];
}




-(BOOL)needRememberChannel{
    BOOL value = [[self UD] boolForKey:kNeedRememberChannelState];
    return value;
}

-(void)saveNeedRememberChannelState:(BOOL)state{
    [[self UD] setBool:state forKey:kNeedRememberChannelState];
    [self syncUD];
}




-(NSString*)mp3Path{
    NSString *path = (NSString*)[[self UD] objectForKey:kMp3SaveToPath];
    return path;
}

-(void)saveMp3Path:(NSString*)path{
    [[self UD] setObject:path forKey:kMp3SaveToPath];
    [self syncUD];
}




-(NSDictionary*)channelInfo{
    NSObject *cid = [[self UD] objectForKey:kChannelCid];
    NSString *item = [[self UD] objectForKey:kChannellItem];
    NSDictionary *dic = @{@"cid":cid, @"item":item};
    return dic;
}

- (void)saveChanneCid:(NSString*)cid item:(NSString*)item{
    [[self UD] setObject:cid forKey:kChannelCid];
    [[self UD] setObject:item forKey:kChannellItem];
    [self syncUD];
}


- (BOOL)needUseShortCat{
    return [[self UD] boolForKey:kNeedUseShortCat];
}

- (void)saveNeedUseShortCat:(BOOL)value{
    [[self UD] setBool:value forKey:kNeedUseShortCat];
    [self syncUD];
}


- (BOOL)needNotification{
    return [[self UD] boolForKey:kNeedNotification];
}

- (void)saveNeedNotificationState:(BOOL)state{
    [[self UD] setBool:state forKey:kNeedNotification];
    [self syncUD];
}
@end
