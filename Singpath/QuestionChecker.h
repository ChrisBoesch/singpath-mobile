//
//  QuestionChecker.h
//  Singpath
//
//  Created by Rishik Bahri on 04/07/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "StoryLevels.h"
@interface QuestionChecker : UIViewController
{
    NSMutableArray *questions;
    NSMutableArray *answers;
    NSMutableArray *nonErrorResults;
    NSMutableArray *solved;
    NSMutableArray *questionId;
    NSMutableArray *consoleValues;
    NSMutableArray *hintValues;

    int counter;
    
}
@property(strong,nonatomic) NSMutableArray *questions;
@property(strong,nonatomic) NSMutableArray *questionId;
@property(strong,nonatomic) NSMutableArray *answers;
@property(strong,nonatomic) NSMutableArray *solved;
@property(strong,nonatomic) NSMutableArray *nonErrorResults;
@property(strong,nonatomic) NSMutableArray *consoleValues;
@property(strong,nonatomic) NSMutableArray *hintValues;

@property(nonatomic) int counter;

- (NSMutableArray *)getSelectedOptions:(int)position;
- (NSString *)getQuestion:(int) position;
- (BOOL)isCorrect:(NSMutableArray *) selectedChoices;
- (NSString*)feedback:(NSMutableArray *) selectedChoices;
-(void)initialiseArrays: (NSString *)problemsetId;
-(void)initialiseStoryArrays: (StoryLevels *)level;

- (NSString *)getHintValue:(int) position;
-(NSMutableArray*)consoleData: (NSMutableArray *) selectedChoices;

@end
