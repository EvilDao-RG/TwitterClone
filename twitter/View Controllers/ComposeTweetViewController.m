//
//  ComposeTweetViewController.m
//  twitter
//
//  Created by Gael Rodriguez Gomez on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "APIManager.h"

@interface ComposeTweetViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *postText;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *characterCount;

@end

@implementation ComposeTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postText.delegate = self;
    // Giving a border with color for the user to see the text view
    self.postText.layer.borderWidth = 3.0f;
    self.postText.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.postText.layer.cornerRadius = 5;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSNumber* characterLimit = @140;
    NSString *postText = [self.postText.text stringByReplacingCharactersInRange:range withString:text];
    
    NSNumber* postLength = [NSNumber numberWithLong:postText.length];
    self.characterCount.text = [NSString stringWithFormat:@"%@/140",postLength];
    
    return postLength < characterLimit;
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


@end
