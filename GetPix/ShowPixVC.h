//
//  ShowPixVC.h
//  GetPix
//
//  Created by Darren Venn on 3/30/13.
//  Copyright (c) 2013 Darren Venn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynchImageView.h"
#define TOTAL_NUMBER_OF_IMAGES 200 // number of images that will be loaded on the scrollview

@interface ShowPixVC : UIViewController

- (IBAction)doBackButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *pixScrollView;
@property (strong, nonatomic) NSMutableArray *images;
@property (assign) NSInteger numberOfImagesProcessed;
@property (strong, nonatomic) UILabel *statusLabel;
@property (nonatomic,assign) NSTimeInterval timeStartedLoading;
@property (nonatomic,assign) NSTimeInterval timeCompletedLoading;
@property (strong, nonatomic) NSOperationQueue *queue;

@end
