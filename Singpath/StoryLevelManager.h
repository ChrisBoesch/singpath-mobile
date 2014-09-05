//
//  StoryLevelManager.h
//  Singpath
//
//  Created by Rishik on 17/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "StoryLevels.h"
#import "ModelUtil.h"
#import "StoryPaths.h"

@interface StoryLevels ( Management )

+(StoryLevels *)insertLevel:(NSString*)levelId levelName:(NSString*)levelName pathId:(NSString*)pathId  storyId:(NSString*)storyId isCompleted:(BOOL)isCompleted video:(BOOL)video levelPath:(StoryPaths*)levelPath levelNumber:(int)levelNumber managedObjectContext:(NSManagedObjectContext*)moc;

+(StoryLevels *)insertLevel:(NSString*)levelId levelName:(NSString*)levelName pathId:(NSString*)pathId  storyId:(NSString*)storyId isCompleted:(BOOL)isCompleted video:(BOOL)video levelPath:(StoryPaths*)levelPath levelNumber:(int)levelNumber;
+(StoryLevels *)getLevelWithId:(NSString *)levelId storyId:(NSString*)storyId;
+(NSArray *)getAllLevels;
+(NSArray *)getAllLevelsWithPath:(NSString*)pathId storyId:(NSString*)storyId;
+(StoryLevels *)deleteLevel:(StoryLevels*)level;
+(void)deleteAllLevels:(NSManagedObjectContext*)moc;
+(void)deleteAllLevels;

//+(StoryLevels *)newLevel:(NSString*)levelId levelName:(NSString*)levelName pathId:(NSString*)pathId  storyId:(NSString*)storyId isCompleted:(BOOL)isCompleted video:(BOOL)video levelPath:(StoryPaths*)levelPath levelNumber:(int)levelNumber;


@end