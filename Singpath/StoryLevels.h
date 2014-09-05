//
//  StoryLevels.h
//  Singpath
//
//  Created by Rishik on 22/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StoryPaths, StoryQuestions;

@interface StoryLevels : NSManagedObject

@property (nonatomic) BOOL completed;
@property (nonatomic, retain) NSString * levelId;
@property (nonatomic, retain) NSString * levelName;
@property (nonatomic) int32_t levelNumber;
@property (nonatomic, retain) NSString * pathId;
@property (nonatomic, retain) NSString * storyId;
@property (nonatomic) BOOL video;
@property (nonatomic, retain) StoryPaths *hasPath;
@property (nonatomic, retain) NSSet *hasQuestions;
@end

@interface StoryLevels (CoreDataGeneratedAccessors)

- (void)addHasQuestionsObject:(StoryQuestions *)value;
- (void)removeHasQuestionsObject:(StoryQuestions *)value;
- (void)addHasQuestions:(NSSet *)values;
- (void)removeHasQuestions:(NSSet *)values;

@end
