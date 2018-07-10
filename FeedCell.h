//
//  FeedCell.h
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/9/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Post.h"
@interface FeedCell : UITableViewCell
@property (weak, nonatomic) Post * post;
@end
