//
//  PracticePathViewController.m
//  Singpath
//
//  Created by Rishik on 15/10/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//


#import "PracticePathViewController.h"
#import "Paths.h"
#import "PathManager.h"
#import "PracticeLevelViewController.h"
#import "AchievementViewController.h"
#import "LevelEndViewController.h"
#import "MainScreenViewController.h"
#import "deepend.h"

@interface PracticePathViewController ()

@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation PracticePathViewController

@synthesize scrollView = _scrollView,backToHome;
@synthesize pageControl;

@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews,tableData=_tableData,currentView=_currentView,paths=_paths,pathIDs=_pathIDs,imageView=_imageView,settingsCheck=_settingsCheck,profileCheck=_profileCheck,heading,backgrond,arrowImg;


#pragma mark -


// Puts all the possiple paths in the scrollview
- (void)loadVisiblePages {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    self.pageControl.currentPage = page;
    
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        return;
    }
    
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        
        frame.origin.y = 0.0f;
        
        
        UIImage *redButtonImage = [self.pageImages objectAtIndex:page];
        UIButton *redButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGRect frame2= CGRectMake(0, 0, 370, 450);
        frame2.origin.x=frame.size.width *page+330;
        frame.origin.y=0.0f;
        
        
        redButton.frame = frame2;
        
        [redButton setImage:redButtonImage forState:UIControlStateNormal];
        redButton.clipsToBounds=NO;
        [redButton addTarget:self action:@selector(selectPath:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:redButton];
        [self.pageViews replaceObjectAtIndex:page withObject:redButton];
    }
}

// Checks wether path is clicked on, if so- move to the levels screen with animation

-(void)selectPath: (id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    PracticeLevelViewController* levelViewController = (PracticeLevelViewController*)[storyboard instantiateViewControllerWithIdentifier:@"practiceLevelViewController"];
    
    
    levelViewController.levelid=[self.pathIDs objectAtIndex:self.pageControl.currentPage];
    levelViewController.levelName=[self.tableData objectAtIndex:self.pageControl.currentPage];
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@",[self.tableData objectAtIndex:self.pageControl.currentPage]]];
    [self.paths objectAtIndex:self.pageControl.currentPage];
    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: levelViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
   // [[self navigationController] pushViewController:levelViewController animated:YES];
    
    
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        return;
    }
    
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}



-(void)goToHome{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    MainScreenViewController* mainScreen = (MainScreenViewController*)[storyboard instantiateViewControllerWithIdentifier:@"mainScreenViewController"];
    
    
    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: mainScreen animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [deepend StopMotion];

    [deepend StartMotion:self.backgrond];

    [self.heading setFont:[UIFont fontWithName:@"QuicksandDash-Regular" size:75.0]];
    [backToHome addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchUpInside];

    
    
    self.paths=[Paths getAllPaths];
    NSMutableArray *pathNames=[[NSMutableArray alloc] init];
    NSMutableArray *pathIds=[[NSMutableArray alloc] init];
    
    for(int i=0;i<self.paths.count;i++){
        Paths *currentPath=[self.paths objectAtIndex:i];
        
        if([currentPath downloaded]){
            [pathNames insertObject:[currentPath pathName] atIndex:0];
            [pathIds insertObject:[currentPath pathId] atIndex:0];
        }else{
            [pathNames addObject:[currentPath pathName]];
            [pathIds addObject:[currentPath pathId]];
            
        }
    }
    self.pathIDs=[NSArray arrayWithArray:pathIds];
    self.tableData=[NSArray arrayWithArray:pathNames];
    
    
    
    self.title = @"Singpath";
    
    NSMutableArray *something=[[NSMutableArray alloc] init];
    for(int i=0;i<[self.tableData count];i++){
        @try{
        NSString *imgStr= [NSString stringWithFormat:@"%@.png",[self.tableData objectAtIndex:i]];
        
        [something addObject: [UIImage imageNamed:imgStr]];
        }@catch (NSException * e) {
            NSString *imgStr= [NSString stringWithFormat:@"%@.png",[self.tableData objectAtIndex:i]];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *imgPath=[path stringByAppendingPathComponent:imgStr];
            NSData *data = [NSData dataWithContentsOfFile:imgPath];
            [something addObject:[UIImage imageWithData:data]];
        }
    }
    self.pageImages= [NSArray arrayWithArray:something];
    if(something.count>1){
        
        CGRect otherFrame=self.arrowImg.frame;
        otherFrame.origin.x=arrowImg.frame.size.width+900;
        
        
        [UIView animateWithDuration:2
                              delay:1
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             self.arrowImg.frame= otherFrame;
                             
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                         }];
    }else{
        [arrowImg removeFromSuperview];
    }
    
    NSInteger pageCount = self.pageImages.count;
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    
    
    [self.settingsButton addTarget:self action:@selector(showListView) forControlEvents:UIControlEventTouchUpInside];
    [self.profileButton addTarget:self action:@selector(showListViewProfile) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    self.settingsCheck=FALSE;
    self.profileCheck=FALSE;
   
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    [self loadVisiblePages];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.scrollView = nil;
    self.pageControl = nil;
    self.pageImages = nil;
    self.pageViews = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self loadVisiblePages];
}
-(IBAction) pageChanged:(id)sender
{
    int page = pageControl.currentPage;
    
    // update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

@end
