//
//  Mp3Downloader.m
//  MusicDownloader
//
//  Created by zhang ting on 9/1/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "Mp3Downloader.h"
#import "PreferencesManager.h"

@implementation Mp3Downloader

@synthesize song, delegate;

- (void)dealloc{
    self.delegate = nil;
    SafeRelease(mp3Data);
    self.song = nil;
    [super dealloc];
}


- (ASIHTTPRequest*)downloadMp3Request:(Song*)s{
    self.song = s;
    self.song.mp3DownloadState = Mp3DownloadDoing;
    NSURL *url = [NSURL URLWithString:s.song_location];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setUserAgentString:@"Safari"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(songDownloadFaild:)];
    [request setDidFinishSelector:@selector(songDownloadSuccess:)];
    return request;
}

- (void)songDownloadFaild:(ASIHTTPRequest*)request
{
    self.song.mp3DownloadState = Mp3DownloadFaild;
    DLog(@"mp3 download faild");
    [self.delegate mp3DownloadFinished:NO downloader:self];
}

- (void)songDownloadSuccess:(ASIHTTPRequest*)request
{    
    //save mp3 to DeskTop
    self.song.mp3DownloadState = Mp3DownloadEnd;
    NSData *data = mp3Data;//[request responseData];
    NSString *path = [[PreferencesManager manager] mp3Path];
    NSString *songName = self.song.song_name;
    NSString *tmpPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", songName]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:tmpPath] == YES) {
        tmpPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", [songName stringByAppendingFormat:@"%@", self.song.song_id]]];
        DLogF(@"歌曲重名了...new name:%@", tmpPath);
    }
    path = tmpPath;
    NSError *error = nil;
    BOOL value = [data writeToFile:path options:NSDataWritingAtomic error:&error];
//    value == YES ? DLog(@"ok") : DLogF(@"faild:%@, path:%@", error, path);
    DLogF(@"mp3 download success %@, data size:%ld", path, data.length);
    
    //save cover to DeskTop
    NSString *imgPath = [[LocalFileManager manager] pathForImageFile:self.song.album_logo];
    NSError *imageCopyError = nil;
    path = [path stringByReplacingOccurrencesOfString:@"mp3" withString:@"png"];
    value = [[NSFileManager defaultManager] copyItemAtPath:imgPath toPath:path error:&imageCopyError];
//    value == YES ? DLog(@"ok") : DLogF(@"faild:%@, oldPath:%@, path:%@", imageCopyError, imgPath, path);
    
    [self.delegate mp3DownloadFinished:YES downloader:self];
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    NSLog(@"正确建立下载链接");
    if (fileLength == 0) {
        fileLength = request.contentLength;
        DLogF(@"mp3 大小：%.2lf", fileLength);
        self.song.maxProressValue = fileLength;
    }
}

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
    if (mp3Data == nil) {
        mp3Data = [[NSMutableData data] retain];
    }
    [mp3Data appendData:data];
    currentValue += [data length];
    self.song.currentProgress = currentValue;
}
@end
