//
//  TweetDetailViewController.m
//  TweetAnalysis
//
//  Created by Lukas Thoms on 7/9/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import "TweetDetailViewController.h"

@interface TweetDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *polarityLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetDisplay;



@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Tweet: %@", self.tweet);
    self.polarityLabel.text = [NSString stringWithFormat:@"Rating: %@",[self.polarity stringValue] ];
    self.authorLabel.text = [NSString stringWithFormat:@"%@", self.tweet[@"user"][@"screen_name"] ];
    self.tweetDisplay.text = self.tweet[@"text"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
