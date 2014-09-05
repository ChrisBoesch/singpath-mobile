//
//  PracticeGameViewController.h
//  Singpath
//
//  Created by Rishik on 15/10/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragAndDropTableViewController.h"
#import "ChoicesTableViewController.h"
#import "SelectedChoicesTableViewController.h"
#import "ConsoleTableViewController.h"
#import "ConsoleExpectedViewController.h"
#import "ConsoleRecievedViewController.h"
#import "ConsoleCorrectViewController.h"
#import "QuestionChecker.h"

@interface PracticeGameViewController : UIViewController<DropableTableViewDelegate>
{
    IBOutlet UILabel *incorrectTxt;
    IBOutlet UILabel *feedbackButton;
    IBOutlet UIButton *_compileButton;
    IBOutlet UIView *_consoleView;
    IBOutlet UIImageView *_consoleImg;
    IBOutlet UIView *_hintView;
    IBOutlet UIImageView *_hintImg;
    IBOutlet UILabel *_hintTxt;
    IBOutlet UILabel *_progressLabel;
    IBOutlet UIImageView *_progressImg;
    IBOutlet UILabel *_callLable;
    IBOutlet UILabel *_expectedLabel;
    IBOutlet UILabel *_recievedLabel;
    IBOutlet UILabel *_correctLabel;
    IBOutlet UILabel *_errorLabel;
    IBOutlet UIView *settingsView;

    CGRect progressOriginalFrame;
    CGRect consoleOriginalFrame;
    CGRect hintOriginalFrame;

    int _nonCompilableTries;
    int _compilableWrongTries;
    NSString *_problemSetId;
    
    BOOL _settingsCheck;
    BOOL _consoleCheck;
    BOOL _hintCheck;
    

    
}

@property(nonatomic) int nonCompilableTries;
@property(nonatomic) int compilableWrongTries;
@property(strong,nonatomic) NSString *problemSetId;
@property(strong,nonatomic) NSString *pathID;
@property(strong, nonatomic) IBOutlet UIButton *consoleButton;
@property(strong, nonatomic) IBOutlet UIButton *hintButton;
@property(strong, nonatomic) IBOutlet UIImageView *progressBar;
@property(strong, nonatomic) IBOutlet UIView *consoleView;
@property(strong, nonatomic) IBOutlet UIImageView *consoleImg;
@property(strong, nonatomic) IBOutlet UIView *hintView;
@property(strong, nonatomic) IBOutlet UIImageView *hintImg;
@property(strong, nonatomic) IBOutlet UILabel *hintTxt;
@property(strong, nonatomic) IBOutlet UIImageView *progressImg;
@property(strong, nonatomic) IBOutlet UILabel *progressLabel;
@property(strong, nonatomic) IBOutlet UILabel *callLabel;
@property(strong, nonatomic) IBOutlet UILabel *expectedLabel;
@property(strong, nonatomic) IBOutlet UILabel *recievedLabel;
@property(strong, nonatomic) IBOutlet UILabel *correctLabel;
@property(strong, nonatomic) IBOutlet UILabel *errorLabel;
@property(strong, nonatomic) IBOutlet UIView *settingsView;



@property(strong,nonatomic) IBOutlet UIButton *compileButton;
@property (strong,nonatomic) IBOutlet UIImageView *backgrond;

@property(strong,nonatomic) IBOutlet SelectedChoicesTableViewController *selectedChoicesViewController;
@property(strong,nonatomic) IBOutlet ChoicesTableViewController *choicesViewController;
@property(strong,nonatomic) IBOutlet ConsoleTableViewController *consoleTableViewController;
@property(strong,nonatomic) IBOutlet ConsoleExpectedViewController *consoleExpectedViewController;
@property(strong,nonatomic) IBOutlet ConsoleRecievedViewController *consoleRecievedViewController;
@property(strong,nonatomic) IBOutlet ConsoleCorrectViewController *consoleCorrectViewController;
@property(strong, nonatomic) IBOutlet UISwitch *autoComplete;
@property(strong, nonatomic) IBOutlet UISwitch *autoAdvance;

@property(strong,nonatomic)  QuestionChecker *questionChecker;
@property(strong,nonatomic) IBOutlet UIButton *settingsButton;

@property (nonatomic) BOOL settingsCheck;
@property (nonatomic) BOOL consoleCheck;
@property (nonatomic) BOOL hintCheck;

@property(strong, nonatomic) IBOutlet UIButton *homeScreen;
@property(strong, nonatomic) IBOutlet UIButton *pathScreen;
@property(strong, nonatomic) IBOutlet UIButton *restartButton;

-(IBAction)nextQuestion:(id)sender;
-(IBAction)refresh:(id)sender;

@end
