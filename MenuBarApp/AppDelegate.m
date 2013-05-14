//
//  AppDelegate.m
//  MenuBarApp
//
//  Created by zhang ting on 9/7/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "PreferencesController/GeneralPreferencesViewController.h"
#import "Utility/api.h"
#import "Model/Category.h"
#import "PreferencesController/fuckViewController.h"
#import "PreferencesController/ShorCastPreferences.h"
#import "../MenuBarApp/Manager/PreferencesManager.h"
#import "Vender/Global-hotkey/SPMediaKeyTap.h"
#import "PreferencesController/ZhangHaoPreferences.h"

#define kPrivateMenuItemTag 10000


@implementation AppDelegate

@synthesize cateCoaryArray,menu;

- (void)dealloc
{
    SafeRelease(privateChannelItemArray);
    SafeRelease(pubChannelItemArray);
    SafeRelease(artChannelItemArray);
    SafeRelease(mainVC);
    SafeRelease(statusItem);
    self.cateCoaryArray = nil;
    self.menu = nil;
    [super dealloc];
}

- (IBAction)doSomthing:(id)sender {
    NSLog(@"...");
}

- (void)channelItemAction:(NSMenuItem*)menuItem{
    NSMenuItem *currentCatregroyMenuItem =[menuItem parentItem];
    
    if (previousMenuItem != menuItem) {
        if (previousMenuItem != nil) {
            [previousMenuItem setState:NSOffState];
            [previousCategoryMenuItem setState:NSOffState];
        }
        [menuItem setState:NSOnState];
        [currentCatregroyMenuItem setState:NSMixedState];
        previousMenuItem = menuItem;
        previousCategoryMenuItem = currentCatregroyMenuItem;
        
        [[menuItem parentItem] setState:NSMixedState];
        long categoryTag = ((NSMenuItem*)([menuItem parentItem])).tag;
        DLogF(@"%@, tag:%ld, cateId:%ld", menuItem.title, menuItem.tag, categoryTag);
        
        NSString *channelName = nil;
        NSString * cid = @"1";
        
        //获取用户选择的频道
        Channel *channel;
        for (Category *category in self.cateCoaryArray) {
            if (category.cid.longLongValue == categoryTag) {
                channel = [category.channelList objectAtIndex:menuItem.tag];
                DLogF(@"类别：%@, 频道:%@, artistId:%@", category.title, channel.ch_name, channel.artistid);
                cid = FormatStr(@"%ld", categoryTag);
                channelName = channel.ch_name;
                break;
            }
        }
        
        // cid == 1 公共频道； cid==3 艺人pind
        NSString *strItemIndex = FormatStr(@"%ld", menuItem.tag);
        if ([cid isEqualToString:@"0"]){
            if (menuItem.tag == 0) {
                [mainVC downloadSongListWithUrlString:@"redStar"];
            }else{
                [mainVC downloadSongListWithUrlString:@"privateChannel"];
            }

        }else
        if ([cid isEqualToString:@"1"]) {
            [mainVC downloadSongListWithUrlString:API_channel_pub_song_list(cid, channelName)];
        }else{
            [mainVC downloadSongListWithUrlString:API_channel_artist_song_list(channel.artistid)];
        }
        
        [self saveCurrentChannelToPreference:cid item:strItemIndex];
    }
}

- (void)defaultPlayChannel{
    // 从pereferences中读取上次电台记录
    NSString *channelId = @"1";
    long item = 0;
    if ([[PreferencesManager manager] needRememberChannel] == YES) {
        NSDictionary *dic = [[PreferencesManager manager] channelInfo];
        if (dic != nil) {
            channelId = [dic objectForKey:@"cid"];
            NSString *strItem = [dic objectForKey:@"item"];
            item = strItem.longLongValue;
        }
    }
    
    //
    if (channelId.longLongValue == 0){
        [self channelItemAction:[privateChannelItemArray objectAtIndex:item]];
    }else
    if (channelId.longLongValue == 1) {
        [self channelItemAction:[pubChannelItemArray objectAtIndex:item]];
    }else{
        [self channelItemAction:[artChannelItemArray objectAtIndex:item]];
    }
    
}

// 保存当前频道
- (void)saveCurrentChannelToPreference:(NSString*)cid item:(NSString*)item{
    if ([[PreferencesManager manager] needRememberChannel] == YES) {
        DLogF(@"cid:%@ item:%@", cid, item);
        [[PreferencesManager manager] saveChanneCid:cid item:item];
    }
    
}

- (void)quit{
    [NSApp terminate:nil];
}

- (void)preferences{
    //will show preferences window
    NSLog(@"will show preferences window");
    
    if (preferencesWindow == nil) {
        NSViewController *generalViewController = [[[GeneralPreferencesViewController alloc] init] autorelease];
        NSViewController *shorCastViewController = [[[ShorCastPreferences alloc] init] autorelease];
        NSViewController *advancedViewController = [[[fuckViewController alloc] init] autorelease];
        NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController, shorCastViewController,[NSNull null], advancedViewController, nil];
                
        NSString *title = NSLocalizedString(@"偏好设置", @"Common title for Preferences window");
        preferencesWindow = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
        [controllers release];
    }
    [preferencesWindow showWindow:nil];
}


// 类别中增加频道
- (void)addChannelList:(NSArray*)channelList toMenu:(NSMenuItem *)menuitem{
    NSMenu *artistChannelMenu = [[[NSMenu alloc] initWithTitle:menuitem.title] autorelease];
    [menuitem setSubmenu:artistChannelMenu];
    
    int index = 0;
    for (Channel *channel in channelList) {
        NSMenuItem *item = [[[NSMenuItem alloc] initWithTitle:channel.name action:@selector(channelItemAction:) keyEquivalent:@""] autorelease];
        item.tag = index;
        [artistChannelMenu addItem:item];
        if (menuitem.tag == 0) {
            [privateChannelItemArray addObject:item];
        }else
        if (menuitem.tag == 1) {
            [pubChannelItemArray addObject:item];
        }else{
            [artChannelItemArray addObject:item];
        }
        index++;
    }
}

// 主菜单加入电台类别
- (void)addChannelWithCategory:(Category*)category{
    NSMenuItem *pubChannel = [[NSMenuItem alloc] initWithTitle:FormatStr(@"\t%@", category.title) action:@selector(channelItemAction:) keyEquivalent:@""];
    pubChannel.tag = category.cid.intValue;
    DLog(category.cid);
    [menu addItem:pubChannel];
    [self addChannelList:category.channelList toMenu:pubChannel];
    [pubChannel release];
}

#pragma mark - life 
- (void)awakeFromNib{
    self.cateCoaryArray = [NSMutableArray array];
    privateChannelItemArray = [[NSMutableArray array] retain];
    pubChannelItemArray = [[NSMutableArray array] retain];
    artChannelItemArray = [[NSMutableArray array] retain];
    
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    
    mainVC = [[ControlViewController alloc] init];
    //主要（播放 控制）item
    NSMenuItem *item = [[[NSMenuItem alloc] init] autorelease];
    [item setView:mainVC.view];
    
    self.menu = [[[NSMenu alloc] initWithTitle:@"M"] autorelease];
    [menu addItem:item];

    //分割线
    [menu addItem:[NSMenuItem separatorItem]];
    
    
    // 获取电台列表
    DownloadManager *dm = [[[DownloadManager alloc] init] autorelease];
    dm.delegate = self;
    [dm startRequestWithRequest:API_radio_list async:NO];
    
    //分割线
    [menu addItem:[NSMenuItem separatorItem]];
    
    //偏好设置
    NSMenuItem *preferencesItem = [[[NSMenuItem alloc] initWithTitle:@"Preferences" action:@selector(preferences) keyEquivalent:@","] autorelease];
    [menu addItem:preferencesItem];
    
    //退出
    NSMenuItem *quitItem = [[[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quit) keyEquivalent:@"q"] autorelease];
    [menu addItem:quitItem];
    
    [statusItem setImage:[NSImage imageNamed:@"statusIcon"]];
    [statusItem setAlternateImage:[NSImage imageNamed:@"statusIcon"]];
    [statusItem setHighlightMode:YES];
    [statusItem setMenu:menu];
}

#pragma mark - DownloadManagerDelegate
- (void)downloadFaild{

}

- (void)downloadSuccess:(id)result{
    NSDictionary *dic = (NSDictionary*)result;
    NSString *errorCode = dicValueForKey(dic, @"error_code");
    if (errorCode.intValue == 22000) {
        //search success
        NSArray *resultArray = dicValueForKey(dic, @"result");
        for (NSDictionary *cat in resultArray) {
            //大分类:公共频道，音乐人频道
            Category *category = [[Category alloc] init];
            category.cid = dicValueForKey(cat, @"cid");
            category.title = dicValueForKey(cat, @"title");
            NSArray *channelList = dicValueForKey(cat, @"channellist");
            if (channelList != nil && [channelList count]>0) {
                NSMutableArray *channelArray = [NSMutableArray array];
                //分类中的所有频道
                for (NSDictionary *cha in channelList) {
                    if (cha != nil) {
                        Channel *channel = [[Channel alloc] init];
                        channel.artistid = dicValueForKey(cha, @"artistid");
                        channel.avatar = dicValueForKey(cha, @"avatar");
                        channel.name = dicValueForKey(cha, @"name");
                        channel.ch_name = dicValueForKey(cha, @"ch_name");
                        DLogF(@"title:%@, %@, channelid:%@", channel.name, channel.ch_name, channel.artistid);
                        [channelArray addObject:channel];
                        [channel release];
                    }
                }
                category.channelList = (NSArray*)channelArray;
            }
            [self.cateCoaryArray addObject:category];
            [category release];
        }

        for (Category *cate in self.cateCoaryArray) {
            [self addChannelWithCategory:cate];
        }
        //启动默认播放频道
        [self defaultPlayChannel];
    }else{
        //search faild
        [self downloadFaild];
    }
}

@end
