//
//  MoviesDetailedViewController.h
//  MovieTimes
//
//  Created by Justin Guarino on 3/25/15.
//  Copyright (c) 2015 JustinGuarino. All rights reserved.
//
//  Based on a modified version of TableViewBeyondBasics Provided by Dr. Ali Kooshesh
//

#import <UIKit/UIKit.h>
#import "Movie.h"   

@interface MoviesDetailedViewController : UIViewController

- (instancetype) initWithMovie: (Movie *) movie;

@end
