//
//  TimelineViewController.m
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/9/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import "TimelineViewController.h"
#import <Parse/Parse.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import "Post.h"
#import "FeedCell.h"
#import "ComposeViewController.h"

@interface TimelineViewController ()
@property (strong, nonatomic) UIImage * postImage;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    //clearing account?
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        NSLog(@"Successfully logged out");
    }];
}
- (IBAction)didTapCompose:(id)sender {
    [self openPhotos];
    
    
    
    
}

-(void)openPhotos {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
//    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;

    

    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    //UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    self.postImage = editedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    
    //[Post postUserImage: editedImage withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Image successfully stored");
        
      
        [self performSegueWithIdentifier:@"postSegue" sender:nil];
    }];
}



-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell" forIndexPath:indexPath];
    
//    cell.messageText.text = self.posts[indexPath.row][@"text"];
//
//    PFUser *user = self.posts[indexPath.row][@"user"];
//    if (user != nil) {
//        // User found! update username label with username
//        cell.usernameLabel.text = user.username;
//    } else {
//        // No user found, set default username
//        cell.usernameLabel.text = @"🤖";
//    }
//    //    cell.usernameLabel.text = self.messages[indexPath.row][@"user"];
    return cell;
    
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"postSegue"])
    {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
       // composeController.delegate = self;
        composeController.photoView.image = nil;
        if (self.postImage != nil) {
            [composeController.photoView setImage:self.postImage];
            composeController.photo = self.postImage; 
            NSLog(@"Image loaded");
        }
    }
}


@end
