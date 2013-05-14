//
//  ImageDownloader.m
//  MusicDownloader
//
//  Created by zhang ting on 8/31/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "ImageDownloader.h"
#import "LocalFileManager.h"

#define kImageUrlArray @"kImageUrlArray" 

@implementation ImageDownloader

@synthesize song, dm, delegate;

- (void)dealloc{
    self.song = nil;
    
    [self.dm clearDelegatesAndCancel];
    self.dm = nil;
    
    self.delegate = nil;
    [super dealloc];
}

+(NSMutableArray*)imageUrls{
    NSMutableArray *array = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:kImageUrlArray];
    if(array == nil){
        array = [NSMutableArray array];
    }
    return array;
}

+(void)saveIamgeUrl:(NSString*)url{
    NSString *hash = FormatStr(@"%ld",[url hash]);
    NSMutableArray *array = [ImageDownloader imageUrls];
    [array addObject:hash];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:kImageUrlArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)downloadImageWithSong:(Song*)s rowIndex:(int)index{
    rowIndex = index;
    self.song = s;
    self.song.albumLogoDidDownload = CoverDownloadDoing;
    if (self.dm) {
        [self.dm clearDelegatesAndCancel];
        self.dm = nil;
    }
    self.dm = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.song.album_logo]];
    self.dm.delegate = self;
    [self.dm setDidFailSelector:@selector(downloadFaild)];
    [self.dm setDidFinishSelector:@selector(downloadSuccess:)];
    [self.dm startAsynchronous];
}

#pragma mark -  DownloadManagerDelegate
- (void)downloadFaild{
    DLog(@"img download faild");
    self.song.albumLogoDidDownload = CoverDownloadEnd;
    if([self.delegate respondsToSelector:@selector(imageDidDownload:downloader: rowIndex:)]){
        [self.delegate imageDidDownload:nil downloader:self rowIndex:rowIndex];
    }
}

- (void)downloadSuccess:(id)result{
    NSData *data = [((ASIHTTPRequest*) result) responseData];
    self.song.albumLogoDidDownload = CoverDownloadEnd;
   NSImage *image = [[NSImage alloc] initWithData:data];
    
    if([self.delegate respondsToSelector:@selector(imageDidDownload:downloader: rowIndex:)]){
        [self.delegate imageDidDownload:image downloader:self rowIndex:rowIndex];
    }
    [image release];
}
@end