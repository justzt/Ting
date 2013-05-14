//
//  ShorCastPreferences.h
//  MenuBarApp
//
//  Created by zhang ting on 9/9/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../MASPreferences/MASPreferencesViewController.h"

@interface ShorCastPreferences : NSViewController<MASPreferencesViewController>
{
    IBOutlet NSButton *useShortCatCheckBox;
}
- (IBAction)useShortCatCheckBoxAction:(id)sender;
@end
