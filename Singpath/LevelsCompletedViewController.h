//
//  levelsCompletedViewController.h
//  Singpath
//
//  Created by Rishik on 14/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelsCompletedViewController : UICollectionViewController
{
    NSMutableArray* _choices;
}

@property(strong,nonatomic) NSMutableArray *choices;

@end
