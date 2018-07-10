//
//  ComposeViewController.m
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/9/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import "ComposeViewController.h"
#import <Parse/Parse.h>

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
