//
//  TPPDetailViewController.m
//  PhotoPhun
//
//  Created by Caleb Talbot on 8/16/16.
//  Copyright © 2016 Caleb Talbot. All rights reserved.
//

#import "TPPDetailViewController.h"
#import "TPPPhotoController.h"
#import "TPPCollectionViewController.h"

@interface TPPDetailViewController ()

@end

@implementation TPPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TPPPhotoController imageForPhoto:self.photo size:@"300x300" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.backgroundView addGestureRecognizer:dismiss];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToDismiss)];
    [self.view addGestureRecognizer:swipe];
    
    self.centerView.layer.cornerRadius = 10;
    
    [self downloadTips];
}

-(void) dismiss {
    
    [UIView animateWithDuration:.6 animations:^{self.view.transform = CGAffineTransformMakeScale(.01, .01);
        self.view.alpha = 0;
    }
                     completion:^(BOOL finished) {
                         [self dismissViewControllerAnimated:YES completion:nil];
                         
                     }];
    
}

-(void)swipeToDismiss{
    [UIView animateWithDuration:.6 animations:^{self.view.transform = CGAffineTransformMakeTranslation(400, 0);
    }
                     completion:^(BOOL finished) {
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }];

}

-(void)dismissTips{
    [UIView animateWithDuration:.5 animations:^{self.tipView.alpha = 0;
    }
                     completion:^(BOOL finished) {
                         [self.tipView removeFromSuperview];
                     }];

}

-(void)downloadTips{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *venueID = [self.photo valueForKeyPath:@"response.venue.id"];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.foursquare.com/v2/venues/%@/tips/?oauth_token=%@&v=%@&m=%@", venueID, accessToken, DATA_VERSION_DATE, DATA_FORMAT];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSArray *tipsArray = [responseDictionary valueForKeyPath:@"response.tips.items.text"];
        
        self.tipString = [self formatTips:tipsArray];
    }];
    
    [task resume];
    
}

-(NSString *)formatTips: (NSArray *)tipsArray {
    NSMutableString *tipsString = [[NSMutableString alloc] initWithString:@"Tips:\n\n"];
    
    for(NSString *tip in tipsArray) {
        [tipsString appendString:[NSString stringWithFormat:@"*%@\n\n", tip]];
    }
    return (NSString*)tipsString;
}

-(IBAction)presentTipView{
    
    //this creates a uitextview with the same frame as the centerView
    self.tipView = [[UITextView alloc] initWithFrame:self.centerView.frame];
    self.tipView.backgroundColor = [UIColor orangeColor];
    self.tipView.textColor = [UIColor whiteColor];
    self.tipView.layer.cornerRadius = 10;
    self.tipView.text = self.tipString;
    [self.view addSubview:self.tipView];
    
    self.tipView.editable = false;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTips)];
    [self.tipView addGestureRecognizer:tap];
}

@end
