//
//  AchievementViewController.h
//  Singpath
//
//  Created by Rishik Bahri on 28/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol AchievementViewControllerDelegate;

@interface AchievementViewController :  UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSString *_title;
    NSArray *_options;
    int _count;
    NSTimer *_timeLoop;
}


@property (nonatomic, assign) id<AchievementViewControllerDelegate> delegate;
@property (nonatomic) int count;
@property (nonatomic) NSTimer *timeLoop;


- (id)initWithTitle:(NSString *)aTitle achievements:(NSArray*)achievements;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
-(void)end;
@end