//
//  StoryPathViewController.m
//  Singpath
//
//  Created by Rishik on 19/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "StoryPathViewController.h"
#import "StoryPathManager.h"
#import "StoryPaths.h"
#import "StoryLevelViewController.h"
#import "StoryViewController.h"
#import "deepend.h"
@interface StoryPathViewController ()

@end

@implementation StoryPathViewController

@synthesize pathid=_pathid,pathName=_pathName,tableData=_tableData,pathIds=_pathIds,tableView=_tableView,imgView=_imgView,paths=_paths,levelCompleted=_levelCompleted,storyid=_storyid,storyName=_storyName,backToHome,heading,backgrond;

-(void)goToHome{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    StoryViewController* mainScreen = (StoryViewController*)[storyboard instantiateViewControllerWithIdentifier:@"storyViewController"];
    
    
    
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
    //[[self navigationController] pushViewController:storyLevelViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: mainScreen animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    
    [UIView commitAnimations];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [deepend StopMotion];

    [deepend StartMotion:self.backgrond];

    [backToHome addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.heading setFont:[UIFont fontWithName:@"QuicksandDash-Regular" size:75.0]];
   // [self.heading setAdjustsFontSizeToFitWidth:TRUE];
    self.paths=[StoryPaths getPathsWithStoryId:self.storyid];
    
    //self.levels=[Levels getAllLevelsWithPath:self.levelid];
    
    NSMutableArray *pathNames=[[NSMutableArray alloc] init];
    self.pathIds=[[NSMutableArray alloc] init];
    
//    self.levelCompleted=[[NSMutableArray alloc] init];
    
    for(int i=0;i<self.paths.count;i++){
        StoryPaths *currentPath=[self.paths objectAtIndex:i];
        
        [pathNames addObject:[currentPath pathName]];
        
        
        [self.pathIds addObject:[currentPath pathId]];
        
    }
    self.tableData=[NSArray arrayWithArray:pathNames];
    
    
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
 /*   if([[self.levels objectAtIndex:indexPath.row] completed]){
        Levels *currentLevels=[self.levels objectAtIndex:indexPath.row];
        
        if(currentLevels.stars==0){
            UIImage *cellImage=[UIImage imageNamed:@"levelscompleted0stars.png"];
            cell.backgroundView=[[UIImageView alloc] initWithImage:cellImage];
            cell.selectedBackgroundView=[[UIImageView alloc] initWithImage:cellImage];
            
        }else if(currentLevels.stars==1){
            UIImage *cellImage=[UIImage imageNamed:@"levelscompleted1stars.png"];
            cell.backgroundView=[[UIImageView alloc] initWithImage:cellImage];
            cell.selectedBackgroundView=[[UIImageView alloc] initWithImage:cellImage];
            
        }else if(currentLevels.stars==2)
        {
            UIImage *cellImage=[UIImage imageNamed:@"levelscompleted2stars.png"];
            cell.backgroundView=[[UIImageView alloc] initWithImage:cellImage];
            cell.selectedBackgroundView=[[UIImageView alloc] initWithImage:cellImage];
            
        }else{
            UIImage *cellImage=[UIImage imageNamed:@"levelscompleted3stars.png"];
            cell.backgroundView=[[UIImageView alloc] initWithImage:cellImage];
            cell.selectedBackgroundView=[[UIImageView alloc] initWithImage:cellImage];
            
        }
        
    }else{*/
        UIImage *cellImage=[UIImage imageNamed:@"levelincomplete.png"];
        cell.backgroundView=[[UIImageView alloc] initWithImage:cellImage];
        cell.selectedBackgroundView=[[UIImageView alloc] initWithImage:cellImage];
  //  }
    
    
    
    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    StoryLevelViewController* storyLevelViewController = (StoryLevelViewController*)[storyboard instantiateViewControllerWithIdentifier:@"storyLevelViewController"];
    
    storyLevelViewController.storyId=self.storyid;
    storyLevelViewController.storyName=self.storyName;
    storyLevelViewController.pathid=[self.pathIds objectAtIndex:indexPath.row];
    
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
    //[[self navigationController] pushViewController:storyLevelViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: storyLevelViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

@end

