//
//  StoryLevelViewController.m
//  Singpath
//
//  Created by Rishik on 19/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "StoryLevelViewController.h"
#import "StoryLevels.h"
#import "StoryLevelManager.h"
#import "StoryPathViewController.h"
#import "deepend.h"
@interface StoryLevelViewController ()

@end

@implementation StoryLevelViewController
@synthesize levels=_levels,pathid=_pathid,storyLevelGridViewController,storyName=_storyName,storyId=_storyId,homeButton,heading,backgrond;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)pathScreenView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    StoryPathViewController* pathViewController = (StoryPathViewController*)[storyboard instantiateViewControllerWithIdentifier:@"storyPathViewController"];
    
    
    pathViewController.storyName=self.storyName;
    pathViewController.storyid=self.storyId;
    
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@",[self.tableData objectAtIndex:self.pageControl.currentPage]]];
    
    //[self.stories objectAtIndex:self.pageControl.currentPage];
    
 //   [[self navigationController] pushViewController:pathViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: pathViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [deepend StopMotion];

    [deepend StartMotion:self.backgrond];

    [homeButton addTarget:self action:@selector(pathScreenView) forControlEvents:UIControlEventTouchUpInside];
    [self.heading setFont:[UIFont fontWithName:@"QuicksandDash-Regular" size:75.0]];
   // [self.heading setAdjustsFontSizeToFitWidth:TRUE];
	// Do any additional setup after loading the view.
    self.levels=[StoryLevels getAllLevelsWithPath:[NSString stringWithFormat:@"%@",self.pathid] storyId:[NSString stringWithFormat:@"%@",self.storyId]];
    NSLog(@"%i",self.levels.count);
    for(int i=0;i<self.levels.count;i++){
        StoryLevels *s=[self.levels objectAtIndex:i];
        NSLog(@"%@ - %@ - %i - %@ - %@",s.levelId,s.levelName,s.levelNumber,s.pathId,s.storyId);
    }
    
    storyLevelGridViewController.navController=self.navigationController;
    storyLevelGridViewController.levelNameArray=[[NSMutableArray alloc] init];
    storyLevelGridViewController.completedArray=[[NSMutableArray alloc] init];
   storyLevelGridViewController.levelIdArray =[[NSMutableArray alloc] init];
    storyLevelGridViewController.videoArray=[[NSMutableArray alloc] init];
    storyLevelGridViewController.levelsArray=[NSArray arrayWithArray:self.levels];
    for(int i=0;i<self.levels.count;i++){
        StoryLevels *currentLevel=[self.levels objectAtIndex:i];
        [storyLevelGridViewController.levelNameArray addObject:currentLevel.levelName];
        [storyLevelGridViewController.levelIdArray addObject:currentLevel.levelId];
        
        if(currentLevel.completed){
            [storyLevelGridViewController.completedArray addObject:@"True"];
        }else{
            [storyLevelGridViewController.completedArray addObject:@"False"];
        }
        if(currentLevel.video){
            [storyLevelGridViewController.videoArray addObject:@"True"];
        }else{
            [storyLevelGridViewController.videoArray addObject:@"False"];
        }
            
    }
    [storyLevelGridViewController.collectionView reloadData];
    UIImage *pathImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.storyName]];
    if(!pathImage){
        NSString *imgStr= [NSString stringWithFormat:@"%@.png",self.storyName];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *imgPath=[path stringByAppendingPathComponent:imgStr];
        NSData *data = [NSData dataWithContentsOfFile:imgPath];
        pathImage=[UIImage imageWithData:data];

    }
    [self.imgView setImage:pathImage];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
