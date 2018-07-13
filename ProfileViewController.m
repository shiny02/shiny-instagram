//
//  ProfileViewController.m
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/11/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import "ProfileViewController.h"
#import "FeedCell.h"
#import "Post.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "UIImageView+AFNetworking.h"
#import "UserCollectionCell.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet PFImageView *profileView;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    CGFloat postersByLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - (layout.minimumInteritemSpacing * postersByLine))/postersByLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    if(!self.user){
        self.user = PFUser.currentUser;
    }
    
    if(self.user[@"profileImage"])
    {
        self.profileView.file = self.user[@"profileImage"];
        [self.profileView loadInBackground];
        self.profileView.layer.cornerRadius = self.profileView.frame.size.width / 2;
        self.profileView.clipsToBounds = YES;
    }
    
    self.usernameLabel.text = self.user.username;
    
    [self getUserFeed];
    
    
}

- (void)getUserFeed{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    //[query includeKey:@"author"];
    
    [query whereKey:@"author" equalTo:self.user];
    [query includeKeys:@[@"author", @"createdAt"]];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.userPosts = posts;
            
            [self.collectionView reloadData];
            
        } else {
            NSLog(@"Did not work :( - %@", error.localizedDescription);
        }
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedProfile:(id)sender {
    
    [self openPhotos];
    
    
}

-(void)openPhotos {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    //UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    //newPost.image = [self getPFFileFromImage:image];
    
    self.user[@"profileImage"] = [Post getPFFileFromImage:editedImage];
//
//    newPost.commentCount = @(0);
//
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
        
        if(succeeded)
        {
            NSLog(@"Profile image saved");
            [self dismissViewControllerAnimated:YES completion:^{

                self.profileView.file = self.user[@"profileImage"];
                [self.profileView loadInBackground];
                self.profileView.layer.cornerRadius = self.profileView.frame.size.width / 2;
                self.profileView.clipsToBounds = YES;
                NSLog(@"Image successfully stored");
                
            }];
        }
        else if (error)
        {
            NSLog(@"Profile image not saved :(");
        }
        
        
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    
    //[Post postUserImage: editedImage withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;
    
//    [self dismissViewControllerAnimated:YES completion:^{
//
//        NSLog(@"Image successfully stored");
//
//    }];
}

//-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
//    return self.userPosts.count;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell" forIndexPath:indexPath];
//
//    cell.post = self.userPosts[indexPath.row];
//
//    return cell;
//
//}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    UserCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectionCell" forIndexPath:indexPath];
    
    Post * post = self.userPosts[indexPath.item];
    
 
    cell.photoView.image = nil;
    
    cell.photoView.file = post[@"image"];
    
    [cell.photoView loadInBackground];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userPosts.count;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
