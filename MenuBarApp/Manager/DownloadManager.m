//
//  DownloadManager.m
//  MusicDownloader
//
//  Created by zhang ting on 7/20/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "DownloadManager.h"
#import "../Vender/Json/NXJsonParser.h"

@implementation DownloadManager

@synthesize request, delegate;


- (void)cancelDownload{
    if (self.request != nil) {
        [self.request clearDelegatesAndCancel];
    }
}

- (void)startRequestWithRequest:(NSString*)strUrl async:(BOOL)async{
    NSURL* url = [NSURL URLWithString:strUrl];
    self.request = [ASIHTTPRequest requestWithURL:url];
    self.request.delegate = self;
    [self.request setDidFailSelector:@selector(requestFailed:)];
    [self.request setDidFinishSelector:@selector(requestFinished:)];
    if (async == YES) {
        [self.request startAsynchronous];
    }else{
        [self.request startSynchronous];
    }
}
- (void)startRequestWithRequest:(NSString*)strUrl{
    [self startRequestWithRequest:strUrl async:YES];
}

- (void)requestFailed:(ASIHTTPRequest*)aRequest{
    DLogF(@"failed:%@", aRequest);
    [self.delegate downloadFaild];
}

- (void)requestFinished:(ASIHTTPRequest*)aRequest{
    NSLog(@"seccess");
    NSData* data = [aRequest responseData];
    NXJsonParser* parser = [[[NXJsonParser alloc] initWithData:data] autorelease];
    id result = [parser parse:nil ignoreNulls:YES];
    if (result != nil ) {
        [self.delegate downloadSuccess:result];
    }else{
        [self.delegate downloadFaild];
    }
}

@end
