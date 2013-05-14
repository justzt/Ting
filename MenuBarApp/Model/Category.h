//
//  Category.h
//  MenuBarApp
//
//  Created by zhang ting on 9/8/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject


@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray  *channelList;
@end
