//
//  StoryModeCell.h
//  Singpath
//
//  Created by Rishik on 25/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryModeCell : UITableViewCell
{
    NSString *_downloadLink;
    NSString *_storyId;
    NSString *_storyName;
    NSString *_storyNumOfLvls;
    NSString *_storyNumOfVideos;
    NSString *_storyOrder;
    NSString *_storyPaths;

    BOOL _clickStory;
     UIView *_loading;

}
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *description;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIButton *buyItem;
@property (strong, nonatomic) NSString *downloadLink;
@property (strong, nonatomic) NSString *storyId;
@property (strong, nonatomic) NSString *storyNmae;
@property (strong, nonatomic) NSString *storyNumOfLvls;
@property (strong, nonatomic) NSString *storyNumOfVideos;
@property (strong, nonatomic) NSString *storyOrder;
@property (strong, nonatomic) NSString *storyPaths;

@property (nonatomic) BOOL clickStory;

@property (strong, nonatomic)  UIView *loading;


@end
