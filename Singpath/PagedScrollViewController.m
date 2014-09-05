//
//  PagedScrollViewController.m
//  Singpath
//
//  Created by Rishik Bahri on 9/8/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "PagedScrollViewController.h"
#import "Paths.h"
#import "PathManager.h"
#import "LevelViewController.h"
#import "AchievementViewController.h"
#import "LevelEndViewController.h"
#import "MainScreenViewController.h"
#import "deepend.h"
// This class handels how the path selector is displayed in challenge mode.
@interface PagedScrollViewController ()

@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation PagedScrollViewController

@synthesize scrollView = _scrollView,backToHome;
@synthesize pageControl;

@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews,tableData=_tableData,currentView=_currentView,paths=_paths,pathIDs=_pathIDs,imageView=_imageView,settingsCheck=_settingsCheck,profileCheck=_profileCheck,heading,backgrond,arrowImg;


#pragma mark -
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
-(void)selectPath: (id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    LevelViewController* levelViewController = (LevelViewController*)[storyboard instantiateViewControllerWithIdentifier:@"levelViewController"];
    
 
    levelViewController.levelid=[self.pathIDs objectAtIndex:self.pageControl.currentPage];
    levelViewController.levelName=[self.tableData objectAtIndex:self.pageControl.currentPage];
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@",[self.tableData objectAtIndex:self.pageControl.currentPage]]];

       [self.paths objectAtIndex:self.pageControl.currentPage];
    
  //  [[self navigationController] pushViewController:levelViewController animated:YES];

    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: levelViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
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

-(void)addProgressBarInFrame:(CGRect)frame withProgress:(CGFloat)progress
{
    float widthOfJaggedBit = 4.0f;
    UIImage * imageA= [[UIImage imageNamed:@"progressBlue.png"] stretchableImageWithLeftCapWidth:widthOfJaggedBit topCapHeight:0.0f];
    UIImage * imageB= [[UIImage imageNamed:@"progressEmpty.png"] stretchableImageWithLeftCapWidth:widthOfJaggedBit topCapHeight:0.0f];
    UIView * progressBar = [[UIView alloc] initWithFrame:frame];
    progressBar.backgroundColor = [UIColor whiteColor];
    UIImageView * imageViewA = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width*progress, frame.size.height)];
    UIImageView * imageViewB = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width*progress, 0.f, frame.size.width - (frame.size.width*progress), frame.size.height)];
    
    
    imageViewA.image = imageA;
    imageViewB.image = imageB;
    // imageViewA.contentStretch = CGRectMake(widthOfJaggedBit, 0, imageA.size.width - 2*widthOfJaggedBit, imageA.size.height) ;
    // imageViewB.contentStretch = CGRectMake(widthOfJaggedBit, 0, imageB.size.width - 2*widthOfJaggedBit, imageB.size.height) ;
    [self.view addSubview:progressBar];
    [progressBar addSubview:imageViewA];
    [progressBar addSubview:imageViewB];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [deepend StopMotion];

    [deepend StartMotion:self.backgrond];
    
    

    
    [self.heading setFont:[UIFont fontWithName:@"QuicksandDash-Regular" size:75.0]];
  //  [self.heading setAdjustsFontSizeToFitWidth:TRUE];
    [backToHome addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchUpInside];

  //  [self addProgressBarInFrame:CGRectMake(20.f, 200.f, 280.f, 50.f) withProgress:.9f];
  //  [self addProgressBarInFrame:CGRectMake(20.f, 300.f, 200.f, 25.f) withProgress:.5f];

  /*  LevelEndViewController *levc=[[LevelEndViewController alloc] initWithTitle:@"lvlEnd" navController:[self navigationController] stars:3 levelId:@"6920764" pathId:@"6920762"];
    levc.delegate = self;
    [levc showInView:self.view animated:YES];
    */
 /*   NSArray *achievementsUnolocked=[NSArray arrayWithObjects:@"Baby Steps",@"connected",@"im_Insider",@"weheartyou",nil];
        AchievementViewController* avc=[[AchievementViewController alloc] initWithTitle:@"" achievements:achievementsUnolocked];
        avc.delegate = self;
        [avc showInView:self.view animated:YES];*/
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
        NSString *imgStr= [NSString stringWithFormat:@"%@.png",[self.tableData objectAtIndex:i]];
        @try{
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
