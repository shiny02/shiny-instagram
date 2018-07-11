//
//  PostDetailViewController.h
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/10/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Post.h"



@interface PostDetailViewController : UIViewController
@property (strong, nonatomic) Post * post; 
@end
