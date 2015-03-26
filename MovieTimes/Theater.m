//
//  Theater.m
//  MovieTimes
//
//  Created by Justin Guarino on 3/25/15.
//  Copyright (c) 2015 JustinGuarino. All rights reserved.
//
//  Based on a modified version of TableViewBeyondBasics Provided by Dr. Ali Kooshesh

#import "Theater.h"

enum { VIEW_HEIGHT = 90 };

@interface Theater()

@property (nonatomic) NSMutableDictionary *theaterAttrs;

@end

@implementation Theater

-(id) initWithDictionary: (NSDictionary *) dictionary
{
    if( (self = [super init]) == nil )
        return nil;
    self.theaterAttrs = [NSMutableDictionary dictionaryWithDictionary: dictionary];
    return self;
}

-(void) addValue: (NSString *) attrVal forAttribute: (NSString *) attrName;
{
    [self.theaterAttrs setObject: attrVal forKey: attrName];
}

-(NSString *) getValueForAttribute: (NSString *) attr
{
    return [self.theaterAttrs valueForKey: attr ];
}

-(NSString *) title
{
    return [self.theaterAttrs valueForKey: @"theaterName"];
}

-(CGSize) sizeOfListEntryView
{
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    return CGSizeMake( bounds.size.width, VIEW_HEIGHT);
}


-(UIImage *)  imageForListEntry
{
    NSString *imageName = [self getValueForAttribute:@"smallImageURL"];
    NSURL *url = [NSURL URLWithString: imageName];
    NSData *iData = [NSData dataWithContentsOfURL: url];
    UIImage *mImage = [UIImage imageWithData: iData];
    return mImage;
}

-(NSString *) imageNameForDetailedView
{
    return [self getValueForAttribute:@"largeImageURL"];
}

-(NSAttributedString *) compose: (NSString *) str withBoldPrefix: (NSString *) prefix
{
    const CGFloat fontSize = 13;
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
    UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
    UIFont *italicFont = [UIFont italicSystemFontOfSize:fontSize];
    UIColor *foregroundColor = [UIColor blackColor];
    
    // Create the attributes
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  regularFont, NSFontAttributeName,
                                  foregroundColor, NSForegroundColorAttributeName, nil];
    
    NSDictionary *boldAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               boldFont, NSFontAttributeName, nil];
    
    NSMutableAttributedString *attrString = nil;
    if( [prefix isEqualToString: @""] ) {
        [attrs setObject:italicFont forKey:NSFontAttributeName];
        attrString = [[NSMutableAttributedString alloc] initWithString:str attributes:attrs];
    } else {
        NSString *text = [NSString stringWithFormat:@"%@: %@", prefix, str];
        attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:attrs];
        NSRange range = NSMakeRange(0, prefix.length);
        [attrString setAttributes:boldAttrs range:range];
    }
    return attrString;
}

-(NSAttributedString *) descriptionForListEntry
{
    NSMutableAttributedString *theaterName = [[self theaterNameForListEntry] mutableCopy];
    NSMutableAttributedString *address = [[self addressForListEntry] mutableCopy];
    [theaterName replaceCharactersInRange: NSMakeRange(theaterName.length, 0) withString: @"\n"];
    [address replaceCharactersInRange: NSMakeRange(address.length, 0) withString:@"\n"];
    [theaterName appendAttributedString:address];
    return theaterName;
}

-(NSAttributedString *) theaterNameForListEntry
{
    NSString *theater = [self title];
    
    return [self compose:theater withBoldPrefix:@""];
}

-(NSAttributedString *) addressForListEntry
{
    NSString *streetAddress = [self getValueForAttribute: @"address"];
    NSString *city = [self getValueForAttribute:@"cityName"];
    NSString *state = [self getValueForAttribute:@"state"];
    NSString *zipCode = [self getValueForAttribute:@"zipCode"];
    NSString *address = [NSString stringWithFormat:@"%@ \r %@ %@ %@", streetAddress, city, state, zipCode];
    
    
    return [self compose:address withBoldPrefix:@"Address"];
}

-(NSString *) htmlDescriptionForDetailedView
{
    return [self getValueForAttribute:@"description"];
}

-(void) print
{
    NSEnumerator *mEnum = [self.theaterAttrs keyEnumerator];
    NSString *attrName;
    while( attrName = (NSString *) [mEnum nextObject] ) {
        NSLog( @"Attribute Name:  %@", attrName );
        NSLog( @"Atrribute Value: %@", [self.theaterAttrs objectForKey: attrName] );
    }
}


@end

