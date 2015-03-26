//
//  TheatersDataSource.h
//  MovieTimes
//
//  Created by Justin Guarino on 3/25/15.
//  Copyright (c) 2015 JustinGuarino. All rights reserved.
//
//  Based on a modified version of TableViewBeyondBasics Provided by Dr. Ali Kooshesh

#import <Foundation/Foundation.h>
#import "Theater.h"
#import "DownloadAssistant.h"

@protocol DataSourceReadyForUseDelegate;

@interface TheatersDataSource : NSObject<WebDataReadyDelegate>

@property (nonatomic) id<DataSourceReadyForUseDelegate> delegate;
@property (nonatomic) BOOL dataReadyForUse;

-(instancetype) initWithTheatersAtURLString: (NSString *) tURL;
-(Theater *) theaterWithTitle: (NSString *) movieTitle;
-(NSMutableArray *) getAllTheaters;
-(Theater *) theaterAtIndex: (NSInteger) idx;
-(NSInteger) numberOfTheaters;
-(NSString *) theatersTabBarTitle;
-(NSString *) theatersTabBarImage;
-(NSString *) theatersBarButtonItemBackButtonTitle;
-(BOOL) deleteTheaterAtIndex: (NSInteger) idx;


@end

@protocol DataSourceReadyForUseDelegate <NSObject>

@optional

-(void) dataSourceReadyForUse: (TheatersDataSource *) dataSource;

@end
