//
//  ControlViewController.h
//  MenuBarApp
//
//  Created by zhang ting on 9/7/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../Manager/DownloadManager.h"
#import "../Model/Song.h"
#import "../Vender/Asi-http/ASIHTTPRequest.h"
#import "../Manager/Mp3Player.h"
#import "../Manager/ImageDownloader.h"
#import "../Manager/Mp3Downloader.h"
#import "../Manager/Mp3DwonloadQueue.h"
#import "../Manager/LrcDownloder.h"
#import "../Vender/Global-hotkey/SPMediaKeyTap.h"

typedef enum ChannelType{
    redStarChannel = 0,
    privateChannel,
    otherChannel
}ChannelType;

@interface ControlViewController : NSViewController<DownloadManagerDelegate, Mp3PlayerDelegate, ImageDownloaderDelegate, Mp3DownloaderDelegate, LrcDownloderDelegate>
{
    IBOutlet NSTextField *userId;
    IBOutlet NSButton *favoriteButton;
    IBOutlet NSButton *playButton;
    IBOutlet NSButton *nextButton;
    IBOutlet NSButton *downloadButton;
    IBOutlet NSTextField *songName;
    IBOutlet NSTextField *albumName;
    IBOutlet NSTextField *artistName;
    IBOutlet NSImageView *coverCell;
    IBOutlet NSScrollView *lrcSrollview;
    IBOutlet NSTextView *lrcView;
    SPMediaKeyTap *keyTap;
    Mp3DwonloadQueue *mpeDownloaderQueue;
    NSMutableArray *songArray;
    int currentPlayIndex;
    ChannelType channelType;
}

@property (retain, nonatomic)     NSMutableArray *songArray;
@property (retain, nonatomic)     Mp3Player *mp3Player;

- (IBAction)favoriteButtonAction:(id)sender;
- (IBAction)playButtonAction:(id)sender;
- (IBAction)nextButtonAction:(id)sender;
- (IBAction)downloadButtonAction:(id)sender;
- (IBAction)lrcButtonAction:(id)sender;
- (void)downloadSongListWithUrlString:(NSString*)strUrl;
@end
