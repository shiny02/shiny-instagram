//
//  CommentViewController.m
//  Shiny-Instagram
//
//  Created by Youngmin Shin on 7/12/18.
//  Copyright © 2018 Youngmin Shin. All rights reserved.
//

#import "CommentViewController.h"
#import "Comment.h"
#import "CommentCell.h"
#import <ParseUI/ParseUI.h>
#import "PostDetailViewController.h"

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *commentField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PFImageView *profileView;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.profileView.file = PFUser.currentUser[@"profileImage"];
    [self.profileView loadInBackground];
    self.profileView.layer.cornerRadius = self.profileView.frame.size.width / 2;
    self.profileView.clipsToBounds = YES;
    
    [self refreshComments];
    [self.tableView reloadData];
    
    
    
}

-(void)refreshComments{
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    query.limit = 50;
    [query orderByAscending:@"createdAt"];
    //[query includeKey:@"author"];
    [query whereKey:@"post" equalTo:self.post];
    [query includeKeys:@[@"author", @"createdAt", @"text"]];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil) {
            // do something with the array of object returned by the call
            self.comments = comments;
            
            [self.tableView reloadData];
            
        } else {
            NSLog(@"Did not work :( - %@", error.localizedDescription);
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didTapSend:(id)sender {
    if([self.commentField.text isEqualToString:@""]){
        return;
    }
    [Comment postComment:self.commentField.text forPost:self.post withCompletion:^(BOOL worked, NSError * _Nullable __strong error){
        if(worked)
        {
            NSLog(@"Instagram comment successfully loaded to server :D");
           
                self.commentField.text = @"";
                [self refreshComments];
                [self performSegueWithIdentifier:@"detailSegue" sender:sender];
 
        }
        else if (error)
        {
            NSLog(@"Instagram comment failed to load >:(");
        }
    }];
    
    
    
}

-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    
    cell.comment = self.comments[indexPath.row];
    
    return cell;
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"detailSegue"])
    {

        UINavigationController *navigationController = [segue destinationViewController];
        PostDetailViewController *detailViewController = (PostDetailViewController*)navigationController.topViewController;
        
        Post * postToDetail = self.post;
        
        detailViewController.post = postToDetail;
        
    }
}


@end
