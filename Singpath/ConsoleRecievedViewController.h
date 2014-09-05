//
//  ConsoleRecievedViewController.h
//  Singpath
//
//  Created by Rishik on 31/10/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsoleRecievedViewController : UITableViewController
{
    NSMutableArray *_choices;
    id _selectedChoice;
    UIView *_dragAndDropView;
    int _selectedChoicePosition;
    
}

@property(strong,nonatomic) UIView *dragAndDropView;
@property(strong,nonatomic) id selectedChoice;

@property(nonatomic) int selectedChoicePosition;
@property(strong,nonatomic) NSMutableArray *choices;


@end

