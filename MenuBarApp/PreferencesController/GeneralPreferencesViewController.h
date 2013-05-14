//
//  GeneralPreferencesViewController.h
//  MenuBarApp
//
//  Created by zhang ting on 9/7/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../MASPreferences/MASPreferencesViewController.h"

@interface GeneralPreferencesViewController : NSViewController <MASPreferencesViewController>
{
    IBOutlet NSButton *needNotificationCheckBox;
    IBOutlet NSButton *needLrcCheckBox;
    IBOutlet NSButton *rememberChannelCheckBox;
    IBOutlet NSTextField *saveToPathFeild;
}

- (IBAction)needNotificationCheckBoxAction:(id)sender;
- (IBAction)pathButtonAction:(id)sender;
- (IBAction)needLrcButtonAction:(id)sender;
- (IBAction)remenberChannelButtonAction:(id)sender;

@end
