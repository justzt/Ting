//
//  ImageDownloader.h
//  MusicDownloader
//
//  Created by zhang ting on 8/31/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Vender/Asi-http/ASIHTTPRequest.h"
#import "../Model/Song.h"

@protocol ImageDownloaderDelegate <NSObject>

@required
-  (void)imageDidDownload:(NSImage*)image downloader:(id)downloder rowIndex:(int)rowIndex;
@end

@interface ImageDownloader : NSObject
{
    int rowIndex;
}
@property (nonatomic, retain) Song *song;
@property (nonatomic, retain) ASIHTTPRequest *dm;
@property (assign) id<ImageDownloaderDelegate> delegate;

- (void)downloadImageWithSong:(Song*)s rowIndex:(int)index;
@end
