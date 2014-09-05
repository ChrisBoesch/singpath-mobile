//
//  LevelViewController.m
//  Singpath
//
//  Created by Rishik Bahri on 9/8/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "LevelViewController.h"
#import "SSViewController.h"
#import "LevelManager.h"
#import "Levels.h"
#import "PagedScrollViewController.h"
#import "deepend.h"

//This class handels how the leves are displayed in challenge mode.
@interface LevelViewController ()

@end

@implementation LevelViewController

@synthesize levelid=_levelid,levelName=_levelName,tableData=_tableData,problemSetIds=_problemSetIds,tableView=_tableView,imgView=_imgView,levels=_levels,levelCompleted=_levelCompleted,profileCheck=_profileCheck,backToHome,heading,backgrond;

-(void)goToHome{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    PagedScrollViewController* mainScreen = (PagedScrollViewController*)[storyboard instantiateViewControllerWithIdentifier:@"pathViewController"];
    
    
    

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

    [self.heading setFont:[UIFont fontWithName:@"QuicksandDash-Regular" size:75.0]];
    [backToHome addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchUpInside];

    self.profileCheck=FALSE;
    self.settingsCheck=FALSE;
    
     self.levels=[Levels getAllLevelsWithPath:self.levelid];
    NSMutableArray *levelNames=[[NSMutableArray alloc] init];
     self.problemSetIds=[[NSMutableArray alloc] init];
    self.levelCompleted=[[NSMutableArray alloc] init];
    
    for(int i=0;i<self.levels.count;i++){
        Levels *currentLevel=[self.levels objectAtIndex:i];
        
                 [levelNames addObject:[currentLevel levelName]];
        
        
            [self.problemSetIds addObject:[currentLevel levelId]];
        
    }
    self.tableData=[NSArray arrayWithArray:levelNames];
    
    
    UIImage *pathImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.levelName]];
        if(pathImage){
        [self.imgView setImage:pathImage];
    }else{
        NSString *imgStr= [NSString stringWithFormat:@"%@.png",self.levelName];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *imgPath=[path stringByAppendingPathComponent:imgStr];
        NSData *data = [NSData dataWithContentsOfFile:imgPath];
        [self.imgView setImage:[UIImage imageWithData:data]];
    }
     [self.settingsButton addTarget:self action:@selector(showListView) forControlEvents:UIControlEventTouchUpInside];
    [self.profileButton addTarget:self action:@selector(showListViewProfile) forControlEvents:UIControlEventTouchUpInside];
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
    if([[self.levels objectAtIndex:indexPath.row] completed]){
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
      
    }else{
        UIImage *cellImage=[UIImage imageNamed:@"levelincomplete.png"];
        cell.backgroundView=[[UIImageView alloc] initWithImage:cellImage];
        cell.selectedBackgroundView=[[UIImageView alloc] initWithImage:cellImage];
    }
    

    
    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    SSViewController* ssViewController = (SSViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ssViewController"];
    ssViewController.problemSetId=[self.problemSetIds objectAtIndex:indexPath.row];
    ssViewController.pathID=self.levelid;
     [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: ssViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}


@end
