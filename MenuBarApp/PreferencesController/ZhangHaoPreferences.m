//
//  ZhangHaoPreferences.m
//  MenuBarApp
//
//  Created by zhang ting on 9/11/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "ZhangHaoPreferences.h"

@interface ZhangHaoPreferences ()

@end

@implementation ZhangHaoPreferences


- (id)init
{
    return [super initWithNibName:@"ZhangHaoPreferences" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"ZhangHaoPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameUserAccounts];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"账号设置", @"Toolbar item name for the General preference pane");
}


@end
