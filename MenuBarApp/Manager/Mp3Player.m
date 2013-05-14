//
//  Mp3Player.m
//  MenuBarApp
//
//  Created by zhang ting on 9/8/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "Mp3Player.h"
#import "../Utility/NSString+UrlEncoding.h"

@implementation Mp3Player

@synthesize delegate, song, player, musicIsPause;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.asiRequet.delegate = nil;
    self.asiRequet = nil;
    self.delegate = nil;
    self.song = nil;
    self.player = nil;
    [super dealloc];
}


- (void)playMusic{
    self.musicIsPause = NO;
    
    if (self.player != nil) {
        [self.player pause];
        self.player = nil;
    }
    
    NSURL *url = [NSURL URLWithString:self.song.song_location];
    self.player = [[[AVPlayer alloc] initWithURL:url] autorelease];
    [self.player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)pauseMusic{
    if (self.song == nil) {
        return;
    }
    if (self.musicIsPause == YES) {
        [self.player play];
    }else{
        [self.player pause];
    }
    self.musicIsPause = !self.musicIsPause;
    DLogF(@"music is pause state:%d", self.musicIsPause);
}

- (void)stopMusic{
    if (self.player != nil) {
        [self.player pause];
    }
}

- (void)musicPlayEnd{
    [self.delegate mp3PlayNextMusic];
    DLog(@"music play end");
}

- (void)getSongInfo:(Song*)s{
    self.song = s;
    self.asiRequet = [[ASIHTTPRequest requestWithURL:[NSURL URLWithString:s.song_location]] retain];
    [self.asiRequet setDidFinishSelector:@selector(baiduMp3LocationDidDone:)];
    [self.asiRequet setDidFailSelector:@selector(baiduMp3LocationDidFaild:)];
    self.asiRequet.delegate = self;
    [self.asiRequet startAsynchronous];
}

#pragma makr -
- (void)baiduMp3LocationDidDone:(ASIHTTPRequest*)request{
    NSData* data = [request responseData];
    NXJsonParser* parser = [[[NXJsonParser alloc] initWithData:data] autorelease];
    NSDictionary *result = [parser parse:nil ignoreNulls:YES];
    NSDictionary *dic = (NSDictionary*)result;
    NSString *errorCode = dicValueForKey(dic, @"error_code");
    
    if (errorCode.intValue == 22000) {
        NSDictionary *baiduSongInfo = [result objectForKey:@"songinfo"];
        if (baiduSongInfo != nil) {
            song.artist_name = dicValueForKey(baiduSongInfo, @"author");
            song.album_logo = [dicValueForKey(baiduSongInfo, @"pic_radio") replaceSpaseWithUrlEncode];
            song.song_name = dicValueForKey(baiduSongInfo, @"title");
            self.song.song_logo = dicValueForKey(baiduSongInfo, @"pic_big");
            self.song.album_name = dicValueForKey(baiduSongInfo, @"album_title");
            self.song.song_lrc = dicValueForKey(baiduSongInfo, @"lrclink");
        }
        baiduSongInfo = nil;
        baiduSongInfo = [result objectForKey:@"songurl"];
        if(baiduSongInfo != nil){
            NSArray *url = [baiduSongInfo objectForKey:@"url"];
            NSDictionary *firstUlrDic = url == nil ? nil : [url objectAtIndex:0];
            DLog(url);
            if (firstUlrDic != nil) {
                //高品质音乐
                self.song.song_location = dicValueForKey(firstUlrDic, @"show_link");
                if (self.song.song_location == nil) {
                    //一般品质
                    self.song.song_location = dicValueForKey(firstUlrDic, @"file_link");
                }
                self.song.duration = [dicValueForKey(firstUlrDic, @"file_duration") floatValue];
            }
        }
        
        DLogF(@"%@, logo:%@, location:%@ duration:%f", result, self.song.song_logo, self.song.song_location, self.song.duration);
        
        [self.delegate mp3InfoDidDownload:self.song];
        
        [self playMusic];
    }else{
        [self baiduMp3LocationDidFaild:nil];
    }
}

- (void)baiduMp3LocationDidFaild:(ASIHTTPRequest*)request{
    
}
@end
