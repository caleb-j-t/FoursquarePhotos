//
//  TPPDetailViewController.h
//  PhotoPhun
//
//  Created by Caleb Talbot on 8/16/16.
//  Copyright © 2016 Caleb Talbot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPPDetailViewController : UIViewController

@property NSDictionary *photo;
@property (nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic) IBOutlet UIView *centerView;
@property (nonatomic) IBOutlet UITextView *tipView;
@property (nonatomic) NSString *tipString;

@end
