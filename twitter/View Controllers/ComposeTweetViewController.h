//
//  ComposeTweetViewController.h
//  twitter
//
//  Created by Gael Rodriguez Gomez on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeTweetViewControllerDelegate <NSObject>

- (void) didTweet:(Tweet *)tweet;

@end


@interface ComposeTweetViewController : UIViewController
@property (nonatomic, weak) id<ComposeTweetViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString* profilePictureURL;
@end

NS_ASSUME_NONNULL_END
