//
//  FeedCell.m
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/9/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import "FeedCell.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "DateTools.h"

@interface FeedCell()
@property (weak, nonatomic) IBOutlet PFImageView *profileView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation FeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setPost:(Post*)post
{
    _post = post;
    
    self.userName.text = self.post.author.username;
    
    self.caption.text = self.post.caption;
    
  //  [self.photoView setImage:self.post.image];
    
    self.photoView.file = self.post[@"image"];
    [self.photoView loadInBackground];
    

    NSString * ago = [self.post.createdAt timeAgoSinceNow];
    
    self.timeLabel.text = ago;
    
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
    
//    self.photoView.layer.cornerRadius = self.photoView.frame.size.width / 2;
//    self.photoView.clipsToBounds = YES;
}

@end
