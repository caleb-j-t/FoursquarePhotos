//
//  TPPCollectionViewCell.h
//  PhotoPhun
//
//  Created by Caleb Talbot on 8/3/16.
//  Copyright © 2016 Caleb Talbot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMCache.h"

@interface TPPCollectionViewCell : UICollectionViewCell

@property (nonnull) IBOutlet UIImageView *photoView;
@property (nonnull, nonatomic) NSDictionary *photoData;

@end
