//
//  LrcDownloder.h
//  MenuBarApp
//
//  Created by zhang ting on 9/9/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Model/Song.h"
#import "../Vender/Asi-http/ASIHTTPRequest.h"


@protocol LrcDownloderDelegate <NSObject>

- (void)lrcDidDownload:(NSString*)lrc lrcDownloader:(id)obje;

@end

@interface LrcDownloder : NSObject
{
}

@property (nonatomic, retain) Song *song;
@property (assign) id<LrcDownloderDelegate> delegate;

- (void)downloadLrcWith:(Song*)song;
@end
