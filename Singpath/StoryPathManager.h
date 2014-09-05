//
//  StoryPathManager.h
//  Singpath
//
//  Created by Rishik on 31/10/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "StoryPaths.h"
#import "ModelUtil.h"
#import "Story.h"

@interface StoryPaths ( Management )

+(StoryPaths *)insertPath:(NSString*)pathID pathName:(NSString*)pathName storyId:(NSString*)storyId pathsStory:(NSSet*)pathsStory  managedObjectContext:(NSManagedObjectContext*)moc;
+(StoryPaths *)insertPath:(NSString*)pathID pathName:(NSString*)pathName storyId:(NSString*)storyId pathsStory:(NSSet*)pathsStory;

+(StoryPaths *)getPathWithId:(NSString *)pathId storyId:(NSString*)storyId;
+(NSArray *)getAllPaths;
+(void)deleteAllPaths:(NSManagedObjectContext*)moc;
+(void)deleteAllPaths;
+(NSArray *)getPathsWithStoryId:(NSString*)storyId;


@end