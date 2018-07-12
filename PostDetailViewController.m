//
//  PostDetailViewController.m
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/10/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import "PostDetailViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "DateTools.h"
#import "ProfileViewController.h"


@interface PostDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *photoView;
@property (weak, nonatomic) IBOutlet PFImageView *profileView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;


@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    
    self.usernameLabel.text = self.post.author.username;
    
    self.captionLabel.text = self.post.caption;
    
    //  [self.photoView setImage:self.post.image];
    
    self.photoView.file = self.post[@"image"];
    [self.photoView loadInBackground];
    
    
    if(self.post.author[@"profileImage"])
    {
        self.profileView.file = self.post.author[@"profileImage"];
        [self.profileView loadInBackground];
        
    }
    else
    {
        self.profileView.image = [UIImage imageNamed:@"no_profile.png"];
    }
    
    self.profileView.layer.cornerRadius = self.profileView.frame.size.width / 2;
    self.profileView.clipsToBounds = YES;
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    self.dateLabel.text = [formatter stringFromDate:self.post.createdAt];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    

    


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"profileSegue"])
    {
      
        
//        UINavigationController *navigationController = [segue destinationViewController];
//        ProfileViewController *profileViewController = (ProfileViewController*)navigationController.topViewController;
        
        ProfileViewController *profileViewController = [segue destinationViewController];
        
        profileViewController.user = self.post.author;

    }
}


@end
