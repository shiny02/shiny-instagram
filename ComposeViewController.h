//
//  ComposeViewController.h
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/9/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITextView *captionField;
@property (strong, nonatomic) UIImage * photo; 

@end
