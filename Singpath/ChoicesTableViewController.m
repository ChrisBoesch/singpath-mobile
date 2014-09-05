//
//  ChoicesTableViewController.m
//  Singpath
//
//  Created by Rishik Bahri on 04/07/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//


#import "ChoicesTableViewController.h"

//This class is is a sub class of SSViewController and acts as a templates for the options table
@implementation ChoicesTableViewController

@synthesize choices = _choices, selectedChoice=_selectedChoice,selectedChoicePosition=_selectedChoicePosition, dragAndDropView = _dragAndDropView,txtView=_txtView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

     
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)setQuestion: (NSString *) question :(NSMutableArray *) options{
    [self.txtView setText:question];
    [self.txtView setFont:[UIFont fontWithName:@"Gill Sans 22.5" size:8.0]];
    
    [self.choices removeAllObjects];
    for(NSString *strs in options){
       [self.choices addObject:strs];
        

    }
    [self.tableView reloadData];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;

}




#pragma mark - Drag and Drop Delegate
-(void)dragAndDropTableViewController:(DragAndDropTableViewController *)ddtvc draggingGestureDidBegin:(UIGestureRecognizer *)gesture forCell:(UITableViewCell *)cell;
{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.selectedChoice =[self.choices objectAtIndex:indexPath.row];  
    self.selectedChoicePosition=[self.choices indexOfObject:self.selectedChoice];

    [self.choices removeObjectAtIndex:[self.choices indexOfObject:self.selectedChoice]];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    
}



-(void)dragAndDropTableViewController:(DragAndDropTableViewController *)ddtvc draggingGestureWillBegin:(UIGestureRecognizer *)gesture forCell:(UITableViewCell *)cell{
    
    UIGraphicsBeginImageContext(cell.contentView.bounds.size);
    [cell.contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:img];
    self.dragAndDropView = [[UIView alloc]initWithFrame:iv.frame];
    [self.dragAndDropView addSubview:iv];
    [self.dragAndDropView setBackgroundColor:[UIColor blueColor]];
    [self.dragAndDropView setCenter:[gesture locationInView:self.view.superview]];
    
    [self.view.superview addSubview:self.dragAndDropView];
}

-(void)dragAndDropTableViewController:(DragAndDropTableViewController *)ddtvc draggingGestureDidMove:(UIGestureRecognizer *)gesture{
    [self.dragAndDropView setCenter:[gesture locationInView:self.view.superview]];
}


-(void)dragAndDropTableViewController:(DragAndDropTableViewController *)ddtvc draggingGestureDidEnd:(UIGestureRecognizer *)gesture{
    
    [self.dragAndDropView removeFromSuperview];
    self.dragAndDropView = nil;
}


-(UIView *)dragAndDropTableViewControllerView:(DragAndDropTableViewController *)ddtvc{
    return self.dragAndDropView;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.choices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:cell action:nil];
    longPress.minimumPressDuration=0.05;
    longPress.delegate = self;
    [cell addGestureRecognizer:longPress];
   
    
    NSString *choice = [self.choices objectAtIndex:indexPath.row];
    
    cell.textLabel.text = choice;
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
