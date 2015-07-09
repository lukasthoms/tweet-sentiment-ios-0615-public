//
//  TweetDetailViewController.h
//  TweetAnalysis
//
//  Created by Lukas Thoms on 7/9/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetDetailViewController : UIViewController

@property (strong, nonatomic) NSDictionary *tweet;
@property (strong, nonatomic) NSNumber *polarity;

@end
