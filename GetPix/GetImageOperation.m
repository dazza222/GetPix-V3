//
//  GetImageOperation.m
//  GetPix
//
//  Created by Darren Venn on 3/31/13.
//  Copyright (c) 2013 Darren Venn. All rights reserved.
//

#import "GetImageOperation.h"

@implementation GetImageOperation

// lazy instantiating getter for data
//- (NSMutableData*) data {
//    if (_data == nil) {
//        _data = [[NSMutableData alloc] init];
//    }
//    return _data;
//}

- (id)initWithURLString:(NSString*) urlString;
{
    self = [super init];
    if (self) {
        self.urlString = urlString;
        executing = NO;
        finished = NO;
        gotImage = NO;
    }
    return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return executing;
}

- (BOOL)isFinished
{
    return finished;
}

- (void)start
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if ([self isCancelled] || finished) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection == nil) {
        [self markOperationAsCompleted];
    }
}

- (void) markOperationAsCompleted
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    executing = NO;
    finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    if([self isCancelled]) {
        [self markOperationAsCompleted];
		return;
    }
    
    self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // if the load failed then indicate that no image was downloaded.
    gotImage = NO;
    [self markOperationAsCompleted];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // the load succeeded so indicate that an image was downloaded.
    gotImage = YES;
    [self markOperationAsCompleted];
}

- (BOOL)imageWasFound
{
    return gotImage;
}

@end
