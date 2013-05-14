//
//  LocalFileManager.m
//  CA
//
//  Created by AMP on 11/30/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "LocalFileManager.h"

#define DBName          @"db.sql"
#define FavDataFile     @"favorite"
#define HistoryDataFile @"history"
#define tmlDownloadFolder @"downloadTMP"

@interface LocalFileManager(private)
- (void) touchFolder: (NSString *) path;
- (void) touchFolder: (NSString *) path secondary: (BOOL) isSec;
- (NSString *) favFilePath;
- (NSString *) historyDataFile;
@end

static LocalFileManager *fileMan = NULL;
@implementation LocalFileManager

+ (LocalFileManager *) manager {
    if (fileMan == NULL) {
        [[LocalFileManager alloc] init];
    }
    return fileMan;
}

- (id) init {
    if (fileMan == NULL) {
        fileMan = [super init];
        [fileMan setUp];
    }
    return fileMan;
}

- (void)dealloc {
    SafeRelease(libPath_);
    SafeRelease(libCachePath_);
    SafeRelease(libPrivatePath_);
    SafeRelease(tempPath_);
    SafeRelease(docPath_);
    SafeRelease(fileA_);
    SafeRelease(thumbnailFolder);
    
    [super dealloc];
}

- (void) setUp {
    fileA_ = [[NSFileManager alloc] init];
    
    docPath_ = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] retain];
    libPath_ = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] retain];
    libCachePath_ = [[libPath_ stringByAppendingPathComponent: @"Caches"] retain];
    thumbnailFolder = [[libCachePath_ stringByAppendingPathComponent: @"thumbnails"] retain];
    [self touchFolder: thumbnailFolder];
    libPrivatePath_ = [[libPath_ stringByAppendingPathComponent: @"Private Document"] retain];
    [self touchFolder: libPrivatePath_];
    tempPath_ = [[[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent: tmlDownloadFolder] retain];
    [fileA_ removeItemAtPath: tempPath_ error: nil];
    [self touchFolder: tempPath_];
}

- (void) touchFolder: (NSString *) path {
    [self touchFolder: path secondary: NO];
}

- (void) touchFolder: (NSString *) path secondary: (BOOL) isSec {
    if (![fileA_ fileExistsAtPath: path]) {
        if (isSec)
            [self touchFolder: [path stringByDeletingLastPathComponent]];
        [fileA_ createDirectoryAtPath: path withIntermediateDirectories: NO attributes: nil error: nil];
    }
}

- (NSString *) DBPath {
    return [libPrivatePath_ stringByAppendingPathComponent: DBName];
}

- (void) removeDBFile {
    [fileA_ removeItemAtPath: [self DBPath] error: nil];
}

- (NSString *) pathForImageFile: (NSString *) imgURL {
    NSString *imgName = [NSString stringWithFormat: @"%ld", [imgURL hash]];
    return [thumbnailFolder stringByAppendingPathComponent: imgName];
}

- (NSString *) tempPathForFile: (NSString *) fileName {
    return [tempPath_ stringByAppendingPathComponent: fileName];
}



- (NSString *) favFilePath {
    return [libPrivatePath_ stringByAppendingPathComponent: FavDataFile];
}

- (NSString *) historyDataFile {
    return [libPrivatePath_ stringByAppendingPathComponent: HistoryDataFile];
}

- (BOOL)saveImageWithUrl:(NSString*)imgUrl image:(NSImage*)image{
    dispatch_queue_t queue =  dispatch_queue_create("loadPhotorecor", NULL);
    dispatch_async(queue, ^{
        NSString *imgPath = [self pathForImageFile:imgUrl];
        NSData *imageData = [image TIFFRepresentation];
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
        NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
        imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
        [imageData writeToFile:imgPath atomically:YES];
    });
    dispatch_release(queue);
    return YES;
}

- (NSImage*)imageWithImagUrl:(NSString*)imgUrl{
    NSString *imgPath = [self pathForImageFile:imgUrl];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:imgPath];
    return [image autorelease];
}

- (BOOL)imageIsexistWithUrl:(NSString*)imgUrl{
   NSString *path = [self pathForImageFile:imgUrl];
   return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (NSString*)defaultMp3SaveToPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
}
@end
