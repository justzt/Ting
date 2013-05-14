//
//  AppDelegate.h
//  MenuBarApp
//
//  Created by zhang ting on 9/7/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferences/MASPreferencesWindowController.h"
#import "Manager/DownloadManager.h"
#import "Model/Channel.h"
#import "View/ControlViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, DownloadManagerDelegate>
{
    ControlViewController *mainVC;
    NSStatusItem *statusItem;
    MASPreferencesWindowController *preferencesWindow;
    NSMutableArray *privateChannelItemArray;
    NSMutableArray *pubChannelItemArray;
    NSMutableArray *artChannelItemArray;
    NSMenuItem *previousMenuItem;
    NSMenuItem *previousCategoryMenuItem;
}
@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) NSMutableArray *cateCoaryArray;
@property (nonatomic, retain) NSMenu *menu;

- (IBAction)doSomthing:(id)sender;
@end
