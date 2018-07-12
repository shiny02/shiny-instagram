//
//  ProfileViewController.h
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/11/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>



@interface ProfileViewController : UIViewController
@property (strong, nonatomic) PFUser * user;
@property (strong, nonatomic) NSArray * userPosts;
@end
