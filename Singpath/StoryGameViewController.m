//
//  StoryGameViewController.m
//  Singpath
//
//  Created by Rishik on 19/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "StoryGameViewController.h"
#import "LevelEndViewController.h"
#import "AchievmentManager.h"
#import "Achievments.h"
#import "AchievementViewController.h"
#import "StoryLevelManager.h"
#import "StoryLevelViewController.h"
#import "Story.h"
#import "StoryManager.h"
#import "MainScreenViewController.h"
#import "Settings.h"
#import "SettingsManager.h"
#import "deepend.h"
@implementation StoryGameViewController

@synthesize questionChecker,choicesViewController, selectedChoicesViewController,problemSetId=_problemSetId,pathID=_pathID,compileButton=_compileButton,nonCompilableTries=_nonCompilableTries,compilableWrongTries=_compilableWrongTries,settingsCheck=_settingsCheck,consoleCheck=_consoleCheck,hintCheck=_hintCheck,progressLabel=_progressLabel,consoleView=_consoleView,consoleImg=_consoleImg,consoleTableViewController,consoleCorrectViewController,consoleExpectedViewController,consoleRecievedViewController,hintView=_hintView,hintImg=_hintImg,hintTxt=_hintTxt,progressImg=_progressImg,callLabel=_callLabel,expectedLabel=_expectedLabel,recievedLabel=_recievedLabel,correctLabel=_correctLabel,errorLabel=_errorLabe,storyLevel=_storyLevel,moviePlayer,settingsView,homeScreen,pathScreen,restartButton,autoAdvance,autoComplete,backgrond;
#define DegreesToRadians(degrees) ((degrees * M_PI) / 180.0)
;





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


//-(IBAction)nextQuestion:(id)sender{
-(void)nextQuestions{
    self.hintCheck=FALSE;
    
    [self animateSwingBack];
    [self.settingsButton setImage:[UIImage imageNamed:@"gamesettingsunclicked.png"] forState:UIControlStateNormal];
    self.settingsCheck=FALSE;
    
    self.consoleCheck=FALSE;
    
    if([questionChecker counter]+1<=[[questionChecker questions] count] ){
        
        NSString* feed=[questionChecker feedback:[selectedChoicesViewController selectedChoices]];
        if([feed isEqualToString:@"Correct!"]){
            [feedbackButton setBackgroundColor:[UIColor clearColor]];
            [self.compileButton setImage:[UIImage imageNamed:@"submitneutral.png"] forState:UIControlStateNormal];
            
            
            
        }else if([feed isEqualToString:@"Uncompilable!"]){
            [feedbackButton setBackgroundColor:[UIColor redColor]];
            [self.compileButton setImage:[UIImage imageNamed:@"submitred.png"] forState:UIControlStateNormal];
            self.nonCompilableTries=self.nonCompilableTries+1;
            
            
            
        }else{
            [feedbackButton setBackgroundColor:[UIColor yellowColor]];
            [self.compileButton setImage:[UIImage imageNamed:@"submitblue.png"] forState:UIControlStateNormal];
            if([autoComplete isOn]){
                [self consoleOut];
            }
            [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self
                                           selector: @selector(consoleIn) userInfo: nil repeats: NO];
            self.compilableWrongTries=self.compilableWrongTries+1;
            
            
            
        }
    }
    if([questionChecker isCorrect:[selectedChoicesViewController selectedChoices]] && [autoAdvance isOn]){
        if([questionChecker counter]+1>=[[questionChecker questions] count]){
            [incorrectTxt setText:@"No more questions"];
            [self consoleIn];
            [self hintIn];
            
            LevelEndViewController *levc=[[LevelEndViewController alloc] initWithTitle:@"lvlEnd" navController:[self navigationController] levelId:self.problemSetId pathId:self.pathID storyId:self.storyLevel.storyId  storyLevel:self.storyLevel];
            
            
            
            
            
            
            levc.delegate = self;
            [levc showInView:self.view animated:YES];
            
            [self.compileButton setEnabled:NO];
            [self.hintButton setEnabled:NO];
            [self.consoleButton setEnabled:NO];
            [self.settingsButton setEnabled:NO];
            
            
        }else{
            
            
            
            [incorrectTxt setText:@""];
            [self.compileButton setImage:[UIImage imageNamed:@"submitneutral.png"] forState:UIControlStateNormal];
            
            [self hintIn];
            [self consoleIn];
            
            
            
            [questionChecker setCounter:[questionChecker counter]+1];
            float progress=1.0/[[questionChecker questionId] count];
            /*  [self addProgressBarInFrame:CGRectMake(302.f, 25.f, 466.f, 26.f) withProgress:progress*([questionChecker counter]+1)];*/
            //   self.progressLabel=[[UILabel alloc] initWithFrame:CGRectMake(510, 32, 100, 10)];
            [self.progressLabel setText:[NSString stringWithFormat:@"%i/%i",[questionChecker counter]+1,[[questionChecker questions] count]]];
            /*
             [self.progressLabel setBackgroundColor:[UIColor clearColor]];
             [self.progressLabel setTextColor:[UIColor whiteColor]];*/
            /*    [self.view addSubview:self.progressLabel];
             [self.view bringSubviewToFront:self.progressLabel];*/
            CGRect progressFrame = self.progressImg.frame;
            progressFrame.size.width = (progressOriginalFrame.size.width/[[questionChecker questions] count])*([questionChecker counter]+1);
            [UIView animateWithDuration:0.5
                                  delay:0
                                options: UIViewAnimationCurveEaseIn
                             animations:^{
                                 self.progressImg.frame = progressFrame;
                                 
                             }
                             completion:^(BOOL finished){
                                 NSLog(@"Done!");
                             }];
            
            [choicesViewController setQuestion:[questionChecker getQuestion:[questionChecker counter]] :[questionChecker getSelectedOptions:[questionChecker counter]]];
            [selectedChoicesViewController reloadData];
        }
        
    }else{
        
    }
    
    
}
-(void)nextQuestions1{
    self.hintCheck=FALSE;
    
    [self animateSwingBack];
    
    [self.settingsButton setImage:[UIImage imageNamed:@"gamesettingsunclicked.png"] forState:UIControlStateNormal];
    self.settingsCheck=FALSE;
    
    self.consoleCheck=FALSE;
    
    if([questionChecker counter]+1<=[[questionChecker questions] count]){
        
        NSString* feed=[questionChecker feedback:[selectedChoicesViewController selectedChoices]];
        if([feed isEqualToString:@"Correct!"]){
            [feedbackButton setBackgroundColor:[UIColor clearColor]];
            [self.compileButton setImage:[UIImage imageNamed:@"submitneutral.png"] forState:UIControlStateNormal];
            
            
            
        }else if([feed isEqualToString:@"Uncompilable!"]){
            [feedbackButton setBackgroundColor:[UIColor redColor]];
            if([selectedChoicesViewController selectedChoices].count>0){
                [self.compileButton setImage:[UIImage imageNamed:@"submitred.png"] forState:UIControlStateNormal];
            }
            self.nonCompilableTries=self.nonCompilableTries+1;
            
            
            
        }else{
            [feedbackButton setBackgroundColor:[UIColor yellowColor]];
            [self.compileButton setImage:[UIImage imageNamed:@"submitblue.png"] forState:UIControlStateNormal];
            if([autoComplete isOn]){
                [self consoleOut];
            }
            [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self
                                           selector: @selector(consoleIn) userInfo: nil repeats: NO];
            self.compilableWrongTries=self.compilableWrongTries+1;
            
            
            
        }
    }
    if([questionChecker isCorrect:[selectedChoicesViewController selectedChoices]]){
        if([questionChecker counter]+1>=[[questionChecker questions] count]){
            [incorrectTxt setText:@"No more questions"];
            [self consoleIn];
            [self hintIn];
            
            LevelEndViewController *levc=[[LevelEndViewController alloc] initWithTitle:@"lvlEnd" navController:[self navigationController] levelId:self.problemSetId pathId:self.pathID storyId:self.storyLevel.storyId  storyLevel:self.storyLevel];
            
            [self.compileButton setImage:[UIImage imageNamed:@"submitneutral.png"] forState:UIControlStateNormal];
            
            
            
            
            levc.delegate = self;
            [levc showInView:self.view animated:YES];
            
            [self.compileButton setEnabled:NO];
            [self.hintButton setEnabled:NO];
            [self.consoleButton setEnabled:NO];
            [self.settingsButton setEnabled:NO];
            
            
        }else{
            
            
            
            [incorrectTxt setText:@""];
            [self.compileButton setImage:[UIImage imageNamed:@"submitneutral.png"] forState:UIControlStateNormal];
            
            [self hintIn];
            [self consoleIn];
            
            
            
            [questionChecker setCounter:[questionChecker counter]+1];
            float progress=1.0/[[questionChecker questionId] count];
            /*  [self addProgressBarInFrame:CGRectMake(302.f, 25.f, 466.f, 26.f) withProgress:progress*([questionChecker counter]+1)];*/
            //   self.progressLabel=[[UILabel alloc] initWithFrame:CGRectMake(510, 32, 100, 10)];
            [self.progressLabel setText:[NSString stringWithFormat:@"%i/%i",[questionChecker counter]+1,[[questionChecker questions] count]]];
            /*
             [self.progressLabel setBackgroundColor:[UIColor clearColor]];
             [self.progressLabel setTextColor:[UIColor whiteColor]];*/
            /*    [self.view addSubview:self.progressLabel];
             [self.view bringSubviewToFront:self.progressLabel];*/
            CGRect progressFrame = self.progressImg.frame;
            progressFrame.size.width = (progressOriginalFrame.size.width/[[questionChecker questions] count])*([questionChecker counter]+1);
            [UIView animateWithDuration:0.5
                                  delay:0
                                options: UIViewAnimationCurveEaseIn
                             animations:^{
                                 self.progressImg.frame = progressFrame;
                                 
                             }
                             completion:^(BOOL finished){
                                 NSLog(@"Done!");
                             }];
            
            [choicesViewController setQuestion:[questionChecker getQuestion:[questionChecker counter]] :[questionChecker getSelectedOptions:[questionChecker counter]]];
            [selectedChoicesViewController reloadData];
        }
        
    }else{
        
    }
    
    
}
-(IBAction)refresh:(id)sender
{
    NSMutableArray *tempSelectedChoics=[selectedChoicesViewController selectedChoices];
    [choicesViewController.choices addObjectsFromArray:tempSelectedChoics];
    [selectedChoicesViewController.selectedChoices removeAllObjects];
    [self.selectedChoicesViewController.tableView reloadData];
    [self.choicesViewController.tableView reloadData];
    
}
#pragma mark - DropableTableViewDelegate
-(void)dragAndDropTableViewController:(DragAndDropTableViewController *)ddtvc droppedGesture:(UIGestureRecognizer *)gesture{
    
    UIView *viewHit = [self.view hitTest:[gesture locationInView:self.view.superview] withEvent:nil];
    
    
    if([ddtvc isKindOfClass:[ChoicesTableViewController class]]){
        ChoicesTableViewController *fromTBCV=(ChoicesTableViewController *)ddtvc;
        id selectedChoice = fromTBCV.selectedChoice;
        
        if([fromTBCV.view isEqual:viewHit]){
            [fromTBCV.choices addObject:selectedChoice];
            if([autoComplete isOn]){
                [self populateConsoleTable];
            }
        }else if([viewHit.superview isKindOfClass:[UITableViewCell class]] && [fromTBCV.view isEqual:viewHit.superview.superview]){
            //we have dropped on a cell in our table
            NSIndexPath *ip = [fromTBCV.tableView indexPathForCell:(UITableViewCell *)viewHit.superview];
            [fromTBCV.choices insertObject:selectedChoice atIndex:ip.row];
            if([autoComplete isOn]){
                [self populateConsoleTable];
            }
        }
        else if([self.selectedChoicesViewController.view isEqual:viewHit]){
            [self.selectedChoicesViewController.selectedChoices addObject:selectedChoice];
            [self.selectedChoicesViewController.tableView reloadData];
            if([autoComplete isOn]){
                [self populateConsoleTable];
            }
                [self nextQuestions];
            
        }
        else if([viewHit.superview isKindOfClass:[UITableViewCell class]] && [self.selectedChoicesViewController.view isEqual:viewHit.superview.superview]){
            //we have dropped on a cell in our table
            NSIndexPath *ip = [self.selectedChoicesViewController.tableView indexPathForCell:(UITableViewCell *)viewHit.superview];
            [self.selectedChoicesViewController.selectedChoices insertObject:selectedChoice atIndex:ip.row];
            [self.selectedChoicesViewController.tableView reloadData];
            if([autoComplete isOn]){
                [self populateConsoleTable];
            }
        }else{
            
            
            [fromTBCV.choices insertObject:selectedChoice atIndex:fromTBCV.selectedChoicePosition];
            if([autoComplete isOn]){
                [self populateConsoleTable];
            }
        }
        
        
    }
    else if([ddtvc isKindOfClass:[SelectedChoicesTableViewController class]]){
        SelectedChoicesTableViewController *fromSCTVC=(SelectedChoicesTableViewController *)ddtvc;
        id selectedChoice = fromSCTVC.selectedChoice;
        
        if([fromSCTVC.view isEqual:viewHit]){
            [fromSCTVC.selectedChoices addObject:selectedChoice];
            if([autoComplete isOn]){
                [self populateConsoleTable];
            }
                [self nextQuestions];
            
        }
        else if([viewHit.superview isKindOfClass:[UITableViewCell class]] && [fromSCTVC.view isEqual:viewHit.superview.superview]){
            NSIndexPath *ip = [fromSCTVC.tableView indexPathForCell:(UITableViewCell *)viewHit.superview];
            [fromSCTVC.selectedChoices insertObject:selectedChoice atIndex:ip.row];
            if([autoComplete isOn]){
                [self populateConsoleTable];
            }
                [self nextQuestions];
            
        }
        else if([self.choicesViewController.view isEqual:viewHit]){
            [self.choicesViewController.choices addObject:selectedChoice];
            [self.choicesViewController.tableView reloadData];
            if([autoComplete isOn]){
                [self populateConsoleTable];
            }
                [self nextQuestions];
            
        }
        else if([viewHit.superview isKindOfClass:[UITableViewCell class]] && [self.choicesViewController.view isEqual:viewHit.superview.superview]){
            NSIndexPath *ip = [self.choicesViewController.tableView indexPathForCell:(UITableViewCell *)viewHit.superview];
            [self.choicesViewController.choices insertObject:selectedChoice atIndex:ip.row];
            [self.choicesViewController.tableView reloadData];
            if([autoComplete isOn]){
                [self populateConsoleTable];
            }
        }else{
            [fromSCTVC.selectedChoices insertObject:selectedChoice atIndex:fromSCTVC.selectedChoicePosition];
            if([autoComplete isOn]){
                [self populateConsoleTable];
            }
                [self nextQuestions];
            
            
        }
        
        
    }
    else
        NSLog(@"Item dropped on a non droppable area");
    
}
#pragma mark - View lifecycle
-(void)nextLevel
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    StoryGameViewController* storyLevelViewController = (StoryGameViewController*)[storyboard instantiateViewControllerWithIdentifier:@"storyGameViewController"];
    NSArray *allLevels=[StoryLevels getAllLevelsWithPath:self.pathID storyId:self.storyLevel.storyId];
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
     //   [[self navigationController] pushViewController:storyLevelViewController animated:YES];
        
        [UIView  beginAnimations: @"Showinfo"context: nil];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.80];
        [[self navigationController] pushViewController: storyLevelViewController animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        
        StoryLevelViewController* storyLevelViewController = (StoryLevelViewController*)[storyboard instantiateViewControllerWithIdentifier:@"storyLevelViewController"];
        Story *st=[Story getStoryWithId:self.storyLevel.storyId];
        storyLevelViewController.storyId=self.storyLevel.storyId;
        storyLevelViewController.storyName=st.name;
        storyLevelViewController.pathid=self.pathID;
        
        //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
        //[[self navigationController] pushViewController:storyLevelViewController animated:YES];
        [UIView  beginAnimations: @"Showinfo"context: nil];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.80];
        [[self navigationController] pushViewController: storyLevelViewController animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    }
}
-(void)autoAdvancePressed{
    Settings *setting=[Settings getSettings];

    if([autoAdvance isOn]){
        setting.autoAdvance=TRUE;
    }else{
        setting.autoAdvance=FALSE;
    }
    commitDefaultMOC();
}
-(void)autoCompletePressed{
    Settings *setting=[Settings getSettings];
    if([autoComplete isOn]){
        setting.autoComplete=TRUE;
    }else{
        setting.autoComplete=FALSE;
    }
        commitDefaultMOC();
}
        
- (void)viewDidLoad
{
    [super viewDidLoad];
    [deepend StopMotion];

    [deepend StartMotion:self.backgrond];

    [self viewWillLayoutSubviews];
    [self.compileButton addTarget:self action:@selector(nextQuestions1) forControlEvents:UIControlEventAllTouchEvents];
    Settings *setting=[Settings getSettings];
    [autoAdvance setOn:setting.autoAdvance];
    [autoComplete setOn:setting.autoComplete];
    
    [autoAdvance addTarget:self action:@selector(autoAdvancePressed) forControlEvents:UIControlEventAllTouchEvents];
    
    [autoComplete addTarget:self action:@selector(autoCompletePressed) forControlEvents:UIControlEventAllTouchEvents];

    
    [homeScreen addTarget:self action:@selector(homeScreenView) forControlEvents:UIControlEventTouchUpInside];
    
    
    [pathScreen addTarget:self action:@selector(pathScreen) forControlEvents:UIControlEventTouchUpInside];
    
    
    [restartButton addTarget:self action:@selector(restartLevel) forControlEvents:UIControlEventTouchUpInside];
    self.settingsView.layer.anchorPoint = CGPointMake(0.0, 1.0);
    
    self.settingsView.center = CGPointMake(CGRectGetWidth(self.view.bounds)-35, CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.settingsView.bounds)+40);
    
    // Rotate 90 degrees to hide it off screen
    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
    rotationTransform = CGAffineTransformRotate(rotationTransform, DegreesToRadians(-180));
    self.settingsView.transform = rotationTransform;
    consoleOriginalFrame=self.consoleView.frame;
    
    CGRect basketTopFrame = self.consoleView.frame;
    basketTopFrame.origin.y = -basketTopFrame.size.height;
    [UIView animateWithDuration:0
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         self.consoleView.frame = basketTopFrame;
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    hintOriginalFrame=self.hintView.frame;
    CGRect basketTopFrame1 = self.hintView.frame;
    basketTopFrame1.origin.x = -basketTopFrame1.size.width;
    [UIView animateWithDuration:0
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         self.hintView.frame = basketTopFrame1;
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    self.navigationController.navigationBar.hidden = NO;
    
    if(self.storyLevel.video){
    //    UIView *videoView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    //    [self.view addSubview:videoView];
        NSURL *url=NULL;
        @try {
            url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                          pathForResource:self.storyLevel.levelId ofType:@"m4v"]];
        }
        @catch (NSException * e) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            url = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4v",self.storyLevel.levelId]]];

        }
      /*  NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:self.storyLevel.levelId ofType:@"m4v"]];
        NSLog(@"%@",url);
        if(url==NULL){
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            url = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4v",self.storyLevel.levelId]]];
                                          
                                          
            

        }*/
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@",self.storyLevel.levelId]];
        
        moviePlayer =  [[MPMoviePlayerViewController alloc]
                        initWithContentURL:url];
        [[moviePlayer view] setFrame:[self.view bounds]];
        /*  [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(moviePlayBackDidFinish:)
         name:MPMoviePlayerPlaybackDidFinishNotification
         object:moviePlayer];
         
         */
        moviePlayer.moviePlayer.controlStyle = MPMovieControlStyleNone;
        moviePlayer.moviePlayer.shouldAutoplay = YES;

        //moviePlayer.fullscreen=YES;
     //   [self presentMoviePlayerViewControllerAnimated:moviePlayer];
        [self.view addSubview:moviePlayer.view];
        UIImage *nextButton=[UIImage imageNamed:@"arrow"];
        UIButton *homeScreen=[[UIButton alloc] initWithFrame:CGRectMake(875, 635, nextButton.size.width, nextButton.size.height)];
        [homeScreen setImage:nextButton forState:UIControlStateNormal];
        [self.view addSubview:homeScreen];
        //[moviePlayer setFullscreen:YES animated:YES];
        [homeScreen addTarget:self action:@selector(nextLevel) forControlEvents:UIControlEventTouchUpInside];

        
    }
    self.choicesViewController.dropableDelegate = self;
    self.selectedChoicesViewController.dropableDelegate =self;
    self.questionChecker=[[QuestionChecker alloc] init];
    //[questionChecker initialiseArrays:self.problemSetId];
    [questionChecker initialiseStoryArrays:self.storyLevel];
    
    progressOriginalFrame=self.progressImg.frame;
    CGRect progressFrame = self.progressImg.frame;
    progressFrame.size.width =  progressFrame.size.width = (progressOriginalFrame.size.width/[[questionChecker questions] count])*([questionChecker counter]+1);
    [UIView animateWithDuration:0
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         self.progressImg.frame = progressFrame;
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
    [self.progressLabel setText:[NSString stringWithFormat:@"%i/%i",[questionChecker counter]+1,[[questionChecker questions] count]]];
    [self.progressLabel setBackgroundColor:[UIColor clearColor]];
    [self.progressLabel setTextColor:[UIColor whiteColor]];
    [self.progressLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20.0]];
    
    
    /* float progress=1.0/[[questionChecker questionId] count];
     NSLog(@"%f",progress);
     [self addProgressBarInFrame:CGRectMake(302.f, 25.f, 466.f, 26.f) withProgress:progress];
     self.progressLabel=[[UILabel alloc] initWithFrame:CGRectMake(510, 13, 100, 50)];
     
     [self.view addSubview:self.progressLabel];*/
    choicesViewController.choices = [NSMutableArray array];
    selectedChoicesViewController.draggableDelegate = selectedChoicesViewController;
    
    selectedChoicesViewController.selectedChoices = [NSMutableArray array];
    
    choicesViewController.draggableDelegate = choicesViewController;
    self.compilableWrongTries=0;
    self.nonCompilableTries=0;
    int counter=[questionChecker counter];
    [choicesViewController.txtView setText:[questionChecker getQuestion:counter]];
    [choicesViewController.txtView setFont:[UIFont fontWithName:@"Gill Sans 22.5" size:8.0]];
    
    for(NSString *strs in [questionChecker getSelectedOptions:counter]){
        [choicesViewController.choices addObject:strs];
    }
    
    [self.settingsButton addTarget:self action:@selector(showListView) forControlEvents:UIControlEventTouchUpInside];
    self.settingsCheck=FALSE;
    
    
    self.consoleCheck=FALSE;
    [self.consoleButton addTarget:self action:@selector(showConsole) forControlEvents:UIControlEventTouchUpInside];
    
    self.hintCheck=FALSE;
    [self.hintButton addTarget:self action:@selector(showHint) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
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
-(void) populateConsoleTable{
    NSMutableArray* consoleJSON=[questionChecker consoleData:[selectedChoicesViewController selectedChoices]];
    if(consoleJSON!=nil){
        NSMutableArray *consoleCall=[[NSMutableArray alloc] init];
        NSMutableArray *consoleExpected=[[NSMutableArray alloc] init];
        NSMutableArray *consoleRecieved=[[NSMutableArray alloc] init];
        NSMutableArray *consoleCorrect=[[NSMutableArray alloc] init];
        self.errorLabel.text=@"";
        self.callLabel.text=@"Call";
        self.expectedLabel.text=@"";
        self.recievedLabel.text=@"";
        self.correctLabel.text=@"Correct";
        for(int i=0;i<consoleJSON.count;i++){
            
            [consoleCall addObject:[[consoleJSON objectAtIndex:i] valueForKey:@"call"]];
            if([[consoleJSON objectAtIndex:i] valueForKey:@"expected"]!=nil){
                self.expectedLabel.text=@"Expected";
                self.recievedLabel.text=@"Received";
                [consoleExpected addObject:[NSString stringWithFormat:@"%@",[[consoleJSON objectAtIndex:i] valueForKey:@"expected"]]];
                [consoleRecieved addObject:[[consoleJSON objectAtIndex:i] valueForKey:@"received"]];
            }
            NSString *correctValue=[NSString stringWithFormat:@"%@",[[consoleJSON objectAtIndex:i] valueForKey:@"correct"] ];
            if([correctValue isEqualToString:@"1"]){
                [consoleCorrect addObject:@"True"];
            }else{
                [consoleCorrect addObject:@"False"];
            }
            // [consoleCorrect addObject:[[consoleJSON objectAtIndex:i] valueForKey:@"correct"]];
            
        }
        
        consoleTableViewController.choices=consoleCall;
        consoleCorrectViewController.choices=consoleCorrect;
        consoleExpectedViewController.choices=consoleExpected;
        consoleRecievedViewController.choices=consoleRecieved;
        
        [consoleTableViewController.tableView reloadData];
        [consoleCorrectViewController.tableView reloadData];
        [consoleExpectedViewController.tableView reloadData];
        [consoleRecievedViewController.tableView reloadData];
    }else{
        self.errorLabel.text=@"Uncompilable!";
        self.callLabel.text=@"";
        self.expectedLabel.text=@"";
        self.recievedLabel.text=@"";
        self.correctLabel.text=@"";
    }
    
}

-(void)consoleOut{
    [self.consoleButton setBackgroundImage:[UIImage imageNamed:@"consoleSelect.png"] forState:UIControlStateNormal];

    CGRect otherFrame=self.consoleView.frame;
    otherFrame.origin.y=consoleOriginalFrame.size.height-250;
    
    [self populateConsoleTable];
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.consoleView.frame= otherFrame;
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
    
}
-(void)consoleIn{
    [self.consoleButton setBackgroundImage:[UIImage imageNamed:@"console.png"] forState:UIControlStateNormal];

    CGRect basketTopFrame = self.consoleView.frame;
    basketTopFrame.origin.y = -consoleOriginalFrame.size.height;
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         self.consoleView.frame = basketTopFrame;
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    consoleTableViewController.choices=[NSMutableArray array];
    consoleCorrectViewController.choices=[NSMutableArray array];
    consoleExpectedViewController.choices=[NSMutableArray array];
    consoleRecievedViewController.choices=[NSMutableArray array];
    
    [consoleTableViewController.tableView reloadData];
    [consoleCorrectViewController.tableView reloadData];
    [consoleExpectedViewController.tableView reloadData];
    [consoleRecievedViewController.tableView reloadData];
}
- (void)showConsole
{
    if(!self.consoleCheck){
        [self consoleOut];
        [TestFlight passCheckpoint:@"console"];
        self.consoleCheck=TRUE;
        
    }else{
        [self consoleIn];
        self.consoleCheck=FALSE;
    }
}
-(void)hintIn{
    [self.hintButton setBackgroundImage:[UIImage imageNamed:@"hints.png"] forState:UIControlStateNormal];

    CGRect basketTopFrame = self.hintView.frame;
    basketTopFrame.origin.x = -hintOriginalFrame.size.width;
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.hintView.frame= basketTopFrame;
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    self.hintTxt.text=@"";
    
}
-(void)hintOut{
     [self.hintButton setBackgroundImage:[UIImage imageNamed:@"hintsSelect.png"] forState:UIControlStateNormal];
    CGRect otherFrame=self.hintView.frame;
    otherFrame.origin.x=hintOriginalFrame.size.width-395;
    
    self.hintTxt.text=[[questionChecker hintValues] objectAtIndex:[questionChecker counter]];
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.hintView.frame= otherFrame;
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
}
- (void)showHint
{
    if(!self.hintCheck){
        [self hintOut];
        [TestFlight passCheckpoint:@"hint"];
        self.hintCheck=TRUE;
        
    }else{
        [self hintIn];
        self.hintCheck=FALSE;
        
    }
}


- (void)showListView
{
    
    if(!self.settingsCheck){
        [TestFlight passCheckpoint:@"Settings question"];
        
        
        
        [self.settingsButton setImage:[UIImage imageNamed:@"gamesettingsclicked.png"] forState:UIControlStateNormal];
        [self animateSwing];
        /*
        self.gsvc.delegate = self;
        [self.gsvc showInView:self.view animated:YES];*/
        self.settingsCheck=TRUE;
        
    }else{
      //  [self.gsvc end];
        [self animateSwingBack];
        [self.settingsButton setImage:[UIImage imageNamed:@"gamesettingsunclicked.png"] forState:UIControlStateNormal];
        
        self.settingsCheck=FALSE;
        
    }
}

- (void)animateSwing {
    
    CGAffineTransform swingTransform = CGAffineTransformIdentity;
    swingTransform = CGAffineTransformRotate(swingTransform, DegreesToRadians(0));
    
    [UIView beginAnimations:@"swing" context:(__bridge void *)(self.settingsView)];
    
    [UIView setAnimationDuration:0.65];
    
    self.settingsView.transform = swingTransform;
    
    [UIView commitAnimations];
}
- (void)animateSwingBack {
    
    CGAffineTransform swingTransform = CGAffineTransformIdentity;
    swingTransform = CGAffineTransformRotate(swingTransform, DegreesToRadians(-180));
    
    [UIView beginAnimations:@"swing" context:(__bridge void *)(self.settingsView)];
    
    [UIView setAnimationDuration:0.65];
    
    self.settingsView.transform = swingTransform;
    
    [UIView commitAnimations];
}
-(void)pathScreen
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    StoryLevelViewController* storyLevelViewController = (StoryLevelViewController*)[storyboard instantiateViewControllerWithIdentifier:@"storyLevelViewController"];
    
    storyLevelViewController.storyId=self.storyLevel.storyId;
    Story *currentStory=[Story getStoryWithId:self.storyLevel.storyId];
    storyLevelViewController.storyName=currentStory.name;
    
    storyLevelViewController.pathid=self.pathID;
    
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
    //[[self navigationController] pushViewController:storyLevelViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: storyLevelViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    
}
-(void)restartLevel
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    StoryGameViewController* storyLevelViewController = (StoryGameViewController*)[storyboard instantiateViewControllerWithIdentifier:@"storyGameViewController"];
    
    storyLevelViewController.storyLevel=self.storyLevel;
    storyLevelViewController.problemSetId=self.problemSetId;
    storyLevelViewController.pathID=self.pathID;
    
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
    //    [self.navController pushViewController:storyLevelViewController animated:YES];
    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: storyLevelViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

-(void)homeScreenView{
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

@end
