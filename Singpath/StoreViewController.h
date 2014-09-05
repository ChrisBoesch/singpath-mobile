//
//  StoreViewController.h
//  Singpath
//
//  Created by Rishik on 25/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreViewController : UIViewController
{
    NSArray *_tableData;
    NSMutableArray *_storyData;
    NSMutableArray *_pathData;

}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *tableData;
@property (nonatomic, retain) NSMutableArray *storyData;
@property (nonatomic, retain) NSMutableArray *pathData;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UILabel *heading;
@property (nonatomic, strong) IBOutlet UIButton *backToHome;
@property (nonatomic, strong) IBOutlet UILabel *labelTxt;

@property (strong,nonatomic) IBOutlet UIImageView *backgrond;


@end
