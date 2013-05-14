//
//  NSString+UrlEncoding.h
//  MusicDownloader
//
//  Created by zhang ting on 7/26/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UrlEncoding)
- (NSString *)urlencode;
- (NSString*)replaceSpaseWithUrlEncode;
- (NSString*)removeEmTag;
- (NSString *)lrcCleaner;
@end
