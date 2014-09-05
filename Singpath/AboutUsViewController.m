//
//  AboutUsViewController.m
//  Singpath
//
//  Created by Rishik on 20/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "AboutUsViewController.h"
#import "MainScreenViewController.h"
#import "deepend.h"
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

@synthesize backToHome,heading,backgrond;

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
    [backToHome addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.heading setFont:[UIFont fontWithName:@"QuicksandDash-Regular" size:75.0]];
  //  [self.heading setAdjustsFontSizeToFitWidth:TRUE];

}
-(void)goToHome{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    MainScreenViewController* mainScreen = (MainScreenViewController*)[storyboard instantiateViewControllerWithIdentifier:@"mainScreenViewController"];
    
    
    
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
    //[[self navigationController] pushViewController:storyLevelViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: mainScreen animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
