//
//  TheaterTableViewController.m
//  MovieTimes
//
//  Created by Justin Guarino on 3/25/15.
//  Copyright (c) 2015 JustinGuarino. All rights reserved.
//
//  Based on a modified version of TableViewBeyondBasics Provided by Dr. Ali Kooshesh

#import "TheatersTableViewController.h"
#import "TheatersDataSource.h"
#import "MoviesTableViewController.h"

@interface TheatersTableViewController ()

@property(nonatomic) TheatersDataSource *dataSource;
@property(nonatomic) UIActivityIndicatorView *activityIndicator;


@end

enum { THEATER_VIEW_HEIGHT = 90, GAP_BTWN_VIEWS = 5, IMAGE_HEIGHT = 80, IMAGE_WIDTH = 80 };

static NSString *CellIdentifier = @"Cell";

@implementation TheatersTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    self.title = @"Theaters";
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    NSString *theatersURLString = @"http://www.cs.sonoma.edu/~jguarino/cs470/movies/dbInterface.py?rType=movieTheaters";
    
    self.dataSource = [[TheatersDataSource alloc] initWithTheatersAtURLString:theatersURLString];
    self.dataSource.delegate = self;
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setCenter: self.view.center];
    [self.view addSubview: self.activityIndicator];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dataSourceReadyForUse:(TheatersDataSource *) dataSource
{
    [self.tableView reloadData];
    [self.activityIndicator stopAnimating];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if( ! [self.dataSource dataReadyForUse] ) {
        [self.activityIndicator startAnimating];
        [self.activityIndicator setHidesWhenStopped: YES];
    }
    return 1;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return THEATER_VIEW_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"Number of rows in the table: %@", @([self.dataSource numberOfTheaters]));
    return [self.dataSource numberOfTheaters];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell = [self theaterViewForIndex:[indexPath row] withTableViewCell:cell];
    
    return cell;
}

-(void) refreshTableView: (UIRefreshControl *) sender
{
    [self.tableView reloadData];
    [sender endRefreshing];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataSource deleteTheaterAtIndex:[indexPath row]];
    [self.tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Theater *theater = [self.dataSource theaterAtIndex:[indexPath row]];
    MoviesTableViewController *mtCont = [[MoviesTableViewController alloc] initWithTheater: theater];
    [self.navigationController pushViewController:mtCont animated:YES];
}

-(UITableViewCell *) theaterViewForIndex: (NSInteger) rowIndex withTableViewCell: (UITableViewCell *) cell
{
    enum {IMAGE_VIEW_TAG = 20, MAIN_VIEW_TAG = 50, LABEL_TAG = 30};
    
    Theater *theater = [self.dataSource theaterAtIndex: rowIndex];
    UIView *view = [cell viewWithTag: MAIN_VIEW_TAG];
    
    if( view ) {
        UIImageView *iv = (UIImageView *)[view viewWithTag: IMAGE_VIEW_TAG];
        NSArray *views = [iv subviews];
        for( UIView *v in views )
            [v removeFromSuperview];
        UILabel *aLabel = (UILabel *) [view viewWithTag: LABEL_TAG];
        aLabel.attributedText = [theater descriptionForListEntry];
        return cell;
    }
    
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    CGRect viewFrame = CGRectMake(0, 0, bounds.size.width, THEATER_VIEW_HEIGHT);
    
    UIView *thisView = [[UIView alloc] initWithFrame: viewFrame];

    
    UILabel *theaterInfoLabel = [[UILabel alloc]
                               initWithFrame:CGRectMake(20, 5,
                                                        viewFrame.size.width - IMAGE_WIDTH - 10,
                                                        viewFrame.size.height -5)];
    
    theaterInfoLabel.tag = LABEL_TAG;
    NSAttributedString *desc = [theater descriptionForListEntry];
    theaterInfoLabel.attributedText = desc;
    theaterInfoLabel.numberOfLines = 0;
    [thisView addSubview: theaterInfoLabel];
    thisView.tag = MAIN_VIEW_TAG;
    [[cell contentView] addSubview:thisView];
    
    return cell;
}

@end
