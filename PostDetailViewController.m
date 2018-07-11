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


@interface PostDetailViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *photoView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.authorLabel.text = self.post.author.username;
    
    self.captionLabel.text = self.post.caption;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    self.dateLabel.text = [formatter stringFromDate:self.post.createdAt];
    
    
    self.photoView.file = self.post[@"image"];
    [self.photoView loadInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
