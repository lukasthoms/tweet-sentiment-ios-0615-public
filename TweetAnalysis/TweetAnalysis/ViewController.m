//
//  ViewController.m
//  TweetAnalysis
//
//  Created by Lukas Thoms on 7/9/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import "ViewController.h"
#import <STTwitterAPI.h>
#import "TweetAnalyizerAPI.h"
#import "TweetDetailViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) NSArray *tweetPolarity;
@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tweetTableView.delegate = self;
    self.tweetTableView.dataSource = self;
    self.searchField.delegate = self;
    [self searchTweetsWithTerm:@"Flatiron School"];
    
    

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell" forIndexPath:indexPath];
    
    if ([self.tweets[indexPath.row][@"text"] length] > 31) {
        NSString *truncatedTweet = [NSString stringWithFormat:@"%@...",[self.tweets[indexPath.row][@"text"] substringToIndex:30]];
        cell.textLabel.text = truncatedTweet;
    } else {
        cell.textLabel.text =self.tweets[indexPath.row][@"text"];
    }
    
    cell.detailTextLabel.text = [self.tweetPolarity[indexPath.row] stringValue];
    NSLog(@"%@", cell.detailTextLabel.text);
    
    return cell;
}

-(void) searchTweetsWithTerm: (NSString*)searchTerm {
    
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"tdkgwbm5wooCEt4ZhbzKuhzaF"
                                                          consumerSecret:@"f7DjYd5lip4sip5EPFzcUyDgzzaLgxVZ0VQY7wX6LCB85VpbU8"
                                                              oauthToken:@"23447493-7wwNbLmeBgA54AoC4sALbvzJECRw1PqRperC1nyvY"
                                                        oauthTokenSecret:@"fUIvdt6xgvglvGPJH2SlM8C5TnZIKsXQPWHm7ixA1Li70"];
    
    [twitter getSearchTweetsWithQuery:searchTerm successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
        self.tweets = statuses;
        NSMutableArray *tweets = [@[] mutableCopy];
        for (NSDictionary *tweet in statuses) {
            NSString *tweetText = [NSString stringWithFormat:@"%@", tweet[@"text"]];
            [tweets addObject:tweetText];
        }
        TweetAnalyizerAPI *analysis = [[TweetAnalyizerAPI alloc] init];
        [analysis getTweetSentimentWithCompletion:tweets completion:^(NSArray *tweetResults) {
            
            NSMutableArray *polarities = [@[] mutableCopy];
            for (NSDictionary *result in tweetResults) {
                NSNumber *polarity = result[@"polarity"];
                [polarities addObject:polarity];
            }
            self.tweetPolarity = polarities;
            [self.tweetTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error.description);
    }];
}

- (IBAction)goButtonPressed:(id)sender {
    [self searchTweetsWithTerm:self.searchField.text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchTweetsWithTerm:self.searchField.text];
    [textField resignFirstResponder];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TweetDetailViewController *destination = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tweetTableView indexPathForSelectedRow];
    destination.tweet = self.tweets[indexPath.row];
    destination.polarity = self.tweetPolarity[indexPath.row];
}




@end
