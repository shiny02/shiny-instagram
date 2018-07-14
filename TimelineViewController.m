
//
//  TimelineViewController.m
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/9/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import "TimelineViewController.h"
#import <Parse/Parse.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import "Post.h"
#import "FeedCell.h"
#import "ComposeViewController.h"
#import "PostDetailViewController.h"
#import "InfiniteScrollActivityView.h"
#import "CommentViewController.h"
#import "ProfileViewController.h"


@interface TimelineViewController ()
@property (strong, nonatomic) UIImage * postImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (strong, nonatomic) InfiniteScrollActivityView *loadingMoreView;


@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    


    // Do any additional setup after loading the view.
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshPosts) userInfo:nil repeats:true];
   
    [self refreshPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(refreshPosts) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
//    InfiniteScrollActivityView* self.loadingMoreView; //?
    
    //self.loadingMoreView = [[InfiniteScrollActivityView alloc] init];
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
     self.loadingMoreView.hidden = true;
    [self.tableView addSubview:self.loadingMoreView];

    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
    
    
    
    
}




- (void)refreshPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    //[query includeKey:@"author"];
    [query includeKeys:@[@"author", @"createdAt", @"comments"]];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.posts = [posts mutableCopy];
            [self.refreshControl endRefreshing];
            self.isMoreDataLoading = false;
            //[self.loadingMoreView stopAnimating];
            
            [self.tableView reloadData];
            
        } else {
            NSLog(@"Did not work :( - %@", error.localizedDescription);
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    //clearing account?
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        NSLog(@"Successfully logged out");
    }];
}
- (IBAction)didTapCompose:(id)sender {
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
    
//    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;

    

    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    self.postImage = editedImage;
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Image successfully stored");
        
    [self performSegueWithIdentifier:@"postSegue" sender:nil];
    }];
}

-(void)loadMoreData{
    PFQuery *morePosts = [PFQuery queryWithClassName:@"Post"];
    morePosts.limit = 20;
    [morePosts orderByDescending:@"createdAt"];
    //[query includeKey:@"author"];
    [morePosts includeKeys:@[@"author", @"createdAt", @"comments"]];
    // fetch data asynchronously
    morePosts.skip = [self.posts count];
    [morePosts findObjectsInBackgroundWithBlock:^(NSArray *newPosts, NSError *error) {
        if (newPosts) {
            // do something with the array of object returned by the call
            for(Post *post in newPosts){
                [self.posts addObject:post];
            }
            
            [self.refreshControl endRefreshing];
            self.isMoreDataLoading = false;
            [self.loadingMoreView stopAnimating];
            
            [self.tableView reloadData];
            
        } else {
            NSLog(@"Did not work :( - %@", error.localizedDescription);
        }
    }];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){

        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;

        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;

            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];

            [self loadMoreData];
            
            
        }

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Do some stuff when the row is selected
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell" forIndexPath:indexPath];
    
//    cell.messageText.text = self.posts[indexPath.row][@"text"];
//
//    PFUser *user = self.posts[indexPath.row][@"user"];
//    if (user != nil) {
//        // User found! update username label with username
//        cell.usernameLabel.text = user.username;
//    } else {
//        // No user found, set default username
//        cell.usernameLabel.text = @"🤖";
//    }
//    //    cell.usernameLabel.text = self.messages[indexPath.row][@"user"];
    
    cell.post = self.posts[indexPath.row];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedSender:)];
    singleTap.numberOfTapsRequired = 1;
    [cell.profileView setUserInteractionEnabled:YES];
    [cell.profileView addGestureRecognizer:singleTap];
    
    
    
    return cell;
    
    
    
}

-(void)tapDetectedSender:(FeedCell *) cell{
    [self performSegueWithIdentifier:@"profileSegue" sender:cell];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"postSegue"])
    {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
       // composeController.delegate = self;
        composeController.photoView.image = nil;
        if (self.postImage != nil) {
            [composeController.photoView setImage:self.postImage];
            composeController.photo = self.postImage; 
            NSLog(@"Image loaded");
        }
    }
    else if([[segue identifier] isEqualToString:@"detailSegue"])
    {
        FeedCell * tappedCell = sender;
        NSIndexPath * indexPath = [self.tableView indexPathForCell:tappedCell];
        
        Post * postToDetail = self.posts[indexPath.row];
        PostDetailViewController * postDetailsViewController = [segue destinationViewController];
        postDetailsViewController.post = postToDetail;
        
    }
    else if([[segue identifier] isEqualToString:@"commentSegue"])
    {
        FeedCell * tappedCell = sender;
        NSIndexPath * indexPath = [self.tableView indexPathForCell:tappedCell];
        
        
        UINavigationController *navigationController = [segue destinationViewController];
        CommentViewController *commentViewController = (CommentViewController*)navigationController.topViewController;
        
        Post * postToDetail = self.posts[indexPath.row];
        
        commentViewController.post = postToDetail;
        
    }
    else if([[segue identifier] isEqualToString:@"profileSegue"])
    {
 
        FeedCell * tappedCell = sender;
        NSIndexPath * indexPath = [self.tableView indexPathForCell:tappedCell];
        
       ProfileViewController *profileViewController  = [segue destinationViewController];
        
        PFUser * userToDetail = self.posts[indexPath.row][@"author"];
        
        profileViewController.user = userToDetail;
        
    }


}


@end
