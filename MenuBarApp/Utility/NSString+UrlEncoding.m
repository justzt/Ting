//
//  NSString+UrlEncoding.m
//  MusicDownloader
//
//  Created by zhang ting on 7/26/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "NSString+UrlEncoding.h"

@implementation NSString (UrlEncoding)

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (NSString*)replaceSpaseWithUrlEncode{
   return  [self stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
}

- (NSString*)removeEmTag{
    NSString *str = [self stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
    return  [str stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
}

- (NSString *)lrcCleaner{
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:self];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"[" intoString:NULL] ;
        
        [theScanner scanUpToString:@"]" intoString:&text] ;
        
        self = [self stringByReplacingOccurrencesOfString:
                      [NSString stringWithFormat:@"%@]", text]
                                                           withString:@"\n"];
        
    }
    
    return self ;
}
@end
