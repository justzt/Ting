//
//  Mp3DwonloadQueue.h
//  MusicDownloader
//
//  Created by zhang ting on 9/1/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Vender/Asi-http/ASIHTTPRequest.h"
#import "../Vender/Asi-http/ASINetworkQueue.h"
#import "../Model/Song.h"

@interface Mp3DwonloadQueue : NSObject
{
    Song *song;
    ASINetworkQueue *queue;
}

@property (retain, nonatomic) Song *song;
@property (retain, nonatomic)    ASINetworkQueue *queue;

- (void)downloadWith:(ASIHTTPRequest*)asi;
@end
