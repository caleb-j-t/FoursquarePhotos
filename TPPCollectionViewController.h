//
//  TPPCollectionViewController.h
//  PhotoPhun
//
//  Created by Caleb Talbot on 8/3/16.
//  Copyright © 2016 Caleb Talbot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SimpleAuth/SimpleAuth.h>
#import "TPPDetailViewController.h"

extern NSString *const DATA_VERSION_DATE;
extern NSString *const DATA_FORMAT;

@interface TPPCollectionViewController : UICollectionViewController

@property (nonatomic) NSString *accessToken;
@property NSArray *likedArray;
@property NSMutableArray *venueArray;

@end
