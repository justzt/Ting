//
//  DownloadManager.h
//  MusicDownloader
//
//  Created by zhang ting on 7/20/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Vender/Asi-http/ASIHTTPRequest.h"

@protocol DownloadManagerDelegate <NSObject>

@required
- (void)downloadFaild;
- (void)downloadSuccess:(id)result;

@end

@interface DownloadManager : NSObject
{
}
@property (retain, nonatomic) ASIHTTPRequest* request;
@property (assign) id<DownloadManagerDelegate> delegate;

- (void)cancelDownload;
- (void)startRequestWithRequest:(NSString*)strUrl;
- (void)startRequestWithRequest:(NSString*)strUrl async:(BOOL)noAsync;
@end

