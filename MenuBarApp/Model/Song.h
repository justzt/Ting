//
//  Song.h
//  BDMusicDownloader
//
//  Created by zhang ting on 7/18/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject
{
    NSString* album_id;
    NSString* album_logo;
    NSString* album_name;
    NSString* artist_id;
    NSString* artist_logo;
    NSString* artist_name;
    NSString* song_id;
    NSString* song_level;
    NSString* song_location;
    NSString* song_logo;
    NSString* song_lrc;//歌词url
    NSData * lrc;//歌词
    NSString* song_name;
    NSImage* imge;
    CGFloat currentProgress;
    CGFloat maxProressValue;
    CGFloat duration;
    SearchEngine engine;
    AlbumCoverDownloadState albumLogoDidDownload;
    Mp3DownloadState mp3DownloadState;
}
@property (copy) NSString* album_id;
@property (copy) NSString* album_logo;
@property (copy) NSString* album_name;
@property (copy) NSString* artist_id;
@property (copy) NSString* artist_logo;
@property (copy) NSString* artist_name;
@property (copy) NSString* song_id;
@property (copy) NSString* song_level;
@property (copy) NSString* song_location;
@property (copy) NSString* song_logo;
@property (copy) NSString* song_lrc;
@property (retain) NSData* lrc;//歌词
@property (copy) NSString* song_name;
@property (nonatomic, retain)    NSImage* imge;
@property CGFloat currentProgress;
@property CGFloat maxProressValue;
@property    SearchEngine engine;
@property    CGFloat duration;
@property    AlbumCoverDownloadState albumLogoDidDownload;
@property    Mp3DownloadState mp3DownloadState;
@end
