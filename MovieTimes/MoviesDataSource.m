//
//  MoviesDataSource.m
//  MovieTimes
//
//  Created by Justin Guarino on 3/25/15.
//  Copyright (c) 2015 JustinGuarino. All rights reserved.
//
//  Based on a modified version of TableViewBeyondBasics Provided by Dr. Ali Kooshesh
//

#import "MoviesDataSource.h"
#import "Movie.h"

@interface MoviesDataSource() {
    BOOL _debug;
}

@property (nonatomic, copy) NSString *moviesURLString;
@property (nonatomic) NSData *moviesNSData;
@property (nonatomic) NSMutableArray *allMovies;
@property (nonatomic) DownloadAssistant *downloadAssistant;
@property (nonatomic) Theater *theater;


@end

@implementation MoviesDataSource

-(NSMutableArray *) allMovies
{
    if( ! _allMovies )
        _allMovies = [[NSMutableArray alloc] init];
    return _allMovies;
}

-(instancetype) initWithMoviesAtURLString: (NSString *) mURL andTheater: theater
{
    if( (self = [super init]) == nil )
        return nil;
    self.moviesURLString = mURL;
    self.theater = theater;
    NSLog(@"Movie Theater Init Name: %@", self.theater.title);
    _debug = YES;
    _downloadAssistant = [[DownloadAssistant alloc] init];

    self.downloadAssistant.delegate = self;
    self.dataReadyForUse = NO;

    NSURL *url = [NSURL URLWithString: self.moviesURLString];
    [self.downloadAssistant downloadContentsOfURL:url];

    return self;
}

-(void) processMoviesJSON
{
    NSError *parseError = nil;
    NSArray *jsonString =  [NSJSONSerialization JSONObjectWithData:self.moviesNSData options:0 error:&parseError];
    if( _debug )
        NSLog(@"%@", jsonString);
    if( parseError ) {
        NSLog(@"Badly formed JSON string. %@", [parseError localizedDescription] );
        return;
    }
    for ( NSDictionary *movieTuple in jsonString ) {
        MoviesAtTheater *movie = [[MoviesAtTheater alloc] initWithDictionary:movieTuple];
        if( _debug) [movie print];
        NSLog(@"Movie Tuple Theater Title: %@", self.theater.title);
        if([self.theater.title isEqualToString:movie.theater]){
            [self.allMovies addObject: movie];
             NSLog(@"num movies %@", @([self.allMovies count]));
        }
    }
    self.moviesNSData = nil;
    if( [self.delegate respondsToSelector: @selector( dataSourceReadyForUse:)])
       [self.delegate performSelector: @selector(dataSourceReadyForUse:) withObject:self];
}

-(void) print
{
    for( MoviesAtTheater *m in self.allMovies )
        [m print];
}

-(void) acceptWebData:(NSData *)webData forURL:(NSURL *)url
{
    self.moviesNSData = webData;
    [self processMoviesJSON];
    [self print];
    NSLog(@"Completing printing movies.");
    self.dataReadyForUse = YES;
}


-(Movie *) movieWithTitle: (NSString *) movieTitle
{
    // Not complete...
    
	if(  [self.allMovies count] == 0 )
		return nil;
    for( Movie *movie in self.allMovies )
        if( [movie.title isEqualToString: movieTitle] )
            return movie;
    return nil;
}

-(NSArray *) getAllMovies
{
    return self.allMovies;
}

-(BOOL) deleteMovieAtIndex: (NSInteger) idx
{
    [self.allMovies removeObjectAtIndex:idx];
    return YES;
}

-(MoviesAtTheater *) movieAtIndex: (NSInteger) idx
{
	if( idx >= [self.allMovies count] )
        return nil;
	return [self.allMovies objectAtIndex: idx];
}

-(NSInteger) numberOfMovies
{
	return [self.allMovies count];
}

-(NSString *) moviesTabBarTitle
{
	return @"Movies";
}

-(NSString *) moviesBarButtonItemBackButtonTitle
{
	return @"Movies";
}

-(NSString *) moviesTabBarImage
{
	return @"46-movie2.png";
}

@end
