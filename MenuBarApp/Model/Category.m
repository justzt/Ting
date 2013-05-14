//
//  Category.m
//  MenuBarApp
//
//  Created by zhang ting on 9/8/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "Category.h"

@implementation Category

@synthesize cid, title, channelList;

- (void)dealloc{
    self.cid = nil;
    self.title = nil;
    self.channelList = nil;
    [super dealloc];
}
@end
