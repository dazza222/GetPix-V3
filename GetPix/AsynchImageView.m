//
//  AsynchImageView.m
//  GetPix
//
//  Created by Darren Venn on 3/30/13.
//  Copyright (c) 2013 Darren Venn. All rights reserved.
//

#import "AsynchImageView.h"

@implementation AsynchImageView

// This class implements a "self-loading" UIImageView. When a new AsynchImageView is
// created, the frame etc. are set up, but the image itself is not loaded until
// the loadImageFromNetwork method is called.
// With this version, when the loadImageFromNetwork method is called, an NSOperation
// is created and added to the queue. The NSURLConnection call, and handling of the
// reply is done in the GetImageOperation class.

- (id)initWithFrameURLStringAndTag:(CGRect)frame :(NSString*) urlString :(NSInteger) tag;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.urlString = urlString;
        // image is grey tile before loading
        self.backgroundColor = [UIColor grayColor];
        // set the tag so we can find this image on the UI if we need to
        self.tag = tag;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrameURLStringAndTag:frame :@"" :0];
}

- (void)loadImageFromNetwork:(NSOperationQueue*) queue {
    
    // add an operation to the queue, setting up a KVO to listen for the reply
    self.loadOperation = [[GetImageOperation alloc] initWithURLString:self.urlString];
    [self.loadOperation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
    [queue addOperation:self.loadOperation];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)operation change:(NSDictionary *)change context:(void *)context {
    // when the image is finished loading, respond by loading the data into this class's image object, so that
    // it appears on the ScrollView.
    if ([operation isEqual:self.loadOperation]) {
        [self.loadOperation removeObserver:self forKeyPath:@"isFinished"];
        if ([self.loadOperation imageWasFound]) {
            self.image=[UIImage imageWithData:[self.loadOperation data]];
        }
        else {
            // if there was a problem loading the image then show a "timeout" image.
            self.image=[UIImage imageNamed:@"TimeOut.jpg"];
        }
        // notify that we are done with this image back to the ViewController
        self.loadOperation = nil; // this line is important!
        [[NSNotificationCenter defaultCenter] postNotificationName:@"com.darrenvenn.completedImageLoad" object:nil];
    }
}

- (void) dealloc {

    @try{
        [self.loadOperation removeObserver:self forKeyPath:@"isFinished" context:NULL];
    }@catch(id anException){
        //do nothing. If we can't remove the observer then there was no attachment.
    }
    self.urlString = nil;
    self.loadOperation = nil;
    
}

@end
