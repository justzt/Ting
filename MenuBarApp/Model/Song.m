//
//  Song.m
//  BDMusicDownloader
//
//  Created by zhang ting on 7/18/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "Song.h"

@implementation Song
@synthesize album_id;
@synthesize album_logo;
@synthesize album_name;
@synthesize artist_id;
@synthesize artist_logo;
@synthesize artist_name;
@synthesize song_id;
@synthesize song_level;
@synthesize song_location;
@synthesize song_logo;
@synthesize song_lrc;
@synthesize lrc;
@synthesize song_name;
@synthesize imge;
@synthesize currentProgress;
@synthesize maxProressValue;
@synthesize engine;
@synthesize albumLogoDidDownload;
@synthesize mp3DownloadState;
@synthesize duration;

- (void)dealloc{
    self.album_id = nil;
    self.album_logo= nil;
    self.album_name= nil;
    self.artist_id= nil;
    self.artist_logo= nil;
    self.artist_name= nil;
    self.song_id= nil;
    self.song_level= nil;
    self.song_location= nil;
    self.song_logo= nil;
    self.song_lrc= nil;
    self.lrc = nil;
    self.song_name= nil;
    self.imge = nil;
    [super dealloc];
}
@end
