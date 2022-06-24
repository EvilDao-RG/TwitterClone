//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by Gael Rodriguez Gomez on 6/24/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *timeString;
@property (weak, nonatomic) IBOutlet UILabel *dateString;

@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;


@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTweet:self.tweet];
}


- (void)setTweet:(Tweet *)tweet{
    _tweet = tweet;
    
    self.name.text = self.tweet.user.name;
    // Setting up screenName including the @ at the beginning
    NSString *screenName = @"@";
    self.screenName.text = [screenName stringByAppendingString: self.tweet.user.screenName];
    
    self.tweetText.text = [NSString stringWithFormat:@"%@", self.tweet.text ];
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];

    // Setting up a date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    
    // Format to show at date label
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    self.dateString.text = [dateFormatter stringFromDate:self.tweet.creationDate];
    
    // Format to show at time label
    dateFormatter.dateStyle = NSDateFormatterNoStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    self.timeString.text = [dateFormatter stringFromDate:self.tweet.creationDate];
    
    // Setting up the image
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profilePicture.image = [UIImage imageWithData:urlData];
    
    [self refreshData];
}


- (void) refreshData{
    
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    if(self.tweet.favorited){
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    
    if(self.tweet.retweeted){
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    } else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
}



- (IBAction)didTapFavorite:(id)sender {
    if(self.tweet.favorited){
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
    } else {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self favoriteTweet];
    }
    [self refreshData];

}


- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted){
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [self unretweetTweet];
    } else {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [self retweetTweet];
    }
    [self refreshData];
}



- (void)favoriteTweet{
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
    }];
}


- (void)retweetTweet{
    [[APIManager shared] retweet:self.tweet completion: ^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
        }
    }];
}

- (void)unretweetTweet{
    [[APIManager shared] unretweet:self.tweet completion: ^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
        }
    }];
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
