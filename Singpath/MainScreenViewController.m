//
//  MainScreenViewController.m
//  Singpath
//
//  Created by Rishik on 22/10/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "MainScreenViewController.h"
#import "PracticePathViewController.h"
#import "StoryViewController.h"
#import "PagedScrollViewController.h"
#import "StoreViewController.h"
#import "deepend.h"

//This class is responsible for the main home screen of the app.

@interface MainScreenViewController ()
@end

@implementation MainScreenViewController
@synthesize practice,story,challenge,about,backgrond,store;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [deepend StopMotion];

    [deepend StartMotion:self.backgrond];
    
	// Do any additional setup after loading the view.
    // loads all Menus
    // Checks wheter a button ( menu screen) is pressed
    [practice addTarget:self action:@selector(practiceMode) forControlEvents:UIControlEventTouchUpInside];
    [story addTarget:self action:@selector(storyMode) forControlEvents:UIControlEventTouchUpInside];
    [challenge addTarget:self action:@selector(challengeMode) forControlEvents:UIControlEventTouchUpInside];
    [about addTarget:self action:@selector(aboutUs) forControlEvents:UIControlEventTouchUpInside];
    [store addTarget:self action:@selector(storeButton) forControlEvents:UIControlEventTouchUpInside];

    
    NSLog(@"viewdidload");
    
}

// Used to initialize and redirect to the Store

-(void)storeButton{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    [TestFlight passCheckpoint:@"Store"];

    StoreViewController* storyLevelViewController = (StoreViewController*)[storyboard instantiateViewControllerWithIdentifier:@"storeViewController"];
    
    
    
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
    //[[self navigationController] pushViewController:storyLevelViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: storyLevelViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

// Used to initialize and redirect to the About Us page

-(void)aboutUs{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    [TestFlight passCheckpoint:@"About Us"];

    PracticePathViewController* storyLevelViewController = (PracticePathViewController*)[storyboard instantiateViewControllerWithIdentifier:@"aboutUsViewController"];
    
    
    
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
    //[[self navigationController] pushViewController:storyLevelViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: storyLevelViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

// Used to initialize and redirect to the Practice Mode Page

-(void)practiceMode{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    PracticePathViewController* storyLevelViewController = (PracticePathViewController*)[storyboard instantiateViewControllerWithIdentifier:@"PracticePathViewController"];
    [TestFlight passCheckpoint:@"Practice Mode"];

    
    
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
    //[[self navigationController] pushViewController:storyLevelViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: storyLevelViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

// Used to initialize and redirect to the Challenge Mode Page

-(void)challengeMode{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    PagedScrollViewController* storyLevelViewController = (PagedScrollViewController*)[storyboard instantiateViewControllerWithIdentifier:@"pathViewController"];
    [TestFlight passCheckpoint:@"Challenge Mode"];

    
    
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
    //[[self navigationController] pushViewController:storyLevelViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: storyLevelViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}
// Used to initialize and redirect to the Story Mode Page

-(void)storyMode{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    StoryViewController* storyLevelViewController = (StoryViewController*)[storyboard instantiateViewControllerWithIdentifier:@"storyViewController"];
    
    [TestFlight passCheckpoint:@"Story Mode"];

    
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
    //[[self navigationController] pushViewController:storyLevelViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: storyLevelViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}
// Checks for Memory Warnings (Objective C Template)
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
   
}

// Limit oritentation to Landscape- only if its turned 180 Degrees will the screen flip to the next landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
    
}



@end
