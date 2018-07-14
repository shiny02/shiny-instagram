//
//  CommentCell.m
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/12/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import "CommentCell.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "DateTools.h"

@interface CommentCell()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end
@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(Comment*)comment
{
//    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
//    query.limit = 2;
//    //[query orderByDescending:@"createdAt"];
//    //[query includeKey:@"author"];
//    [query whereKey:@"objectId" equalTo:comment.objectId];
//    [query includeKeys:@[@"author", @"createdAt", @"text", @"post"]];
//
//    // fetch data asynchronously
//    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
//        if (comments != nil) {
//            // do something with the array of object returned by the call
//            self.comment = comments[0];
//            self.usernameLabel.text = self.comment.author.username;
//            self.commentLabel.text = self.comment.text;
//            NSLog(@"comment cell loaded :|");
//
//        } else {
//            NSLog(@"Did not work :( - %@", error.localizedDescription);
//        }
//    }];

    _comment = comment;
    self.usernameLabel.text = self.comment.author.username;
    self.commentLabel.text = self.comment.text;
    
    if(self.comment.author[@"profileImage"])
    {
    self.profileView.file = self.comment.author[@"profileImage"];
    [self.profileView loadInBackground];
    }
    else{
        self.profileView.image = [UIImage imageNamed:@"no_profile.png"];
    }
    self.profileView.layer.cornerRadius = self.profileView.frame.size.width / 2;
    self.profileView.clipsToBounds = YES;
    
    
    NSString * ago = [self.comment.createdAt shortTimeAgoSinceNow];
    self.timeLabel.text = ago;
//
//    _comment = comment;
//    self.usernameLabel.text = comment.author.username;
//    self.commentLabel.text = comment.text;
    
}

@end
