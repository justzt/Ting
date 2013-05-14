//
//  FavoritManager.m
//  JusTing
//
//  Created by zhang ting on 9/18/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "FavoritManager.h"
#import "DownloadManager.h"
#import "../Vender/Asi-http/ASIHTTPRequest.h"
#import "../Utility/api.h"

@implementation FavoritManager

@synthesize delegate;

- (void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

- (void)loadFavoriteList{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_favorite_list]];
    request.delegate  = self;
    [request setDidFailSelector:@selector(loadFavoriteListFailed:)];
    [request setDidFinishSelector:@selector(loadFavoriteListSuccess:)];
    [request startAsynchronous];
}

- (void)addFavorite{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_add_favorite]];
    request.delegate  = self;
    [request setDidFailSelector:@selector(addFavoriteFailed:)];
    [request setDidFinishSelector:@selector(addFavoriteSuccess:)];
    [request startAsynchronous];
}

- (void)deleteFavorite{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:API_del_favorite]];
    request.delegate  = self;
    [request setDidFailSelector:@selector(deleteFavoriteFailed:)];
    [request setDidFinishSelector:@selector(deleteFavoriteSuccess:)];
    [request startAsynchronous];
}

#pragma mark - ASIHTTPRequest Delegate
- (void)loadFavoriteListFailed:(ASIHTTPRequest*)request{

}

- (void)loadFavoriteListSuccess:(ASIHTTPRequest*)request{
    DLog([request responseString]);
}

- (void)addFavoriteFailed:(ASIHTTPRequest*)request{
    
}

- (void)addFavoriteSuccess:(ASIHTTPRequest*)request{
    
}

- (void)deleteFavoriteFailed:(ASIHTTPRequest*)request{
    
}

- (void)deleteFavoriteSuccess:(ASIHTTPRequest*)request{
    
}
@end
