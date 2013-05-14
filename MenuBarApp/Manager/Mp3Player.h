//
//  Mp3Player.h
//  MenuBarApp
//
//  Created by zhang ting on 9/8/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Vender/Asi-http/ASIHTTPRequest.h"
#import "../Model/Song.h"
#import "../Vender/Json/NXJsonParser.h"
#import <AVFoundation/AVFoundation.h>

@protocol Mp3PlayerDelegate <NSObject>

@required
- (void)mp3InfoDidDownload:(Song*)song;
- (void)mp3PlayNextMusic;

@end

@interface Mp3Player : NSObject

@property (nonatomic, retain) ASIHTTPRequest *asiRequet;
@property (nonatomic,assign) id<Mp3PlayerDelegate> delegate;
@property (nonatomic, retain) AVPlayer *player;
@property (nonatomic, retain) Song *song;
@property  BOOL musicIsPause;

- (void)getSongInfo:(Song*)s;
- (void)playMusic;
- (void)pauseMusic;
- (void)stopMusic;
@end
