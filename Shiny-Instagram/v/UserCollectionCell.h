//
//  UserCollectionCell.h
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/12/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Post.h"

@interface UserCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *photoView;
@property (strong, nonatomic) Post * post; 
@end
