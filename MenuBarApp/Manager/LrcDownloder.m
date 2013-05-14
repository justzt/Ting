//
//  LrcDownloder.m
//  MenuBarApp
//
//  Created by zhang ting on 9/9/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "LrcDownloder.h"
#import "PreferencesManager.h"
#import "../Utility/NSString+UrlEncoding.h"

@implementation LrcDownloder

@synthesize delegate, song;

- (void)dealloc
{
    self.delegate = nil;
    self.song = nil;
    [super dealloc];
}

- (void)downloadLrcWith:(Song*)s{
    self.song = s;
    ASIHTTPRequest *requst = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.song.song_lrc]];
    requst.delegate = self;
    DLogF(@"start download lrc:%@", s.song_lrc);
    [requst setDidFailSelector:@selector(lrcDownloadFaild)];
    [requst setDidFinishSelector:@selector(lrcDownloadSuccess:)];
    [requst startAsynchronous];
}

#pragma mark - DownloadManagerDelegate
- (void)lrcDownloadFaild{
    [self.delegate lrcDidDownload:@"\n歌词未找到" lrcDownloader:self];
}

- (void)lrcDownloadSuccess:(ASIHTTPRequest*)requst{
    NSData *data = [requst responseData];
    
    NSString *lrcUtf8 = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    self.song.lrc = data;
    [self.delegate lrcDidDownload:lrcUtf8 lrcDownloader:self];
}
@end
