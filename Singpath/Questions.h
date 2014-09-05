//
//  Questions.h
//  Singpath
//
//  Created by Rishik on 22/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Levels;

@interface Questions : NSManagedObject

@property (nonatomic) BOOL completed;
@property (nonatomic, retain) NSString * levelId;
@property (nonatomic) int32_t nonCompilableTries;
@property (nonatomic, retain) NSString * questionId;
@property (nonatomic) int32_t time;
@property (nonatomic) int32_t wrongCompilableTries;
@property (nonatomic, retain) Levels *questionLevel;

@end
