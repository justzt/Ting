//
//  LocalFileManager.h
//  CA
//
//  Created by AMP on 11/30/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalFileManager : NSObject {
    NSString *docPath_;
    NSString *libPath_;
    NSString *libCachePath_;
    NSString *thumbnailFolder;
    NSString *libPrivatePath_;
    NSString *tempPath_;
    NSFileManager *fileA_;

}

+ (LocalFileManager *) manager;
- (void) setUp;

- (NSString *) DBPath;
- (void) removeDBFile;
- (NSString *) pathForImageFile: (NSString *) imgURL;
- (NSString *) tempPathForFile: (NSString *) fileName;

- (BOOL)saveImageWithUrl:(NSString*)imgUrl image:(NSImage*)image;
- (NSImage*)imageWithImagUrl:(NSString*)imgUrl;

- (BOOL)imageIsexistWithUrl:(NSString*)imgUrl;

- (NSString*)defaultMp3SaveToPath;
@end
