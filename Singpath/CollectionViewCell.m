//
//  CollectionViewCell.m
//  Singpath
//
//  Created by Rishik Bahri on 04/07/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//


// This class is used a Utility Table/ Cell
// it helps track where things are pressed
// This is mainly used for StoryLevelView


#import "CollectionViewCell.h"
#import "StoryGameViewController.h"
@implementation CollectionViewCell

@synthesize imageView;
@synthesize label,navControlelr,level;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)selectCell
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    StoryGameViewController* storyLevelViewController = (StoryGameViewController*)[storyboard instantiateViewControllerWithIdentifier:@"storyGameViewController"];
    
    storyLevelViewController.storyLevel=level;
    storyLevelViewController.problemSetId=[level levelId];
    storyLevelViewController.pathID=[level pathId];
    [navControlelr pushViewController:storyLevelViewController animated:YES];
}


@end
