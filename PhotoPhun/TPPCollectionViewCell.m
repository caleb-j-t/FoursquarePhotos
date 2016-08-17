//
//  TPPCollectionViewCell.m
//  PhotoPhun
//
//  Created by Caleb Talbot on 8/3/16.
//  Copyright © 2016 Caleb Talbot. All rights reserved.
//

#import "TPPCollectionViewCell.h"
#import "TPPPhotoController.h"

@implementation TPPCollectionViewCell

// here we are making a custom setter

-(void)setPhotoData:(NSDictionary *)photoData{
    _photoData = photoData;
    
    [TPPPhotoController imageForPhoto:photoData size:@"100x100" completion:^(UIImage *image) {
        self.photoView.image = image;
    }];
}

@end
