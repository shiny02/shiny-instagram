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
    
}

@end
