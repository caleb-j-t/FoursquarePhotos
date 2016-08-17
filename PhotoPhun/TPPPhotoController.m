//
//  TPPPhotoController.m
//  PhotoPhun
//
//  Created by Caleb Talbot on 8/16/16.
//  Copyright © 2016 Caleb Talbot. All rights reserved.
//

#import "TPPPhotoController.h"
#import "SAMCache.h"

@implementation TPPPhotoController

+(void) imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion {
    
    if(photo == nil || size == nil || completion == nil) {
        NSLog(@"missing argument for imageForPhoto");
        return;
    };
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@%@", [photo valueForKeyPath:@"response.venue.bestPhoto.prefix"], size, [photo valueForKeyPath:@"response.venue.bestPhoto.suffix"]];
    
    //using SAMCache we create a key and make a cachedPhoto for the key
    NSString *key = urlString;
    UIImage *cachedPhoto = [[SAMCache sharedCache] imageForKey:key];
    
    //if the image existed in the cache, then cachedPhoto is not nil and we will just use the cached photo to set the photoView's image, else, we will download the photo, save it to the cache and then set the photoView's image
    if (cachedPhoto){
        completion(cachedPhoto);
    } else {
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSData *data = [[NSData alloc] initWithContentsOfURL:location];
            UIImage *image = [[UIImage alloc] initWithData:data];
            [[SAMCache sharedCache] setImage:image forKey:key];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(image);
            });
        }];
        
        [task resume];
    };

}

@end
