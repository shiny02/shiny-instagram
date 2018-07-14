//
//  Comment.h
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/12/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Post.h"

@interface Comment : PFObject<PFSubclassing>

@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *text;



+ (void) postComment: ( NSString * _Nullable )text forPost: ( Post * _Nullable )post withCompletion: (PFBooleanResultBlock  _Nullable)completion;




@end
