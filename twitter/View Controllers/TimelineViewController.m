//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "HomeTimelineTableViewCell.h"
#import "ComposeTweetViewController.h"
#import "TweetDetailsViewController.h"

@interface TimelineViewController () <ComposeTweetViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *arrayOfTweets;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshingView:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    [self getTimeline];

    
}


- (void) getTimeline{
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = [NSMutableArray arrayWithArray:tweets];
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}


- (void) refreshingView:(UIRefreshControl *)refreshControl{
    [self getTimeline];
    [refreshControl endRefreshing];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTimelineTableViewCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"HomeTimelineTableViewCell"];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    [tweetCell setTweet:tweet];
    return tweetCell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}


- (void) didTweet:(Tweet *)tweet{
    [self.arrayOfTweets addObject:tweet];
    [self.tableView reloadData];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // If user tapped on the compose tweet button
    BOOL isComposeSegue = [segue.identifier isEqualToString:@"ComposeSegue"];
    if(isComposeSegue){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeTweetViewController *composeTweetController = (ComposeTweetViewController *) navigationController.topViewController;
        composeTweetController.delegate = self;
    }
    
    // If user tapped on a tweet
    BOOL isDetailSegue = [segue.identifier isEqualToString:@"DetailSegue"];
    if(isDetailSegue){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

        TweetDetailsViewController *tweetDeatailsViewController = [segue destinationViewController];
        tweetDeatailsViewController.tweet = self.arrayOfTweets[indexPath.row];
        
    }
    
    
}



@end
