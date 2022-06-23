//
//  ComposeTweetViewController.m
//  twitter
//
//  Created by Gael Rodriguez Gomez on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "APIManager.h"

@interface ComposeTweetViewController ()
@property (weak, nonatomic) IBOutlet UITextView *postText;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;

@end

@implementation ComposeTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Giving a border with color for the user to see the text view
    self.postText.layer.borderWidth = 3.0f;
    self.postText.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.postText.layer.cornerRadius = 5;
}


- (IBAction)didTapTweet:(id)sender {
    if (self.postText.text != nil){
        [[APIManager shared]postStatusWithText:self.postText.text completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error composing Tweet: %@", error.localizedDescription);
            }
            else{
                [self.delegate didTweet:tweet];
                NSLog(@"Compose Tweet Success!");
            }
        }];
        [self dismissViewControllerAnimated:true completion:nil];
    }
}


- (IBAction)didTapDismiss:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
