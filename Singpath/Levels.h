//
//  Levels.h
//  Singpath
//
//  Created by Rishik on 22/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Paths, Questions;

@interface Levels : NSManagedObject

@property (nonatomic) BOOL completed;
@property (nonatomic) BOOL downloaded;
@property (nonatomic, retain) NSString * levelId;
@property (nonatomic, retain) NSString * levelName;
@property (nonatomic) int32_t levelNumber;
@property (nonatomic, retain) NSString * pathId;
@property (nonatomic) int32_t points;
@property (nonatomic) int32_t stars;
@property (nonatomic) int32_t time;
@property (nonatomic, retain) Paths *levelPath;
@property (nonatomic, retain) NSSet *levelQuestions;
@end

@interface Levels (CoreDataGeneratedAccessors)

- (void)addLevelQuestionsObject:(Questions *)value;
- (void)removeLevelQuestionsObject:(Questions *)value;
- (void)addLevelQuestions:(NSSet *)values;
- (void)removeLevelQuestions:(NSSet *)values;

@end
