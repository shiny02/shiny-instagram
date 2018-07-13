//
//  ComposeViewController.m
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/9/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import "ComposeViewController.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "MBProgressHUD.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.photoView setImage:self.photo];
    self.captionField.layer.borderWidth = 5.0f;
    self.captionField.layer.borderColor = [[UIColor grayColor] CGColor];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapShare:(id)sender {
    
    CGSize newSize = CGSizeMake(250, 250);
    self.photo = [self resizeImage:self.photo withSize:newSize];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Post postUserImage: self.photo withCaption: self.captionField.text withCompletion:^(BOOL worked, NSError * _Nullable __strong error){
        if(worked)
        {
            NSLog(@"Instagram post successfully loaded to server :D");
            [self dismissViewControllerAnimated:YES completion:^{
                [hud hideAnimated:YES];
            }];
        }
        else if (error)
        {
            NSLog(@"Instagram post failed to load >:("); 
        }
    }];
    
    
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
