//
//  Theater.h
//  MovieTimes
//
//  Created by Justin Guarino on 3/25/15.
//  Copyright (c) 2015 JustinGuarino. All rights reserved.
//
//  Based on a modified version of TableViewBeyondBasics Provided by Dr. Ali Kooshesh

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Theater : NSObject

-(void) addValue: (NSString *) attrVal forAttribute: (NSString *) attrName;
-(NSString *) getValueForAttribute: (NSString *) attr;
-(void) print;

-(NSString *) title;
-(UIImage *)  imageForListEntry;
-(NSAttributedString *) theaterNameForListEntry;
-(NSString *) imageNameForDetailedView;
-(NSString *) htmlDescriptionForDetailedView;
-(NSAttributedString *) descriptionForListEntry;
-(id) initWithDictionary: (NSDictionary *) dictionary;



@end