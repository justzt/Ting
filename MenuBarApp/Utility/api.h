//
//  api.h
//  MacApp
//
//  Created by zhang ting on 8/31/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#ifndef MacApp_api_h
#define MacApp_api_h

#define Search(type, keyWord, page) [NSString stringWithFormat:@"%@/search-PART?key=%@&page=%d&type=%@", API, keyWord, page, type]

#define API_radio_list @"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.radio.getCategoryList&format=json&from=ios&version=2.1.1"

#define API_channel_pub_song_list(cid, ch_name) [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.radio.getChannelSong&channelid=%@&channelname=%@&pn=0&rn=100&format=json&from=ios&version=2.1.1", cid, ch_name]

#define API_channel_artist_song_list(artisId) [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.radio.getArtistChannelSong&artistid=%@&pn=0&rn=150&format=json&from=ios&version=2.1.1", artisId]

#define API_song_location(mp3_id) [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.song.getInfo&songid=%@&format=json&from=ios&version=2.1.0", mp3_id]

// 红心电台api
#define session_key @"FTTHBsVmRWVmFEMC0zdTRMaVNnazAtbjVWanlvdzhoV1huYnh6MFcxWkRRRHhSQVFBQUFBJCQAAAAAAAAAAAoqyA0l-XkPaGFkaV96aGFuZwAAAAAAAAAAAAAAAAAAAAAAAAAAAACAYIArMAAAAOCK5XgAAAAAeGlDAAAAAAAxMC4yNi4xMEPyTlBD8k5QT3"
#define API_favorite_list [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.radio.getFavoriteSong&pn=0&rn=100&format=json&USERID=0&bduss=%@&BAIDUID=0&from=ios&version=2.1.1", session_key]
#define API_add_favorite [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.favorite.addSongFavorite&format=json&token=7f603a02d060b43e561e03607b32457f&session_key=%@&songId=215011&listId=0&from=ios&version=2.1.1", session_key]
#define API_del_favorite [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.favorite.delSongFavorite&format=json&token=7f603a02d060b43e561e03607b32457f&session_key=%@&songId=215011&@&listId=0&from=ios&version=2.1.1", session_key]
#define API_private_channel [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.radio.serv&usrname=hadi_zhang&needdata=true&tcount=0&title=&format=json&USERID=0&bduss=%@&BAIDUID=0&from=ios&version=2.1.1", session_key]
#endif
