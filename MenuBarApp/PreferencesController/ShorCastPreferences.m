//
//  ShorCastPreferences.m
//  MenuBarApp
//
//  Created by zhang ting on 9/9/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "ShorCastPreferences.h"
#import "../Manager/PreferencesManager.h"

@interface ShorCastPreferences ()

@end

@implementation ShorCastPreferences

- (IBAction)useShortCatCheckBoxAction:(id)sender {
    NSButton *button = (NSButton*)sender;
    [[PreferencesManager manager] saveNeedUseShortCat:button.state == NSOnState ? YES : NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserChangedShortCutState object:nil];
}


#pragma mark - live

- (id)init
{
    return [super initWithNibName:@"ShorCastPreferences" bundle:nil];
}

- (void)awakeFromNib{
    // 读取preferences 是否启动快捷键
    [useShortCatCheckBox setState:[[PreferencesManager manager] needUseShortCat]];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"ShorCastPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"热键设置", @"Toolbar item name for the General preference pane");
}
@end
