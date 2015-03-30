//
//  MoviesDetailedViewController.m
//  MovieTimes
//
//  Created by Justin Guarino on 3/25/15.
//  Copyright (c) 2015 JustinGuarino. All rights reserved.
//
//  Based on a modified version of TableViewBeyondBasics Provided by Dr. Ali Kooshesh
//

#import "MoviesDetailedViewController.h"
#import "Movie.h"

@interface MoviesDetailedViewController ()

@property(nonatomic) Movie *movie;

@end

enum {IMAGE_LEFT_MARGIN = 60, Y_TOP_OF_IMAGE = 44, DESC_LEFT_MARGIN = 10 };

@implementation MoviesDetailedViewController

- (instancetype) initWithMovie: (Movie *) movie
{
    if( (self = [super init]) == nil )
        return nil;
    
    self.movie = movie;
    self.title = [movie title];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    NSURL *url = [NSURL URLWithString: [self.movie imageNameForDetailedView]];
    NSLog(@"%@", [self.movie imageNameForDetailedView] );
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *movieImage = [UIImage imageWithData:imageData];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:movieImage];
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect imageBound = CGRectMake(IMAGE_LEFT_MARGIN, Y_TOP_OF_IMAGE,
                                   appFrame.size.width - 2 * IMAGE_LEFT_MARGIN, appFrame.size.height / 2);
    imageView.frame  = imageBound;
    [self.view addSubview:imageView];
    CGRect descBound = CGRectMake(DESC_LEFT_MARGIN, Y_TOP_OF_IMAGE + imageBound.size.height, appFrame.size.width - 2 * DESC_LEFT_MARGIN, appFrame.size.height - Y_TOP_OF_IMAGE - imageBound.size.height);

    imageBound.origin.y += imageBound.size.height;
    UIWebView *descWebView = [[UIWebView alloc] initWithFrame: descBound];
    [descWebView loadHTMLString:[self.movie htmlDescriptionForDetailedView] baseURL:nil];
    
    [self.view addSubview:descWebView];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
