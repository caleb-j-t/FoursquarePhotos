//
//  TPPCollectionViewController.m
//  PhotoPhun
//
//  Created by Caleb Talbot on 8/3/16.
//  Copyright © 2016 Caleb Talbot. All rights reserved.
//

#import "TPPCollectionViewController.h"
#import "TPPCollectionViewCell.h"

NSString *const DATA_VERSION_DATE = @"20160804";
NSString *const DATA_FORMAT = @"foursquare";

@interface TPPCollectionViewController ()

@end

@implementation TPPCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = @"PhotoPhun";
    
    //Using NSUserDefults to store the access token for Foursquare... BUT usually would treat access token like a password. Read about Keychains!
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [defaults stringForKey:@"accessToken"];
    
    if(self.accessToken == nil) {
        //get token
        
        //access foursquare with simpleauth
        [SimpleAuth authorize:@"foursquare-web" completion:^(id responseObject, NSError *error) {
            NSLog(@"response: %@", responseObject);
            
            NSString *token = responseObject[@"credentials"][@"token"];
            
            // get instance of NSUserDefaults, set the value for key to be the token, then SYNCHRONIZE- don't forget step 3!
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:token forKey:@"accessToken"];
            [defaults synchronize];
            
            [self refreshFourSquare];
        }];
        
    } else {
        [self refreshFourSquare];
    }

}

-(void) refreshFourSquare {
    //use token, get venue data from Foursquare
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat: @"https://api.foursquare.com/v2/users/self/venuelikes/?oauth_token=%@&v=%@&m=%@", self.accessToken, DATA_VERSION_DATE, DATA_FORMAT];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //take the response an turn it into a dictionary using NSJSONSerialization... then I can parse through it
        NSData *data = [[NSData alloc] initWithContentsOfURL: location];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        self.likedArray = [responseDict valueForKeyPath:@"response.venues.items.id"];
        self.venueArray = [[NSMutableArray alloc] init];
        
        for (NSString *venueID in self.likedArray) {
            NSString *urlStringVenue = [[NSString alloc] initWithFormat: @"https://api.foursquare.com/v2/venues/%@?oauth_token=%@&v=%@&m=%@", venueID, self.accessToken, DATA_VERSION_DATE, DATA_FORMAT];
            NSURL *urlVenue = [NSURL URLWithString:urlStringVenue];
            NSURLRequest *requestVenue = [NSURLRequest requestWithURL:urlVenue];
            NSURLSessionDownloadTask *taskVenue = [session downloadTaskWithRequest:requestVenue completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSData *dataVenue = [[NSData alloc] initWithContentsOfURL:location];
                NSDictionary *responseDictVenue = [NSJSONSerialization JSONObjectWithData:dataVenue options:kNilOptions error:nil];
                [self.venueArray addObject: responseDictVenue];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
                
            }];
            [taskVenue resume];
        }
        
    }];
    [task resume];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.venueArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TPPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"PhotoPhunCell" forIndexPath:indexPath];
    
    // Configure the cell - remember we have a custom setter for photoData that grabs the right image and set's it to the image property
    cell.photoData = self.venueArray[indexPath.row];
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *selectedPath = [self.collectionView indexPathsForSelectedItems][0];
        
        NSDictionary *photo = self.venueArray[selectedPath.row];
        TPPDetailViewController *detailView = segue.destinationViewController;
        detailView.photo = photo;
    };
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
