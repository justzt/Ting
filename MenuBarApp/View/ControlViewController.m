//
//  ControlViewController.m
//  MenuBarApp
//
//  Created by zhang ting on 9/7/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "ControlViewController.h"
#import "../Utility/api.h"
#import "../Utility/NSString+UrlEncoding.h"
#import "../Manager/PreferencesManager.h"


#define favoriteButtonState_normal 100
#define favoriteButtonState_checked  101

#define playButtonState_playing 103
#define playButtonState_pause  104

#define downloadButtonState_normal 105
#define downloadButtonState_checked  106

#define showLrcOriginX 9
#define hideLrcOriginX -220

@interface ControlViewController ()

@end

@implementation ControlViewController

@synthesize songArray, mp3Player;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SafeRelease(mpeDownloaderQueue);
    SafeRelease(keyTap);
    self.mp3Player = nil;
    self.songArray = nil;
    [super dealloc];
}

- (IBAction)favoriteButtonAction:(id)sender {
//    NSButton *button = (NSButton*)sender;
}

- (IBAction)playButtonAction:(id)sender {
    NSButton *button = (NSButton*)sender;
    if (button.tag == playButtonState_playing) {
        button.tag = playButtonState_pause;
        [button setImage:[NSImage imageNamed:@"radio_playing_button_play_normal"]];
    }else{
        button.tag = playButtonState_playing;
        [button setImage:[NSImage imageNamed:@"radio_playing_button_pause_normal"]];
    }
    [self.mp3Player pauseMusic];
}

- (IBAction)nextButtonAction:(id)sender {
    [self playNextMusic];
}

- (IBAction)downloadButtonAction:(id)sender {
    NSButton *button = (NSButton*)sender;
    [button setEnabled:NO];
    Song *song = [self.songArray objectAtIndex:currentPlayIndex-1];
    Mp3Downloader *mp3Downloader = [[Mp3Downloader alloc] init];
    mp3Downloader.delegate = self;
    if (mpeDownloaderQueue == nil) {
        mpeDownloaderQueue = [[Mp3DwonloadQueue alloc] init];
    }
    [mpeDownloaderQueue downloadWith:[mp3Downloader downloadMp3Request:song]];
    
    
    // 显示开始下载消息
    UserNotiManager *noti = [[UserNotiManager alloc] init];
    [noti postUserNotificationWithTitle:@"开始下载歌曲" subTitle:song.song_name infoText:(song.artist_name)];
}

- (IBAction)lrcButtonAction:(id)sender {
//    NSButton *button = (NSButton*)sender;
    CGRect frame = lrcSrollview.frame;
    if (frame.origin.x == hideLrcOriginX) {
        frame.origin.x = showLrcOriginX;
    }else{
        frame.origin.x = hideLrcOriginX;
    }
    lrcSrollview.frame = frame;
}

- (void)downloadSongListWithUrlString:(NSString*)strUrl{
    if (self.mp3Player != nil) {
        [self.mp3Player stopMusic];
    }
    channelType = otherChannel;
    // 红心电台
    if ([strUrl isEqualToString:@"redStar"]) {
        strUrl = API_favorite_list;
        channelType = redStarChannel;
    }
    
    // 私人电台
    if ([strUrl isEqualToString:@"privateChannel"]) {
        strUrl = API_private_channel;
        channelType = privateChannel;
    }

    
    DownloadManager *dm = [[[DownloadManager alloc] init] autorelease];
    dm.delegate = self;
    [dm startRequestWithRequest:strUrl async:NO];
}

- (void)playNextMusic{
    [downloadButton setEnabled:NO];
    
    
    // 歌曲列表获取之后从第一首开始播放
    if (self.mp3Player != nil) {
        self.mp3Player.delegate = nil;
        self.mp3Player = nil;
    }
    self.mp3Player = [[[Mp3Player alloc] init] autorelease];
    self.mp3Player.delegate = self;

    if (currentPlayIndex >= [self.songArray count]) {
        currentPlayIndex = 0;
    }
    
    if (self.songArray == nil && [self.songArray count]<=0) {
        return;
    }
    
    Song *song = [self.songArray objectAtIndex:currentPlayIndex];
    [self.mp3Player getSongInfo:song];
    currentPlayIndex++;
    if (currentPlayIndex >= self.songArray.count-1) {
        currentPlayIndex = 0;
    }
}

- (void)downlSongCover:(Song*)song{
    ImageDownloader *imgDownloader = [[ImageDownloader alloc] init];
    imgDownloader.delegate = self;
    [imgDownloader downloadImageWithSong:song rowIndex:0];
}

- (void)checkShortCutEnableState{
    keyTap = [[SPMediaKeyTap alloc] initWithDelegate:self];
	if([SPMediaKeyTap usesGlobalMediaKeyTap])
		[keyTap startWatchingMediaKeys];
	else
		NSLog(@"Media key monitoring disabled");
}

-(void)mediaKeyTap:(SPMediaKeyTap*)keyTap receivedMediaKeyEvent:(NSEvent*)event;
{
	NSAssert([event type] == NSSystemDefined && [event subtype] == SPSystemDefinedEventMediaKeys, @"Unexpected NSEvent in mediaKeyTap:receivedMediaKeyEvent:");
	// here be dragons...
	int keyCode = (([event data1] & 0xFFFF0000) >> 16);
	int keyFlags = ([event data1] & 0x0000FFFF);
	BOOL keyIsPressed = (((keyFlags & 0xFF00) >> 8)) == 0xA;
	
	if (keyIsPressed) {
		switch (keyCode) {
			case NX_KEYTYPE_PLAY:
                    [self playButtonAction:playButton];
				break;
				
			case NX_KEYTYPE_FAST:
                [self nextButtonAction:nextButton];
				break;
				
			case NX_KEYTYPE_REWIND:
                [self downloadButtonAction:downloadButton];
				break;
			default:
				break;
                // More cases defined in hidsystem/ev_keymap.h
		}
	}
}


#pragma mark - life
- (void)awakeFromNib{
    // 监听用户启用快捷键状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkShortCutEnableState) name:kUserChangedShortCutState object:nil];
    // 是否启用快捷键
    [self checkShortCutEnableState];
    
    //default contrl buttons state
    favoriteButton.tag = favoriteButtonState_normal;
    playButton.tag = playButtonState_playing;
    downloadButton.tag = downloadButtonState_normal;
    [downloadButton setEnabled:NO];
    lrcSrollview.backgroundColor = [NSColor colorWithPatternImage:[NSImage imageNamed:@"lrcViewBg.png"]];
    lrcView.alignment = NSCenterTextAlignment;
    lrcView.textColor = [NSColor whiteColor];
}

#pragma mark - DownloadManagerDelegate
- (void)downloadFaild{
    
}


- (void)addPrivateCategorySonglist:(NSArray*)songList{
    for (NSDictionary *s in songList) {
        Song *song = [[Song alloc] init];
        song.song_id = dicValueForKey(s, @"song_id");
        song.song_location = [API_song_location(song.song_id) replaceSpaseWithUrlEncode];
        [self.songArray addObject:song];
        [song release];
    }
}
- (void)downloadSuccess:(id)result{
    currentPlayIndex = 0;
    self.songArray = [NSMutableArray array];
    NSDictionary *dic = (NSDictionary*)result;
    //search success
    // 如果是红心电台        
    if (channelType == redStarChannel) {
        NSArray *songList =  dicValueForKey(dic, @"result");
        [self addPrivateCategorySonglist:songList];
    }
    // 私人频道
    else if(channelType == privateChannel){
        NSArray *songList =  dicValueForKey(dic, @"songinfo");
        [self addPrivateCategorySonglist:songList];
    }
    //公共和音乐人频道
    else{
        NSDictionary *resultDic = dicValueForKey(dic, @"result");
        NSArray *songList = dicValueForKey(resultDic, @"songlist");
        for (NSDictionary *s in songList) {
            Song *song = [[Song alloc] init];
            song.artist_name = dicValueForKey(s, @"artist");
            song.album_logo = [dicValueForKey(s, @"thumb") replaceSpaseWithUrlEncode];
            song.song_name = dicValueForKey(s, @"title");
            song.song_id = dicValueForKey(s, @"songid");
            song.song_location = [API_song_location(song.song_id) replaceSpaseWithUrlEncode];
            [self.songArray addObject:song];
            [song release];
        }
    }
    [self playNextMusic];
}

#pragma mark - Mp3PlayerDelegate
- (void)mp3InfoDidDownload:(Song*)song{
    [song retain];
    // start download song
    [self downlSongCover:song];
    // start download cover
    LrcDownloder *lrc = [[LrcDownloder alloc] init];
    [lrc setDelegate:self];
    [lrc downloadLrcWith:song];
    
    // 
    [downloadButton setEnabled:YES];
    
    
    DLogF(@"title:%@, album:%@, artist:%@", song.song_name, song.album_name, song.artist_name);
    songName.stringValue = song.song_name == nil ? @"未知" : song.song_name;
    albumName.stringValue = song.album_name == nil ? @"未知" : song.album_name;
    artistName.stringValue = song.artist_name == nil ? @"未知" : song.artist_name;
    // 显示开始下载消息
    [[UserNotiManager manager] postUserNotificationWithTitle:@"正在播放" subTitle:song.song_name infoText:(song.artist_name)];
    [song release];
}

- (void)mp3PlayNextMusic{
    [self playNextMusic];
}

#pragma mark - ImageDownloaderDelegate
- (void)imageDidDownload:(NSImage *)image downloader:(id)downloder rowIndex:(int)rowIndex{
    coverCell.image = image == nil ? [NSImage imageNamed:@"cover"] : image;
    [downloder release];
}

#pragma mark - Mp3DownloaderDelegate
- (void)mp3DownloadFinished:(BOOL)success downloader:(id)obj
{
    Song *song = [self.songArray objectAtIndex:currentPlayIndex-1];
    [downloadButton setEnabled:NO];
    [[UserNotiManager manager] postUserNotificationWithTitle:success == YES ? @"下载成功": @"下载失败" subTitle:song.song_name infoText:(song.artist_name)];

    
    // 检测是否需要下载歌词
    if([[PreferencesManager manager] needDownloadLrc] == YES){
        dispatch_queue_t queue =  dispatch_queue_create("loadPhotorecor", NULL);
        dispatch_async(queue, ^{
                NSString *path = [[PreferencesManager manager] mp3Path];
                NSString *tmpPath = [path stringByAppendingPathComponent:FormatStr(@"%@.lrc", song.song_name)];
                if (song.lrc != nil && [song.lrc length]>0) {
                    NSError *error = nil;
                    [song.lrc writeToFile:tmpPath options:NSDataWritingAtomic error:&error];
//                    value == YES ? DLog(@"歌词下载成功") : DLogF(@"歌词faild:%@, path:%@", error, path);
                }
        });
        dispatch_release(queue);
    }
    
    [obj release];
}

#pragma mark - LrcDownloderDelegate
- (void)lrcDidDownload:(NSString *)lrc lrcDownloader:(id)obje{
    DLogF(@"%@", [NSValue valueWithRect:lrcSrollview.frame]);
    lrcView.string = [lrc lrcCleaner];
    DLogF(@"%@", [NSValue valueWithRect:lrcSrollview.frame]);
    [obje release];
}
@end
