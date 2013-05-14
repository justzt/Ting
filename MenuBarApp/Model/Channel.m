//
//  Channel.m
//  MenuBarApp
//
//  Created by zhang ting on 9/8/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "Channel.h"

@implementation Channel

@synthesize artistid, avatar, name, ch_name;

- (void)dealloc{
    self.artistid = nil;
    self.avatar = nil;
    self.name = nil;
    self.ch_name = nil;
    [super dealloc];
}

@end
