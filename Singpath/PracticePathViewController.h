//
//  PracticePathViewController.h
//  Singpath
//
//  Created by Rishik on 15/10/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrayPageControl.h"

@interface PracticePathViewController : UIViewController <UIScrollViewDelegate>
{
    NSArray *_tableData;
    NSArray *_paths;
    int _currentView;
    NSArray *_pathIDs;
    BOOL _settingsCheck;
    BOOL _profileCheck;
    
       
    
    
}
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet GrayPageControl* pageControl;
@property (nonatomic, retain) NSArray *tableData;
@property (nonatomic, strong) IBOutlet UIButton *backToHome;
@property (nonatomic, strong) IBOutlet UILabel *heading;
@property (strong,nonatomic) IBOutlet UIImageView *backgrond;

@property (nonatomic) BOOL settingsCheck;
@property (nonatomic) BOOL profileCheck;

@property (nonatomic, retain) NSArray *paths;
@property (nonatomic, retain) NSArray *pathIDs;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property(strong,nonatomic) IBOutlet UIButton *settingsButton;
@property(strong,nonatomic) IBOutlet UIButton *profileButton;
@property (nonatomic, strong) IBOutlet UIImageView *arrowImg;



@property (nonatomic) int currentView;

-(IBAction) pageChanged:(id)sender;

@end
