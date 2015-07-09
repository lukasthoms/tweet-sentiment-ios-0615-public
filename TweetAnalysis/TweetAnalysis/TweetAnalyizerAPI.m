//
//  TweetAnalyizerAPI.m
//  TweetAnalysis
//
//  Created by Lukas Thoms on 7/9/15.
//  Copyright (c) 2015 Lukas Thoms. All rights reserved.
//

#import "TweetAnalyizerAPI.h"

@implementation TweetAnalyizerAPI


- (void) getTweetSentimentWithCompletion: (NSArray*)tweets completion:(void (^)(NSArray* tweetResults))block {
    NSMutableArray *tweetDictionaryArray = [@[] mutableCopy];
    for (NSString *tweet in tweets) {
        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"'*/&#abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@. "] invertedSet];
        NSString *filteredTweet = [[tweet componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        NSDictionary *tweetDictionary = @{@"text":filteredTweet};
        [tweetDictionaryArray addObject:tweetDictionary];
    }
    NSArray *finalTweetArray = tweetDictionaryArray;
    NSDictionary *dataDictionary = @{ @"data": finalTweetArray };
    NSLog(@"Tweet dictionary: %@", dataDictionary);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDictionary options:0 error:nil];
    
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://www.sentiment140.com/api/bulkClassifyJson?appid=luk@stho.ms"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPBody = jsonData;
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.description );
        }
        NSDictionary *analysisResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *tweetDictionaryArray = analysisResponse[@"data"];
        block(tweetDictionaryArray);
    }];
    [dataTask resume];
    
}

@end
