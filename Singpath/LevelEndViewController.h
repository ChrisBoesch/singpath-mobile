//
//  LevelEndViewController.h
//  Singpath
//
//  Created by Rishik Bahri on 21/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StoryLevels.h"

@protocol LevelEndViewControllerDelegate;

@interface LevelEndViewController :  UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSString *_title;
    NSArray *_options;
    UINavigationController *_navController;
    NSString *_currentLevelId;
    NSString *_pathId;
    NSString *_nextLvlId;
    NSString *_storyId;
    NSString *_storyName;
    StoryLevels *_storyLevel;

}

@property(strong,nonatomic)  UINavigationController *navController;
@property(strong,nonatomic)  NSString *currentLevelId;
@property(strong,nonatomic)  NSString *pathId;
@property(strong,nonatomic)  NSString *nextLvlId;
@property(strong,nonatomic)  NSString *storyId;
@property(strong,nonatomic)  NSString *storyName;
@property(strong,nonatomic)  StoryLevels *storyLevel;

@property (nonatomic, assign) id<LevelEndViewControllerDelegate> delegate;

- (id)initWithTitle:(NSString *)aTitle navController:(UINavigationController*)navController stars:(int)stars levelId:(NSString*)levelId pathId:(NSString*)pathId  check:(BOOL)check;

- (id)initWithTitle:(NSString *)aTitle navController:(UINavigationController*)navController levelId:(NSString*)levelId pathId:(NSString*)pathId;


- (id)initWithTitle:(NSString *)aTitle navController:(UINavigationController*)navController  levelId:(NSString*)levelId pathId:(NSString*)pathId storyId:(NSString*)storyId storyLevel:(StoryLevels*)storyLevel;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
-(void)end;
@end