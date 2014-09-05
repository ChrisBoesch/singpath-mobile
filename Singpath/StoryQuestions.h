//
//  StoryQuestions.h
//  Singpath
//
//  Created by Rishik on 22/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StoryLevels;

@interface StoryQuestions : NSManagedObject

@property (nonatomic) BOOL completed;
@property (nonatomic, retain) NSString * levelId;
@property (nonatomic) int16_t order;
@property (nonatomic, retain) NSString * pathId;
@property (nonatomic, retain) NSString * questionId;
@property (nonatomic, retain) StoryLevels *questionLevel;

@end
