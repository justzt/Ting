//
//  FavoritManager.h
//  JusTing
//
//  Created by zhang ting on 9/18/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FavoritManagerDelegate <NSObject>

@required
- (void)favoriteSongListLoadSuccess:(NSMutableArray*)array;
@end

@interface FavoritManager : NSObject

@property (assign) id<FavoritManagerDelegate> delegate;

- (void)loadFavoriteList;
- (void)addFavorite;
- (void)deleteFavorite;
@end
