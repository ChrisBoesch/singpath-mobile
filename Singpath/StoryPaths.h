//
//  StoryPaths.h
//  Singpath
//
//  Created by Rishik on 22/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Story, StoryLevels;

@interface StoryPaths : NSManagedObject

@property (nonatomic, retain) NSString * pathId;
@property (nonatomic, retain) NSString * pathName;
@property (nonatomic, retain) NSString * storyId;
@property (nonatomic, retain) NSSet *pathsLevel;
@property (nonatomic, retain) NSSet *pathsStory;
@end

@interface StoryPaths (CoreDataGeneratedAccessors)

- (void)addPathsLevelObject:(StoryLevels *)value;
- (void)removePathsLevelObject:(StoryLevels *)value;
- (void)addPathsLevel:(NSSet *)values;
- (void)removePathsLevel:(NSSet *)values;

- (void)addPathsStoryObject:(Story *)value;
- (void)removePathsStoryObject:(Story *)value;
- (void)addPathsStory:(NSSet *)values;
- (void)removePathsStory:(NSSet *)values;

@end
