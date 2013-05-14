//
//  fuckViewController.m
//  MenuBarApp
//
//  Created by zhang ting on 9/9/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "fuckViewController.h"

@interface fuckViewController ()

@end

@implementation fuckViewController

- (id)init
{
    return [super initWithNibName:@"fuckViewController" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"fuckPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameInfo];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"关于", @"Toolbar item name for the General preference pane");
}

@end
