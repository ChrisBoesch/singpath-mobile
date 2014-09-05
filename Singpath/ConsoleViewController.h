//
//  ConsoleViewController.h
//  Singpath
//
//  Created by Rishik Bahri on 29/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol ConsoleViewControllerDelegate;

@interface ConsoleViewController :  UIView <UITableViewDataSource, UITableViewDelegate>
{
    NSString *_title;
    NSArray *_options;
    UITableView *_table1;
    UITableView *_table2;


}

@property (nonatomic, assign) id<ConsoleViewControllerDelegate> delegate;

- (id)initWithTitle:(NSString *)aTitle consoleTxt:(NSString*)consoleTxt;
- (id)initWithTitle:(NSString *)aTitle hintTxt:(NSString*)hintTxt;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
-(void)end;
@end