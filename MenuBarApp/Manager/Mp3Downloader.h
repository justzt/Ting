//
//  Mp3Downloader.h
//  MusicDownloader
//
//  Created by zhang ting on 9/1/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Vender/Asi-http/ASIHTTPRequest.h"
#import "../Model/Song.h"
#import "LocalFileManager.h"

@protocol Mp3DownloaderDelegate <NSObject>

@required
- (void)mp3DownloadFinished:(BOOL)success downloader:(id)obj;

@end

@interface Mp3Downloader : NSObject<ASIHTTPRequestDelegate, ASIProgressDelegate>
{
    CGFloat currentValue;
    CGFloat fileLength;
    NSMutableData *mp3Data;
}

@property (retain , nonatomic) Song *song;
@property (nonatomic, assign) id<Mp3DownloaderDelegate> delegate;

- (ASIHTTPRequest*)downloadMp3Request:(Song*)s;
@end
