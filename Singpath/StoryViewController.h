//
//  storyViewController.h
//  Singpath
//
//  Created by Rishik on 17/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrayPageControl.h"

@interface StoryViewController: UIViewController <UIScrollViewDelegate>
{
    NSArray *_tableData;
    NSArray *_stories;
    int _currentView;
    NSArray *_storyIDs;
    BOOL _settingsCheck;
    BOOL _profileCheck;
    
    
    
    
}
-(IBAction) pageChanged:(id)sender;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet GrayPageControl* pageControl;
@property (nonatomic, retain) NSArray *tableData;
@property (nonatomic, strong) IBOutlet UILabel *heading;
@property (strong,nonatomic) IBOutlet UIImageView *backgrond;

@property (nonatomic, strong) IBOutlet UIButton *backToHome;

@property (nonatomic, retain) NSArray *stories;
@property (nonatomic, retain) NSArray *storyIDs;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIImageView *arrowImg;



@property (nonatomic) int currentView;


@end
