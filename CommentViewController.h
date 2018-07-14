//
//  CommentViewController.h
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/12/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Post.h"

@interface CommentViewController : UIViewController

@property (strong, nonatomic) Post * post;
@property (strong, nonatomic) NSArray * comments; 

@end
