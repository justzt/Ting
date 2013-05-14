//
//  GeneralPreferencesViewController.m
//  MenuBarApp
//
//  Created by zhang ting on 9/7/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "GeneralPreferencesViewController.h"
#import "../Manager/PreferencesManager.h"

@interface GeneralPreferencesViewController ()

@end

@implementation GeneralPreferencesViewController
- (id)init
{
    return [super initWithNibName:@"GeneralPreferencesViewController" bundle:nil];
}

- (void)awakeFromNib{
    //是否启用消息中心
    BOOL needNotification = [[PreferencesManager manager] needNotification];
    [needNotificationCheckBox setState:needNotification == YES ? NSOnState : NSOffState];
    
    //是否下载歌词
    BOOL needLrc = [[PreferencesManager manager] needDownloadLrc];
    [needLrcCheckBox setState:needLrc== YES ? NSOnState : NSOffState];
    
    //是否记录上次频道
    BOOL needRememberChannel = [[PreferencesManager manager] needRememberChannel];
    [rememberChannelCheckBox setState:needRememberChannel == YES ? NSOnState : NSOffState];
    
    //mp3 下载到路径
    saveToPathFeild.stringValue = [[PreferencesManager manager] mp3Path];
}


#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
    //[NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"基本设置", @"Toolbar item name for the General preference pane");
}

- (IBAction)needNotificationCheckBoxAction:(id)sender {
    NSButton *button = (NSButton*)sender;
    [[PreferencesManager manager] saveNeedNotificationState:button.state == NSOnState ? YES : NO];
}

- (IBAction)pathButtonAction:(id)sender {

    int i; // Loop counter.
    
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:NO];
    
    // Enable the selection of directories in the dialog.
    [openDlg setCanChooseDirectories:YES];
    
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ( [openDlg runModal] == NSOKButton )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* files = [openDlg filenames];
        
        // Loop through all the files and process them.
        for( i = 0; i < [files count]; i++ )
        { 
            NSString* fileName = [files objectAtIndex:i];
            DLog(fileName); 
            saveToPathFeild.stringValue = fileName;
            [[PreferencesManager manager] saveMp3Path:fileName];
            // Do something with the filename. 
        } 
    } 
}

- (IBAction)needLrcButtonAction:(id)sender {
    NSButton *button = (NSButton*)sender;
    [[PreferencesManager manager] saveNeedDownloadLrcSate:button.state == NSOnState ? YES : NO];
}

- (IBAction)remenberChannelButtonAction:(id)sender {
    NSButton *button = (NSButton*)sender;
    [[PreferencesManager manager] saveNeedRememberChannelState:button.state == NSOnState ? YES : NO];
}
@end
