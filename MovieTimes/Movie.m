//
//  Movie.m
//  MovieTimes
//
//  Created by Justin Guarino on 3/25/15.
//  Copyright (c) 2015 JustinGuarino. All rights reserved.
//
//  Based on a modified version of TableViewBeyondBasics Provided by Dr. Ali Kooshesh

#import "Movie.h"

enum { VIEW_HEIGHT = 90 };

@interface Movie()

@property (nonatomic) NSMutableDictionary *movieAttrs;

@end

@implementation Movie

-(id) initWithDictionary: (NSDictionary *) dictionary
{
	if( (self = [super init]) == nil )
		return nil;
	self.movieAttrs = [NSMutableDictionary dictionaryWithDictionary: dictionary];
	return self;
}

-(void) addValue: (NSString *) attrVal forAttribute: (NSString *) attrName;
{
	[self.movieAttrs setObject: attrVal forKey: attrName];
}

-(NSString *) getValueForAttribute: (NSString *) attr
{
	return [self.movieAttrs valueForKey: attr ];
}

-(NSString *) title
{
	return [self.movieAttrs valueForKey: @"movieTitle"];
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
    NSMutableAttributedString *title = [[self titleForListEntry] mutableCopy];
    NSMutableAttributedString *director = [[self directorForListEntry] mutableCopy];
    NSMutableAttributedString *genre = [[self genreForListEntry] mutableCopy];
    [title replaceCharactersInRange: NSMakeRange(title.length, 0) withString: @"\n"];
    [director replaceCharactersInRange: NSMakeRange(director.length, 0) withString:@"\n"];
    [title appendAttributedString:director];
    [title appendAttributedString:genre];
    return title;
}

-(NSAttributedString *) titleForListEntry
{
    NSString *title = [self title];

    return [self compose:title withBoldPrefix:@""];
}

-(NSAttributedString *) genreForListEntry {
	NSString *genre = [self getValueForAttribute: @"genre"];
    return [self compose:genre withBoldPrefix:@"Genre"];
}

-(NSAttributedString *) directorForListEntry
{
	NSString *director = [self getValueForAttribute: @"director"];
    
    return [self compose:director withBoldPrefix:@"Director"];
}

-(NSString *) htmlDescriptionForDetailedView
{
	return [self getValueForAttribute:@"description"];
}

-(void) print
{
	NSEnumerator *mEnum = [self.movieAttrs keyEnumerator];
	NSString *attrName;
	while( attrName = (NSString *) [mEnum nextObject] ) {
		NSLog( @"Attribute Name:  %@", attrName );
		NSLog( @"Atrribute Value: %@", [self.movieAttrs objectForKey: attrName] );
	}
}


@end
