//
//  TPPPhotoController.h
//  PhotoPhun
//
//  Created by Caleb Talbot on 8/16/16.
//  Copyright © 2016 Caleb Talbot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TPPPhotoController : NSObject

+(void) imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion;

@end
