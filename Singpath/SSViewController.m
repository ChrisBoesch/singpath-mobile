//
//  SSViewController.m
//  Singpath
//
//  Created by Rishik Bahri on 04/07/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//


#import "SSViewController.h"
#import "QuestionManager.h"
#import "Questions.h"
#import "LevelManager.h"
#import "Levels.h"
#import "LevelEndViewController.h"
#import "AchievmentManager.h"
#import "Achievments.h"
#import "AchievementViewController.h"
#import "LevelViewController.h"
#import "Paths.h"
#import "MainScreenViewController.h"
#import "PathManager.h"
#import "deepend.h"

//This class handels the challenege mode gameplay screen.

@implementation SSViewController

@synthesize questionChecker,choicesViewController, selectedChoicesViewController,consoleTableViewController,consoleCorrectViewController,consoleExpectedViewController,consoleRecievedViewController,time=_time,timer=_timer,points=_points,problemSetId=_problemSetId,pathID=_pathID,compileButton=_compileButton,nonCompilableTries=_nonCompilableTries,compilableWrongTries=_compilableWrongTries,settingsCheck=_settingsCheck,consoleCheck=_consoleCheck,hintCheck=_hintCheck,progressLabel=_progressLabel,progressImg=_progressImg,hintTxt=_hintTxt,hintImg=_hintImg,hintView=_hintView,consoleView=_consoleView,consoleImg=_consoleImg,callLabel=_callLable,expectedLabel=_expectedLabel,recievedLabel=_recievedLabel,correctLabel=_correctLabel,errorLabel=_errorLabel,settingsView=_settingsView,homeScreen,pathScreen,restartButton,backgrond;
#define DegreesToRadians(degrees) ((degrees * M_PI) / 180.0)





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

//Logic for advancing to the next question.
-(IBAction)nextQuestion:(id)sender{
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
            self.points=self.points+10;
      
        [pointsLabel setText:[NSString stringWithFormat:@"%i",self.points]];

        
       }else if([feed isEqualToString:@"Uncompilable!"]){
        [feedbackButton setBackgroundColor:[UIColor redColor]];
        [self.compileButton setImage:[UIImage imageNamed:@"submitred.png"] forState:UIControlStateNormal];
        self.nonCompilableTries=self.nonCompilableTries+1;
        if(self.points>4){
        self.points=self.points-5;
        [pointsLabel setText:[NSString stringWithFormat:@"%i",self.points]];
        }else{
            self.points=0;
            [pointsLabel setText:[NSString stringWithFormat:@"%i",self.points]];
            
            
        }
        if(self.points==0){
            LevelEndViewController *levc=[[LevelEndViewController alloc] initWithTitle:@"lvlEnd" navController:[self navigationController] levelId:self.problemSetId pathId:self.pathID];
            levc.delegate = self;
            [levc showInView:self.view animated:YES];
            [self.compileButton setEnabled:NO];
            [self.hintButton setEnabled:NO];
            [self.consoleButton setEnabled:NO];
            [self.settingsButton setEnabled:NO];
            [self.timer invalidate];
        }
        
    }else{
        [feedbackButton setBackgroundColor:[UIColor yellowColor]];
        [self.compileButton setImage:[UIImage imageNamed:@"submitblue.png"] forState:UIControlStateNormal];
        self.compilableWrongTries=self.compilableWrongTries+1;
        if(self.points>2){
            self.points=self.points-3;
            [pointsLabel setText:[NSString stringWithFormat:@"%i",self.points]];
        }else{
            self.points=0;
            [pointsLabel setText:[NSString stringWithFormat:@"%i",self.points]];
            
        }
        if(self.points==0){
            LevelEndViewController *levc=[[LevelEndViewController alloc] initWithTitle:@"lvlEnd" navController:[self navigationController] levelId:self.problemSetId pathId:self.pathID];
            levc.delegate = self;
            [levc showInView:self.view animated:YES];
            [self.compileButton setEnabled:NO];
            [self.hintButton setEnabled:NO];
            [self.consoleButton setEnabled:NO];
            [self.settingsButton setEnabled:NO];
            [self.timer invalidate];
        }

    }
    }
    if([questionChecker isCorrect:[selectedChoicesViewController selectedChoices]]){
        if([questionChecker counter]+1>=[[questionChecker questions] count]){
            [incorrectTxt setText:@"No more questions"];
            
            Levels *currentLevel=[Levels getLevelWithId:self.problemSetId];
            currentLevel.completed=YES;
            currentLevel.points=self.points;
            float stars=self.points/(10.0*[[questionChecker questions] count]);
            if(stars*100<50){
                currentLevel.stars=0;
            }else if(stars*100<75){
                currentLevel.stars=1;
            }else if(stars*100<90){
                currentLevel.stars=2;
            }else{
                currentLevel.stars=3;
            }
            LevelEndViewController *levc=[[LevelEndViewController alloc] initWithTitle:@"lvlEnd" navController:[self navigationController] stars:currentLevel.stars levelId:self.problemSetId pathId:self.pathID check:TRUE];
            levc.delegate = self;
            [levc showInView:self.view animated:YES];
            [self.compileButton setEnabled:NO];
            [self.hintButton setEnabled:NO];
            [self.consoleButton setEnabled:NO];
            [self.settingsButton setEnabled:NO];
            [self.timer invalidate];
            [self consoleIn];
            [self hintIn];
            NSMutableArray *achievementsUnolocked=[[NSMutableArray alloc] init];
            Achievments *babySteps=[Achievments getPerticularAchievment:@"Baby Steps"];
            if(!babySteps.unlocked){
                [achievementsUnolocked addObject:@"Baby Steps"];
                babySteps.unlocked=YES;
            }
            Achievments *ace=[Achievments getPerticularAchievment:@"Ace"];
            if(!ace.unlocked){
                Levels *curentLevel=[Levels getLevelWithId:self.problemSetId];
                NSArray *currentQuestions=[NSArray arrayWithObject:[currentLevel levelQuestions]];
                if(currentQuestions.count>2){
                    for(int i=0;i<=currentQuestions.count-3;i++){
                        Questions *currentQuestion1=[currentQuestions objectAtIndex:i];
                        Questions *currentQuestion2=[currentQuestions objectAtIndex:i+1];
                        Questions *currentQuestion3=[currentQuestions objectAtIndex:i+2];
                        if(currentQuestion1.nonCompilableTries==0&&currentQuestion1.wrongCompilableTries==0){
                            if(currentQuestion2.nonCompilableTries==0&&currentQuestion2.wrongCompilableTries==0){
                                if(currentQuestion3.nonCompilableTries==0&&currentQuestion3.wrongCompilableTries==0){
                                    [achievementsUnolocked addObject:@"Ace"];
                                    ace.unlocked=YES;
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            Achievments *rockstar=[Achievments getPerticularAchievment:@"Rockstar"];
            if(!rockstar.unlocked){
                NSArray *allLevels=[Levels getAllLevelsWithPath:self.pathID];
                BOOL check=NO;
                for(int i=0;i<allLevels.count;i++){
                    Levels *currentLevel=[allLevels objectAtIndex:i];
                    if(currentLevel.stars==3){
                        check=YES;
                    }else{
                        check=NO;
                        break;
                    }
                }
                if(check){
                    [achievementsUnolocked addObject:@"Rockstar"];

                    rockstar.unlocked=YES;
                }
            }
            Achievments *superstar=[Achievments getPerticularAchievment:@"Superstar"];
            if(!superstar.unlocked){
                NSArray *allLevels=[Levels getAllLevels];
                BOOL check=NO;
                for(int i=0;i<allLevels.count;i++){
                    Levels *currentLevel=[allLevels objectAtIndex:i];
                    if(currentLevel.stars==3){
                        check=YES;
                    }else{
                        check=NO;
                        break;
                    }
                }
                if(check){
                    
                    [achievementsUnolocked addObject:@"Superstar"];

                    superstar.unlocked=YES;
                }
            }
            if(achievementsUnolocked.count>0){
                    AchievementViewController* avc=[[AchievementViewController alloc] initWithTitle:@"" achievements:[NSArray arrayWithArray:achievementsUnolocked]];
                    avc.delegate = self;
                    [avc showInView:self.view animated:YES];
                
            }
            commitDefaultMOC();
        }else{
            [self hintIn];
            [self consoleIn];
            Questions *question=[Questions getQuestionWithId:self.problemSetId questionId:[[questionChecker questionId] objectAtIndex:[questionChecker counter]]];
            question.completed=YES;
            question.time=self.time;
            question.wrongCompilableTries=self.compilableWrongTries;
            question.nonCompilableTries=self.nonCompilableTries;
            
            commitDefaultMOC();
            self.time=0;
            self.nonCompilableTries=0;
            self.compilableWrongTries=0;
            [self.timer fire];
            [incorrectTxt setText:@""];
            [self.compileButton setImage:[UIImage imageNamed:@"submitneutral.png"] forState:UIControlStateNormal];
            
            
           
            
            
            [questionChecker setCounter:[questionChecker counter]+1];
            float progress=1.0/[[questionChecker questionId] count];

            [self.progressLabel setText:[NSString stringWithFormat:@"%i/%i",[questionChecker counter]+1,[[questionChecker questions] count]]];

            
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
//Logic for when a perticualr item is selected or dropped from a table for the drag and drop
// functionality.
#pragma mark - DropableTableViewDelegate
-(void)dragAndDropTableViewController:(DragAndDropTableViewController *)ddtvc droppedGesture:(UIGestureRecognizer *)gesture{
    
    UIView *viewHit = [self.view hitTest:[gesture locationInView:self.view.superview] withEvent:nil];
    
    if([ddtvc isKindOfClass:[ChoicesTableViewController class]]){
        ChoicesTableViewController *fromTBCV=(ChoicesTableViewController *)ddtvc;
        id selectedChoice = fromTBCV.selectedChoice;
        
        if([fromTBCV.view isEqual:viewHit]){
            [fromTBCV.choices addObject:selectedChoice];
            [self populateConsoleTable];

        }else if([viewHit.superview isKindOfClass:[UITableViewCell class]] && [fromTBCV.view isEqual:viewHit.superview.superview]){
            //we have dropped on a cell in our table
            NSIndexPath *ip = [fromTBCV.tableView indexPathForCell:(UITableViewCell *)viewHit.superview];
            [fromTBCV.choices insertObject:selectedChoice atIndex:ip.row];
            [self populateConsoleTable];

        }
        else if([self.selectedChoicesViewController.view isEqual:viewHit]){
            [self.selectedChoicesViewController.selectedChoices addObject:selectedChoice];
            [self.selectedChoicesViewController.tableView reloadData];
            [self populateConsoleTable];

        }
        else if([viewHit.superview isKindOfClass:[UITableViewCell class]] && [self.selectedChoicesViewController.view isEqual:viewHit.superview.superview]){
            //we have dropped on a cell in our table
            NSIndexPath *ip = [self.selectedChoicesViewController.tableView indexPathForCell:(UITableViewCell *)viewHit.superview];
            [self.selectedChoicesViewController.selectedChoices insertObject:selectedChoice atIndex:ip.row];
            [self.selectedChoicesViewController.tableView reloadData];
            [self populateConsoleTable];

        }else{
            
        
            [fromTBCV.choices insertObject:selectedChoice atIndex:fromTBCV.selectedChoicePosition];
            [self populateConsoleTable];

        }
        
        
    }
    else if([ddtvc isKindOfClass:[SelectedChoicesTableViewController class]]){
        SelectedChoicesTableViewController *fromSCTVC=(SelectedChoicesTableViewController *)ddtvc;
        id selectedChoice = fromSCTVC.selectedChoice;
        
        if([fromSCTVC.view isEqual:viewHit]){
            [fromSCTVC.selectedChoices addObject:selectedChoice];
            [self populateConsoleTable];

        } else if([viewHit.superview isKindOfClass:[UITableViewCell class]] && [fromSCTVC.view isEqual:viewHit.superview.superview]){
            NSIndexPath *ip = [fromSCTVC.tableView indexPathForCell:(UITableViewCell *)viewHit.superview];
            [fromSCTVC.selectedChoices insertObject:selectedChoice atIndex:ip.row];
            [self populateConsoleTable];

        }
        else if([self.choicesViewController.view isEqual:viewHit]){
            [self.choicesViewController.choices addObject:selectedChoice];
            [self.choicesViewController.tableView reloadData];
            [self populateConsoleTable];


        }
        else if([viewHit.superview isKindOfClass:[UITableViewCell class]] && [self.choicesViewController.view isEqual:viewHit.superview.superview]){
            NSIndexPath *ip = [self.choicesViewController.tableView indexPathForCell:(UITableViewCell *)viewHit.superview];
            [self.choicesViewController.choices insertObject:selectedChoice atIndex:ip.row];
            [self.choicesViewController.tableView reloadData];
            [self populateConsoleTable];

        }else{
            [fromSCTVC.selectedChoices insertObject:selectedChoice atIndex:fromSCTVC.selectedChoicePosition];
            [self populateConsoleTable];

        }
       
        
    }
    else
        NSLog(@"Item dropped on a non droppable area");
    
  }
//Logic for handeling how the progress bar in the gameplay works.
-(void)addProgressBarInFrame:(CGRect)frame withProgress:(CGFloat)progress
{
    float widthOfJaggedBit = 4.0f;
    UIImage * imageA= [[UIImage imageNamed:@"progressBlue.png"] stretchableImageWithLeftCapWidth:widthOfJaggedBit topCapHeight:0.0f];
    UIView * progressBar = [[UIView alloc] initWithFrame:frame];
    progressBar.backgroundColor = [UIColor clearColor];
    UIImageView * imageViewA = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width*progress, frame.size.height)];
    
    
    imageViewA.image = imageA;
        [self.view addSubview:progressBar];
    [progressBar addSubview:imageViewA];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [deepend StopMotion];

    [deepend StartMotion:self.backgrond];

    [self viewWillLayoutSubviews];
    
    self.settingsView.layer.anchorPoint = CGPointMake(0.0, 1.0);

    self.settingsView.center = CGPointMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.settingsView.bounds));
    
    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
    rotationTransform = CGAffineTransformRotate(rotationTransform, DegreesToRadians(-180));
    self.settingsView.transform = rotationTransform;
    
    [homeScreen addTarget:self action:@selector(homeScreenView) forControlEvents:UIControlEventTouchUpInside];
    
    
    [pathScreen addTarget:self action:@selector(pathScreen) forControlEvents:UIControlEventTouchUpInside];
    
    
    [restartButton addTarget:self action:@selector(restartLevel) forControlEvents:UIControlEventTouchUpInside];
    
    
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
   
    
    self.choicesViewController.dropableDelegate = self;
    self.selectedChoicesViewController.dropableDelegate =self;
    self.questionChecker=[[QuestionChecker alloc] init];
    [questionChecker initialiseArrays:self.problemSetId];
    
    
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
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1
                                           target:self
                                         selector:@selector(startTimer)
                                         userInfo:nil
                                          repeats:YES];
    self.time=0;
    self.points=2*[[questionChecker questions] count];
    [pointsLabel setText:[NSString stringWithFormat:@"%i",self.points]];
    [pointsLabel setFont:[UIFont fontWithName:@"Helvetica Black Hollow" size:40.0]];

    [self.timer fire];
    [self.settingsButton addTarget:self action:@selector(showListView) forControlEvents:UIControlEventTouchUpInside];
    self.settingsCheck=FALSE;
    
    
    self.consoleCheck=FALSE;
    [self.consoleButton addTarget:self action:@selector(showConsole) forControlEvents:UIControlEventTouchUpInside];
    
    self.hintCheck=FALSE;
    [self.hintButton addTarget:self action:@selector(showHint) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)startTimer
{
    [timerLabel setText:[NSString stringWithFormat:@"%i",self.time]];
    [timerLabel setFont:[UIFont fontWithName:@"Helvetica Black Hollow" size:40.0]];
    int temp=self.time%20;
    
    if (temp == 0 && self.time!=0) {
        if(self.points>1){
        self.points=self.points-2;
        [pointsLabel setText:[NSString stringWithFormat:@"%i",self.points]];
        }else{
            self.points=0;
            [pointsLabel setText:[NSString stringWithFormat:@"%i",self.points]];

            
        }
        if(self.points==0){
            LevelEndViewController *levc=[[LevelEndViewController alloc] initWithTitle:@"lvlEnd" navController:[self navigationController] levelId:self.problemSetId pathId:self.pathID];
            levc.delegate = self;
            [levc showInView:self.view animated:YES];
            [self.compileButton setEnabled:NO];
            [self.hintButton setEnabled:NO];
            [self.consoleButton setEnabled:NO];
            [self.settingsButton setEnabled:NO];
            [self.timer invalidate];
        }
        
    }
    self.time++;
    
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
-(void)populateConsoleTable{
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
                self.expectedLabel.text=@"Ecpected";
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
        [self.consoleButton setBackgroundImage:[UIImage imageNamed:@"consoleSelect.png"] forState:UIControlStateNormal];

        
        [TestFlight passCheckpoint:@"console"];
        self.consoleCheck=TRUE;
        
    }else{
        [self consoleIn];
        [self.consoleButton setBackgroundImage:[UIImage imageNamed:@"console.png"] forState:UIControlStateNormal];

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
- (void)showListView
{
    
    if(!self.settingsCheck){
        [TestFlight passCheckpoint:@"Settings question"];
        
        

        [self.settingsButton setImage:[UIImage imageNamed:@"gamesettingsclicked.png"] forState:UIControlStateNormal];
        [self animateSwing];
       

        self.settingsCheck=TRUE;
        
    }else{
        [self animateSwingBack];

        [self.settingsButton setImage:[UIImage imageNamed:@"gamesettingsunclicked.png"] forState:UIControlStateNormal];
        
        self.settingsCheck=FALSE;
        
    }
}
-(void)pathScreen
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    LevelViewController* levelViewController = (LevelViewController*)[storyboard instantiateViewControllerWithIdentifier:@"levelViewController"];
    Paths *path=[Paths getPathWithId:self.pathID];
    levelViewController.levelid=self.pathID;
    levelViewController.levelName=path.pathName;
    [TestFlight passCheckpoint:@"settings go to path screen"];
    
   

    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: levelViewController  animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
}
-(void)restartLevel
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    SSViewController* ssViewController = (SSViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ssViewController"];
    ssViewController.problemSetId=self.problemSetId;
    ssViewController.pathID=self.pathID;
    [TestFlight passCheckpoint:@"Settings Restart"];
    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: ssViewController  animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}
-(void)homeScreenView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    MainScreenViewController* mainScreen = (MainScreenViewController*)[storyboard instantiateViewControllerWithIdentifier:@"mainScreenViewController"];
    
    
    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: mainScreen animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
}
@end
