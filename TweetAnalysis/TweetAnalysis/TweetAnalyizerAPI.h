//
//  TweetAnalyizerAPI.h
//  TweetAnalysis
//
//  Created by Lukas Thoms on 7/9/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetAnalyizerAPI : NSObject

@property (strong, nonatomic) NSArray *responses;

- (void) getTweetSentimentWithCompletion: (NSArray*)tweets completion:(void (^)(NSArray* tweetResults))block;

@end
