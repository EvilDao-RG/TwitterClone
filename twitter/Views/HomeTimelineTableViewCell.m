//
//  HomeTimelineTableViewCell.m
//  twitter
//
//  Created by Gael Rodriguez Gomez on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "HomeTimelineTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface HomeTimelineTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;

@end


@implementation HomeTimelineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTweet:(Tweet *) tweet{
    _tweet = tweet;
    
    self.name.text = self.tweet.user.name;
    self.screenName.text = self.tweet.user.screenName;
    self.tweetText.text = [NSString stringWithFormat:@"%@", self.tweet.text ];
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.createdAt.text = self.tweet.createdAtString;
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profilePicture.image = [UIImage imageWithData:urlData];
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


- (void)favoriteTweet{
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
}


- (void)retweetTweet{
    
}

@end
