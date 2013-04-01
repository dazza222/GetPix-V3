//
//  GetImageOperation.h
//  GetPix
//
//  Created by Darren Venn on 3/31/13.
//  Copyright (c) 2013 Darren Venn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetImageOperation : NSOperation {
    BOOL executing;
    BOOL finished;
    BOOL gotImage;
}

@property (strong,nonatomic) NSMutableData *data;
@property (strong,nonatomic) NSString *urlString;

- (id)initWithURLString:(NSString*) urlString;
- (BOOL)imageWasFound;

@end
