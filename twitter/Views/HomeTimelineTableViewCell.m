//
//  HomeTimelineTableViewCell.m
//  twitter
//
//  Created by Gael Rodriguez Gomez on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "HomeTimelineTableViewCell.h"
#import "UIImageView+AFNetworking.h"

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

@end
