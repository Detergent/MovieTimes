//
//  DownloadAssistant.h
//  MovieTimes
//
//  Created by Justin Guarino on 3/25/15.
//  Copyright (c) 2015 JustinGuarino. All rights reserved.
//
//  Based on a modified version of TableViewBeyondBasics Provided by Dr. Ali Kooshesh

#import <Foundation/Foundation.h>

@protocol WebDataReadyDelegate;

@interface DownloadAssistant : NSObject<NSURLConnectionDelegate>

@property (nonatomic) id<WebDataReadyDelegate> delegate;

-(void) downloadContentsOfURL: (NSURL *) url;
-(NSData *) downloadedData;

@end

@protocol WebDataReadyDelegate<NSObject>

@required

-(void) acceptWebData: (NSData *) webData forURL: (NSURL *) url;

@end
