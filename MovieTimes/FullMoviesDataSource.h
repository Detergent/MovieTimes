//
//  MoviesDataSource.h
//  MovieTimes
//
//  Created by Justin Guarino on 3/25/15.
//  Copyright (c) 2015 JustinGuarino. All rights reserved.
//
//  Based on a modified version of TableViewBeyondBasics Provided by Dr. Ali Kooshesh
//

#import <Foundation/Foundation.h>
#import "Movie.h"
#import "DownloadAssistant.h"
#import "TheatersDataSource.h"

@protocol DataSourceReadyForUseDelegate;

@interface FullMoviesDataSource : NSObject<WebDataReadyDelegate>

@property (nonatomic) id<DataSourceReadyForUseDelegate> delegate;
@property (nonatomic) BOOL dataReadyForUse;

-(instancetype) initWithMoviesAtURLString: (NSString *) mURL;
-(Movie *) movieWithTitle: (NSString *) movieTitle;
-(NSMutableArray *) getAllMovies;
-(Movie *) movieAtIndex: (NSInteger) idx;
-(NSInteger) numberOfMovies;
-(NSString *) moviesTabBarTitle;
-(NSString *) moviesTabBarImage;
-(NSString *) moviesBarButtonItemBackButtonTitle;
-(BOOL) deleteMovieAtIndex: (NSInteger) idx;


@end