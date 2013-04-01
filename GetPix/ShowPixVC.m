//
//  ShowPixVC.m
//  GetPix
//
//  Created by Darren Venn on 3/30/13.
//  Copyright (c) 2013 Darren Venn. All rights reserved.
//

#import "ShowPixVC.h"

@implementation ShowPixVC

// This ViewController contains one UIScrollView that has images loaded onto to, as well as
// a back button to dismiss the VC and go back to the intial screen.

// lazy instantiating getter for the array of images
- (NSMutableArray*) images {
    if (_images == nil) {
        _images = [[NSMutableArray alloc] initWithCapacity:1000];
    }
    return _images;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // here we draw the array images on the UIScrollView but we don't yet load them.
    // The images will initially display as gray tiles.
    int heightFromTop = 6;
    for (int i=0; i < TOTAL_NUMBER_OF_IMAGES; i++) {
        // Each image file is of the format Magnolia0000x.jpg and they are all the same size.
        // We draw two images per row with a border of size 6 around each image.
        NSString *urlString = [NSString stringWithFormat:@"http://darrenvenn.com/TestImages/Magnolia%05d.jpg",i];
        int spaceFromLeft = 6 + ((i%2) * 157);
        [self.images addObject:[[AsynchImageView alloc] initWithFrameURLStringAndTag:CGRectMake(spaceFromLeft, heightFromTop, 151, 100):urlString:i]];
        [self.pixScrollView addSubview:[self.images objectAtIndex:i]];
        if (spaceFromLeft != 6) {
            heightFromTop = heightFromTop + 106; // mark the next y-axis beginning point on every second image (since there are 2 per row)
        }
    }
    
    heightFromTop = heightFromTop - 6;
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, heightFromTop, 308, 50)];
    self.statusLabel.backgroundColor = [UIColor blackColor];
    self.statusLabel.textColor = [UIColor whiteColor];    
    self.statusLabel.font = [UIFont fontWithName:@"Noteworthy-Bold" size:(16.0)];
    self.statusLabel.text = @"loading images...";
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.pixScrollView addSubview:self.statusLabel];
    
    // set the size of the scrollView, based on total number of images.
    self.pixScrollView.contentSize = CGSizeMake(320, heightFromTop + 6 + 50);
    // every time an images completes loading, respond by executing the doStats method:
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doStats) name:@"com.darrenvenn.completedImageLoad" object:nil];
    
}

- (void) doStats {
    // an image completed loading, so add one to the number processed, and, if all are now complete, update the load message.
    self.numberOfImagesProcessed++;
    if (self.numberOfImagesProcessed == TOTAL_NUMBER_OF_IMAGES) {
        self.timeCompletedLoading = [NSDate timeIntervalSinceReferenceDate];                
        self.statusLabel.text = [NSString stringWithFormat:@"Images loaded in %f seconds.",(self.timeCompletedLoading - self.timeStartedLoading)];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // We only start to load the images once the view has appeared. This is just for clarity's sake. This processing may happen elsewhere, e.g. in ViewDidLoad or viewWillAppear.
    self.queue = [[NSOperationQueue alloc] init]; // set up the queue for background processing of the image downloads
    [self.queue setMaxConcurrentOperationCount:20]; // set the queue to process a max of 20 images at a time
    self.numberOfImagesProcessed = 0;
    self.timeStartedLoading = [NSDate timeIntervalSinceReferenceDate];
    for (AsynchImageView *currImage in self.images) {
        [currImage loadImageFromNetwork:self.queue];
    }
    
}

- (IBAction)doBackButton:(id)sender {
    
    // ditch this ViewController and go back to the initial screen.
    self.queue = nil;
    self.images = nil;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
