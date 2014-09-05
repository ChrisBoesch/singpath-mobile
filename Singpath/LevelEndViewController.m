//
//  LevelEndViewController.m
//  Singpath
//
//  Created by Rishik Bahri on 21/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//


#import "LevelEndViewController.h"
#import "LeveyPopListViewCell.h"
#import "PagedScrollViewController.h"
#import "LevelViewController.h"
#import "PathManager.h"
#import "Paths.h"
#import "SSViewController.h"
#import "LevelManager.h"
#import "Levels.h"
#import "PracticeGameViewController.h"
#import "PracticeLevelViewController.h"
#import "StoryLevelManager.h"
#import "StoryLevelViewController.h"
#import "StoryGameViewController.h"
#import "Story.h"
#import "StoryManager.h"
#import "MainScreenViewController.h"

#define POPLISTVIEW_SCREENINSET 40.
#define POPLISTVIEW_HEADER_HEIGHT 50.
#define RADIUS 5.
// This class is responsible for the level end screen display
@interface LevelEndViewController (private)
- (void)fadeIn;
- (void)fadeOut;
@end

@implementation LevelEndViewController
@synthesize delegate,navController=_navController,pathId=_pathId,currentLevelId=_currentLevelId,nextLvlId=_nextLvlId,storyId=_storyId,storyLevel=_storyLevel;


#pragma mark - initialization & cleaning up
- (id)initWithTitle:(NSString *)aTitle navController:(UINavigationController*)navController  levelId:(NSString*)levelId pathId:(NSString*)pathId storyId:(NSString*)storyId  storyLevel:(StoryLevels*)storyLevel
{
    self.navController=navController;
    self.currentLevelId=levelId;
    self.pathId=pathId;
    self.storyId=storyId;
    self.storyLevel=storyLevel;
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    rect.size.height=300;
    rect.size.width=500;
    rect.origin.x=250;
    rect.origin.y=250;
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *backImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"levelCompleted.png"]];
        [self addSubview:backImg];
        UIButton *homeScreen=[[UIButton alloc] initWithFrame:CGRectMake(0, 150, 200, 40)];
        
        [homeScreen setImage:[UIImage imageNamed:@"gotohome.png"] forState:UIControlStateNormal];
        [self addSubview:homeScreen];
        [homeScreen addTarget:self action:@selector(homeScreenView) forControlEvents:UIControlEventTouchUpInside];
       
        NSArray *allLevels=[StoryLevels getAllLevelsWithPath:self.pathId storyId:self.storyId];
        
        StoryLevels *nextLevel=Nil;
        for(int i=0;i<allLevels.count;i++){
            if([allLevels objectAtIndex:i]==self.storyLevel && i<allLevels.count-1){
                nextLevel=[allLevels objectAtIndex:i+1];
                break;
            }
        }
        if(nextLevel!=Nil){
            nextLevel.completed=YES;
            commitDefaultMOC();
        
        }else{
            Story *st=[Story getStoryWithId:storyId];
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"Completed: %@",st.name]];
        }
        
        
            UIButton *pathScreen=[[UIButton alloc] initWithFrame:CGRectMake(330, 150, 150, 40)];
            [pathScreen setImage:[UIImage imageNamed:@"GoToMenu.png"] forState:UIControlStateNormal];
            [self addSubview:pathScreen];
            [pathScreen addTarget:self action:@selector(storyLevelScreen) forControlEvents:UIControlEventTouchUpInside];
            
            
            UIButton *restartButton=[[UIButton alloc] initWithFrame:CGRectMake(190, 150, 130, 40)];
            [restartButton setImage:[UIImage imageNamed:@"RestartLevel.png"] forState:UIControlStateNormal];
            [self addSubview:restartButton];
            [restartButton addTarget:self action:@selector(storyRestartLevel) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *levelArray=[StoryLevels getAllLevelsWithPath:self.pathId storyId:self.storyId];
        int position=0;
        for(int i=0;i<levelArray.count;i++){
            if([[[levelArray objectAtIndex:i] levelId] isEqualToString:self.currentLevelId]){
                position=i+1;
            }
        }
        if(position<levelArray.count){
            Levels *nextLevel=[levelArray objectAtIndex:position];
            self.nextLvlId=nextLevel.levelId;
            UIButton *nextLevelButton=[[UIButton alloc] initWithFrame:CGRectMake(150, 200, 200, 40)];
            [nextLevelButton setImage:[UIImage imageNamed:@"nextlevel.png"] forState:UIControlStateNormal];
            [self addSubview:nextLevelButton];
            
                [nextLevelButton addTarget:self action:@selector(storyNextLevel) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"Finished %@",self.storyLevel.levelId]];

        }
        
    }
    return self;
}

- (id)initWithTitle:(NSString *)aTitle navController:(UINavigationController*)navController stars:(int)stars levelId:(NSString*)levelId pathId:(NSString*)pathId check:(BOOL)check
{
    
    self.navController=navController;
    self.currentLevelId=levelId;
    self.pathId=pathId;
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    rect.size.height=300;
    rect.size.width=500;
    rect.origin.x=250;
    rect.origin.y=250;
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *backImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"levelCompleted.png"]];
        [self addSubview:backImg];
        UIButton *homeScreen=[[UIButton alloc] initWithFrame:CGRectMake(0, 150, 200, 40)];
        
        [homeScreen setImage:[UIImage imageNamed:@"gotohome.png"] forState:UIControlStateNormal];
        [self addSubview:homeScreen];
        [homeScreen addTarget:self action:@selector(homeScreenView) forControlEvents:UIControlEventTouchUpInside];
             
        UIImageView *star1=[[UIImageView alloc] initWithFrame:CGRectMake(100,210,100,100)];
        
        UIImageView *star2=[[UIImageView alloc] initWithFrame:CGRectMake(200,210,100,100)];
        
        UIImageView *star3=[[UIImageView alloc] initWithFrame:CGRectMake(300,210,100,100)];
        if(stars==0){
            star1.image = [UIImage imageNamed:@"starsincomplete.png"];
            star2.image = [UIImage imageNamed:@"starsincomplete.png"];
            star3.image = [UIImage imageNamed:@"starsincomplete.png"];
        }else if(stars==1){
            star1.image = [UIImage imageNamed:@"starsuccess.png"];
            star2.image = [UIImage imageNamed:@"starsincomplete.png"];
            star3.image = [UIImage imageNamed:@"starsincomplete.png"];
        }else if(stars==2){
            star1.image = [UIImage imageNamed:@"starsuccess.png"];
            star2.image = [UIImage imageNamed:@"starsuccess.png"];
            star3.image = [UIImage imageNamed:@"starsincomplete.png"];
        }else{
            star1.image = [UIImage imageNamed:@"starsuccess.png"];
            star2.image = [UIImage imageNamed:@"starsuccess.png"];
            star3.image = [UIImage imageNamed:@"starsuccess.png"];
        }
        
        
        [self addSubview:star1];
        [self addSubview:star2];
        [self addSubview:star3];
        if(check){
            UIButton *pathScreen=[[UIButton alloc] initWithFrame:CGRectMake(330, 150, 150, 40)];
            [pathScreen setImage:[UIImage imageNamed:@"GoToMenu.png"] forState:UIControlStateNormal];
            [self addSubview:pathScreen];
            [pathScreen addTarget:self action:@selector(pathScreen) forControlEvents:UIControlEventTouchUpInside];
        
        
            UIButton *restartButton=[[UIButton alloc] initWithFrame:CGRectMake(190, 150, 130, 40)];
            [restartButton setImage:[UIImage imageNamed:@"RestartLevel.png"] forState:UIControlStateNormal];
            [self addSubview:restartButton];
            [restartButton addTarget:self action:@selector(restartLevel) forControlEvents:UIControlEventTouchUpInside];
        }else{
            UIButton *pathScreen=[[UIButton alloc] initWithFrame:CGRectMake(330, 150, 150, 40)];
            [pathScreen setImage:[UIImage imageNamed:@"GoToMenu.png"] forState:UIControlStateNormal];
            [self addSubview:pathScreen];
            [pathScreen addTarget:self action:@selector(practicePathScreen) forControlEvents:UIControlEventTouchUpInside];
            
            
            UIButton *restartButton=[[UIButton alloc] initWithFrame:CGRectMake(190, 150, 130, 40)];
            [restartButton setImage:[UIImage imageNamed:@"RestartLevel.png"] forState:UIControlStateNormal];
            [self addSubview:restartButton];
            [restartButton addTarget:self action:@selector(practiceRestartLevel) forControlEvents:UIControlEventTouchUpInside];
        }
        NSArray *levelArray=[Levels getAllLevelsWithPath:self.pathId];
        int position=0;
        for(int i=0;i<levelArray.count;i++){
            if([[[levelArray objectAtIndex:i] levelId] isEqualToString:self.currentLevelId]){
                position=i+1;
            }
        }
        if(position<levelArray.count){
            Levels *nextLevel=[levelArray objectAtIndex:position];
            self.nextLvlId=nextLevel.levelId;
            UIButton *nextLevelButton=[[UIButton alloc] initWithFrame:CGRectMake(150, 200, 200, 40)];
            [nextLevelButton setImage:[UIImage imageNamed:@"nextlevel.png"] forState:UIControlStateNormal];
            [self addSubview:nextLevelButton];
            if(check){
                [nextLevelButton addTarget:self action:@selector(nextLevel) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [nextLevelButton addTarget:self action:@selector(practiceNextLevel) forControlEvents:UIControlEventTouchUpInside];
            }
        }else{
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"finished %@",self.storyLevel.levelId]];

        }
        
          }
    return self;
}
- (id)initWithTitle:(NSString *)aTitle navController:(UINavigationController*)navController levelId:(NSString*)levelId pathId:(NSString*)pathId
{
    self.currentLevelId=levelId;
    self.pathId=pathId;
    self.navController=navController;
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    rect.size.height=300;
    rect.size.width=500;
    rect.origin.x=250;
    rect.origin.y=250;
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *backImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"levelFailed.png"]];
        [self addSubview:backImg];
        UIButton *homeScreen=[[UIButton alloc] initWithFrame:CGRectMake(140, 150, 200, 50)];
        
        [homeScreen setImage:[UIImage imageNamed:@"gotohome.png"] forState:UIControlStateNormal];
        [self addSubview:homeScreen];
        [homeScreen addTarget:self action:@selector(homeScreenView) forControlEvents:UIControlEventTouchUpInside];
  
        UIButton *pathScreen=[[UIButton alloc] initWithFrame:CGRectMake(70, 190, 160, 70)];
        [pathScreen setImage:[UIImage imageNamed:@"GoToMenu.png"] forState:UIControlStateNormal];
        [self addSubview:pathScreen];
        [pathScreen addTarget:self action:@selector(pathScreen) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *restartButton=[[UIButton alloc] initWithFrame:CGRectMake(250, 190, 160, 70)];
        [restartButton setImage:[UIImage imageNamed:@"RestartLevel.png"] forState:UIControlStateNormal];
        [self addSubview:restartButton];
        [restartButton addTarget:self action:@selector(restartLevel) forControlEvents:UIControlEventTouchUpInside];
      
        
      
    }
    return self;
}

-(void)pathScreen
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    LevelViewController* levelViewController = (LevelViewController*)[storyboard instantiateViewControllerWithIdentifier:@"levelViewController"];
    Paths *path=[Paths getPathWithId:self.pathId];
    levelViewController.levelid=self.pathId;
    levelViewController.levelName=path.pathName;
    [TestFlight passCheckpoint:@"settings go to path screen"];
    
    
//    [self.navController pushViewController:levelViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [self.navController pushViewController: levelViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navController.view cache:NO];
    [UIView commitAnimations];
    
    
}
-(void)practicePathScreen
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    PracticeLevelViewController* levelViewController = (PracticeLevelViewController*)[storyboard instantiateViewControllerWithIdentifier:@"practiceLevelViewController"];
    Paths *path=[Paths getPathWithId:self.pathId];
    levelViewController.levelid=self.pathId;
    levelViewController.levelName=path.pathName;
    [TestFlight passCheckpoint:@"settings go to path screen"];
    
    
  //  [self.navController pushViewController:levelViewController animated:YES];
    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [self.navController pushViewController: levelViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navController.view cache:NO];
    [UIView commitAnimations];
    
}
-(void)storyLevelScreen
{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    
    
    StoryLevelViewController* storyLevelViewController = (StoryLevelViewController*) [storyboard instantiateViewControllerWithIdentifier:@"storyLevelViewController"];
    
    storyLevelViewController.storyId=self.storyId;
    Story *currentStory=[Story getStoryWithId:self.storyId];
    storyLevelViewController.storyName=currentStory.name;
    storyLevelViewController.pathid=self.pathId;
    
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
  //  [self.navController pushViewController:storyLevelViewController animated:YES];
    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [self.navController pushViewController: storyLevelViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navController.view cache:NO];
    [UIView commitAnimations];

    
}

-(void)nextLevel
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    SSViewController* ssViewController = (SSViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ssViewController"];
    ssViewController.problemSetId=self.nextLvlId;
    ssViewController.pathID=self.pathId;
    [TestFlight passCheckpoint:@"Settings Restart"];
   // [self.navController pushViewController:ssViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [self.navController pushViewController: ssViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navController.view cache:NO];
    [UIView commitAnimations];

}
-(void)practiceNextLevel
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    PracticeGameViewController* ssViewController = (PracticeGameViewController*)[storyboard instantiateViewControllerWithIdentifier:@"practiceGameViewController"];
    ssViewController.problemSetId=self.nextLvlId;
    ssViewController.pathID=self.pathId;
    [TestFlight passCheckpoint:@"Settings Restart"];
  //  [self.navController pushViewController:ssViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [self.navController pushViewController: ssViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navController.view cache:NO];
    [UIView commitAnimations];
}
-(void)storyNextLevel
{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    StoryGameViewController* storyLevelViewController = (StoryGameViewController*)[storyboard instantiateViewControllerWithIdentifier:@"storyGameViewController"];
    NSArray *allLevels=[StoryLevels getAllLevelsWithPath:self.pathId storyId:self.storyId];
    StoryLevels *nextLevel=Nil;
    for(int i=0;i<allLevels.count;i++){
        if([allLevels objectAtIndex:i]==self.storyLevel && i<allLevels.count-1){
            nextLevel=[allLevels objectAtIndex:i+1];
            break;
        }
    }
    if(nextLevel!=Nil){
        nextLevel.completed=YES;
        commitDefaultMOC();
        storyLevelViewController.storyLevel=nextLevel;
        storyLevelViewController.problemSetId=nextLevel.levelId;
        storyLevelViewController.pathID=[nextLevel pathId];
        
        //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
      //  [self.navController pushViewController:storyLevelViewController animated:YES];
        [UIView  beginAnimations: @"Showinfo"context: nil];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.80];
        [self.navController pushViewController: storyLevelViewController animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navController.view cache:NO];
        [UIView commitAnimations];

    }

}
-(void)restartLevel
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    SSViewController* ssViewController = (SSViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ssViewController"];
    ssViewController.problemSetId=self.currentLevelId;
    ssViewController.pathID=self.pathId;
    [TestFlight passCheckpoint:@"Settings Restart"];
 //   [self.navController pushViewController:ssViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [self.navController pushViewController: ssViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navController.view cache:NO];
    [UIView commitAnimations];

}
-(void)practiceRestartLevel
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    PracticeGameViewController* ssViewController = (PracticeGameViewController*)[storyboard instantiateViewControllerWithIdentifier:@"practiceGameViewController"];
    ssViewController.problemSetId=self.currentLevelId;
    ssViewController.pathID=self.pathId;
    [TestFlight passCheckpoint:@"Settings Restart"];
   // [self.navController pushViewController:ssViewController animated:YES];
    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [self.navController pushViewController: ssViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navController.view cache:NO];
    [UIView commitAnimations];

}
-(void)storyRestartLevel
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    StoryGameViewController* storyLevelViewController = (StoryGameViewController*)[storyboard instantiateViewControllerWithIdentifier:@"storyGameViewController"];
   
        storyLevelViewController.storyLevel=self.storyLevel;
        storyLevelViewController.problemSetId=self.storyLevel.levelId;
        storyLevelViewController.pathID=[self.storyLevel pathId];
        
        //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
    //    [self.navController pushViewController:storyLevelViewController animated:YES];
    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [self.navController pushViewController: storyLevelViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navController.view cache:NO];
    [UIView commitAnimations];

    
}

-(void)homeScreenView{
  /*  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    PagedScrollViewController* itemsViewController = (PagedScrollViewController*)[storyboard instantiateViewControllerWithIdentifier:@"pathViewController"];
    
    
  //  [self.navController popToRootViewControllerAnimated:YES];
    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [self.navController pushViewController: itemsViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navController.view cache:NO];
    [UIView commitAnimations];*/
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    MainScreenViewController* mainScreen = (MainScreenViewController*)[storyboard instantiateViewControllerWithIdentifier:@"mainScreenViewController"];
    
    
    
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
    //[[self navigationController] pushViewController:storyLevelViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [self.navController pushViewController: mainScreen animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navController.view cache:NO];
    [UIView commitAnimations];
    


    
}
#pragma mark - Private Methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
-(void)end
{
    [self fadeOut];
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            
            
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"PopListViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        cell = [[LeveyPopListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity] ;
    }
    int row = [indexPath row];
    cell.textLabel.text = [[_options objectAtIndex:row] objectForKey:@"text"];
    [cell addSubview:[[_options objectAtIndex:row] objectForKey:@"swt"]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - DrawDrawDraw

- (void)drawRect:(CGRect)rect
{
    CGRect bgRect = CGRectInset(rect, POPLISTVIEW_SCREENINSET, POPLISTVIEW_SCREENINSET);
    //  CGREctInse
    
    CGRect titleRect = CGRectMake(POPLISTVIEW_SCREENINSET + 10, POPLISTVIEW_SCREENINSET + 10 + 5,
                                  rect.size.width -  2 * (POPLISTVIEW_SCREENINSET + 10), 30);
    CGRect separatorRect = CGRectMake(POPLISTVIEW_SCREENINSET, POPLISTVIEW_SCREENINSET + POPLISTVIEW_HEADER_HEIGHT - 2,
                                      rect.size.width - 2 * POPLISTVIEW_SCREENINSET, 2);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw the background with shadow
    CGContextSetShadowWithColor(ctx, CGSizeZero, 6., [UIColor colorWithWhite:0 alpha:.75].CGColor);
    [[UIColor colorWithWhite:0 alpha:.75] setFill];
    
    
    float x = POPLISTVIEW_SCREENINSET;
    float y = POPLISTVIEW_SCREENINSET;
    float width = bgRect.size.width;
    float height = bgRect.size.height;
    CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, x, y + RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y, x + RADIUS, y, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y, x + width, y + RADIUS, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y + height, x + width - RADIUS, y + height, RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y + height, x, y + height - RADIUS, RADIUS);
	CGPathCloseSubpath(path);
	CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGPathRelease(path);
    
    // Draw the title and the separator with shadow
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 0.5f, [UIColor blackColor].CGColor);
    [[UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.] setFill];
    [_title drawInRect:titleRect withFont:[UIFont systemFontOfSize:16.]];
    CGContextFillRect(ctx, separatorRect);
}

@end