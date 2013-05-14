//
//  macro.h
//  MacApp
//
//  Created by zhang ting on 8/31/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

//#ifndef MacApp_macro_h
//#define MacApp_macro_h


#define Debug_Model

#ifdef  Debug_Model
#define DLog(A) NSLog((@"%@(%d): %@"),[[NSString stringWithFormat:@"%s", __FILE__] lastPathComponent], __LINE__, A)
#else
#define DLog(A)
#endif

#ifdef  Debug_Model
#define DLogF(fmt, ...)  NSLog((@"%@(%d): " fmt),[[NSString stringWithFormat:@"%s", __FILE__] lastPathComponent], __LINE__, ##__VA_ARGS__)
#else
#define DLogF(fmt, ...)
#endif


#define dicValueForKey(dic, key) [dic objectForKey:key] == nil ? nil : [dic objectForKey:key]
#define FormatStr(fmt, ...) [NSString stringWithFormat:fmt, ##__VA_ARGS__]

#define SafeRelease(A) [A release];A=nil




//notification keys
#define kQueueDidFinished @"kQueueDidFinished"
#define kQueueRestart @"kQueueRestart" 

// 当前选择的搜索引擎
typedef enum SearchEngine{
    Xiami_engine = 0,
    Baidu_engine
}SearchEngine;

//当前封面的下载状态
typedef enum AlbumCoverDownloadState{
    CoverDownloadNever = 0,
    CoverDownloadDoing,
    CoverDownloadEnd
}AlbumCoverDownloadState;

//当前封面的下载状态
typedef enum Mp3DownloadState{
    Mp3DownloadFaild = 0,
    Mp3DownloadDoing,
    Mp3DownloadEnd
}Mp3DownloadState;

// 启用快捷键
#define kUserChangedShortCutState @"kUserChangedShortCutState"
