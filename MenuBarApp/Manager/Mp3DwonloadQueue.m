//
//  Mp3DwonloadQueue.m
//  MusicDownloader
//
//  Created by zhang ting on 9/1/12.
//  Copyright (c) 2012 zhang ting. All rights reserved.
//

#import "Mp3DwonloadQueue.h"

@implementation Mp3DwonloadQueue
@synthesize song, queue;

- (void)dealloc{
    self.song = nil;
    [self.queue cancelAllOperations];
    self.queue = nil;
    [super dealloc];
}

- (void)downloadWith:(ASIHTTPRequest*)asi{
    if (self.queue == nil) {
        self.queue = [ASINetworkQueue queue];
        [self.queue setShouldCancelAllRequestsOnFailure:NO];
        self.queue.maxConcurrentOperationCount = 5;
        [[self queue] setDelegate:self];
        [[self queue] setRequestDidFinishSelector:@selector(requestFinished:)];
        [[self queue] setRequestDidFailSelector:@selector(requestFailed:)];
        [[self queue] setQueueDidFinishSelector:@selector(queueFinished:)];
    }
    [[self queue] addOperation:(ASIHTTPRequest*)asi];
    [self.queue go];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// You could release the queue here if you wanted
	if ([[self queue] requestsCount] == 0) {
        
		// Since this is a retained property, setting it to nil will release it
		// This is the safest way to handle releasing things - most of the time you only ever need to release in your accessors
		// And if you an Objective-C 2.0 property for the queue (as in this example) the accessor is generated automatically for you
		self.queue = nil;
	}
    
	//... Handle success
	NSLog(@"queue a Request finished");
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	// You could release the queue here if you wanted
	if ([[self queue] requestsCount] == 0) {
		self.queue = nil;
	}
    
	//... Handle failure
	NSLog(@"Request failed");
}

- (void)postNoti{
    [[NSNotificationCenter defaultCenter] postNotificationName:kQueueDidFinished object:nil];
}
- (void)queueFinished:(ASINetworkQueue *)queue
{
	// You could release the queue here if you wanted
	if ([[self queue] requestsCount] == 0) {
		self.queue = nil;
	}
	NSLog(@"Queue finished");
    [self performSelector:@selector(postNoti) withObject:nil afterDelay:2];
}
@end
