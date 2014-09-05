//
//  LevelManager.h
//  Singpath
//
//  Created by Rishik Bahri on 03/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "Levels.h"
#import "ModelUtil.h"
#import "Paths.h"

@interface Levels ( Management )

+(Levels *)insertLevel:(NSString*)levelId levelName:(NSString*)levelName isDownloaded:(BOOL)isDownloaded isCompleted:(BOOL)isCompleted points:(int)points stars:(int)stars time:(int)time pathId:(NSString*)pathId levelNumber:(int)levelNumber levelPath:(Paths*)levelPath managedObjectContext:(NSManagedObjectContext*)moc;

+(Levels *)insertLevel:(NSString*)levelId levelName:(NSString*)levelName isDownloaded:(BOOL)isDownloaded isCompleted:(BOOL)isCompleted points:(int)points stars:(int)stars time:(int)time pathId:(NSString*)pathId levelNumber:(int)levelNumber levelPath:(Paths*)levelPath;
+(Levels *)getLevelWithId:(NSString *)levelId;
+(NSArray *)getAllLevels;
+(NSArray *)getAllLevelsWithPath:(NSString*) pathId;
+(Levels *)deleteLevel:(Levels*)level;
+(void)deleteAllLevels:(NSManagedObjectContext*)moc;
+(void)deleteAllLevels;



@end