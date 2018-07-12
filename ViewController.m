//
//  ViewController.m
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/8/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginTapped:(id)sender {
    
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    UIAlertController *alertL = [UIAlertController alertControllerWithTitle:@"Invalid Username/Password"message:@"The username/password field cannot be left blank."preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {// handle cancel response here. Doing nothing will dismiss the view.
    }];

    [alertL addAction:cancelAction];
    
    
    if ([self.username.text isEqual:@""]||[self.password.text isEqual:@""])
    {
        [self presentViewController:alertL animated:YES completion:^{

        }];
    }
    
   
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self presentViewController:alertL animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            // display view controller that needs to shown after successful login
        }
    }];
    
}

- (IBAction)onTap:(id)sender {
    
    [self.view endEditing:YES];
}


- (IBAction)signupTapped:(id)sender {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Username/Password"message:@"The username/password field cannot be left blank."preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {// handle cancel response here. Doing nothing will dismiss the view.
    }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];
    
    if ([self.username.text isEqual:@""]||[self.password.text isEqual:@""])
    {
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }
    // set user properties
    newUser.username = self.username.text;
    //   newUser.email = self.emailField.text;
    newUser.password = self.password.text;
    
    UIAlertController *alertS = [UIAlertController alertControllerWithTitle:@"Problem with login"message:@"There was a problem with logging in the user."preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    // add the cancel action to the alertController
    [alertS addAction:cancelAction];
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            [self presentViewController:alertS animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            // manually segue to logged in view
        }
    }];
    
    
    
    
}



@end
