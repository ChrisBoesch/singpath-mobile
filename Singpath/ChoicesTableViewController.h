//
//  ChoicesTableViewController.h
//  Singpath
//
//  Created by Rishik Bahri on 04/07/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragAndDropTableViewController.h"
#import "DraggableTableViewDelegate.h"
#import "DropableTableViewDelegate.h"
#import "QuestionChecker.h"

@interface ChoicesTableViewController : DragAndDropTableViewController <DraggableTableViewDelegate>
{
    NSMutableArray *_choices;
    id _selectedChoice;
    IBOutlet UILabel *_txtView;
    UIView *_dragAndDropView;
    int _selectedChoicePosition;
    
}


@property(strong,nonatomic) UIView *dragAndDropView;
@property(strong,nonatomic) id selectedChoice;
@property(nonatomic) UILabel *txtView;

@property(nonatomic) int selectedChoicePosition;
@property(strong,nonatomic) NSMutableArray *choices;
-(void)setQuestion: (NSString *) question :(NSArray *) options;


@end
