//
//  CommentCell.h
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/12/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Comment.h"

@interface CommentCell : UITableViewCell
@property (strong, nonatomic) Comment * comment;
@end
