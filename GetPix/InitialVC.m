//
//  InitialVC.m
//  GetPix
//
//  Created by Darren Venn on 3/30/13.
//  Copyright (c) 2013 Darren Venn. All rights reserved.
//

#import "InitialVC.h"

@implementation InitialVC

// Not much in this ViewController. It only exists to trigger loading the ShowPix ViewController.

- (IBAction)doButton:(id)sender {
    
     [self performSegueWithIdentifier: @"SegueToImageDisplay" sender: self];
    
}

@end
