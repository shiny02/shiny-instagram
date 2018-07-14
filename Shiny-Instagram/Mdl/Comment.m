//
//  Comment.m
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/12/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@dynamic post;
@dynamic author;
@dynamic text;

+ (nonnull NSString *)parseClassName {
    return @"Comment";
}

+ (void) postComment: ( NSString * _Nullable )text forPost: ( Post * _Nullable )post withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Comment *newComment = [Comment new];
    //newComment.author = [PFUser currentUser];
    newComment.author = PFUser.currentUser;
    newComment.text = text;
    newComment.post = post;
    int cCount = [post.commentCount intValue] + 1;
    post.commentCount = [NSNumber numberWithInt:cCount];
    
    [newComment saveInBackgroundWithBlock:^(BOOL worked, NSError *error){
        if(worked)
        {
            [post addObject:newComment forKey:@"comments"];
            //[post.comments saveInBa]
            [post saveInBackgroundWithBlock:completion];
        }
    }];

    
}





@end
