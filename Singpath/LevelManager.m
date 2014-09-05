//
//  LevelManager.m
//  Singpath
//
//  Created by Rishik Bahri on 03/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "LevelManager.h"

static NSString *entityName = @"Levels";

@implementation Levels ( Management )

+(Levels *)insertLevel:(NSString*)levelId levelName:(NSString*)levelName isDownloaded:(BOOL)isDownloaded isCompleted:(BOOL)isCompleted points:(int)points stars:(int)stars time:(int)time pathId:(NSString*)pathId levelNumber:(int)levelNumber levelPath:(Paths*)levelPath  managedObjectContext:(NSManagedObjectContext*)moc
{
    Levels *level=(Levels *) [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                        inManagedObjectContext:moc];
    
    level.levelId=[NSString stringWithFormat:@"%@",levelId];
    level.levelName=levelName;
    level.downloaded=isDownloaded;
    level.completed=isCompleted;
    level.points=points;
    level.stars=stars;
    level.time=time;
    level.pathId=pathId;
    level.levelNumber=levelNumber;
    level.levelPath=levelPath;
    
    
    
    return level;
}

+(Levels *)insertLevel:(NSString*)levelId levelName:(NSString*)levelName isDownloaded:(BOOL)isDownloaded isCompleted:(BOOL)isCompleted points:(int)points stars:(int)stars time:(int)time pathId:(NSString*)pathId levelNumber:(int)levelNumber levelPath:(Paths*)levelPath
{
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    return [Levels insertLevel:[NSString stringWithFormat:@"%@",levelId] levelName:levelName isDownloaded:isDownloaded isCompleted:isCompleted points:points stars:stars time:time pathId:pathId levelNumber:levelNumber levelPath:levelPath managedObjectContext:moc];
}

+(Levels *)getLevelWithId:(NSString *)levelId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"levelId == %@", levelId];
    
    
    Levels *level = (Levels *)fetchManagedObject(entityName, predicate,NULL, defaultManagedObjectContext());
    
    return level;
}
+(NSArray *)getAllLevels
{
  
    NSArray *levels = fetchManagedObjects(entityName, NULL, NULL, defaultManagedObjectContext());
    
    return levels;
}
+(NSArray *)getAllLevelsWithPath:(NSString*) pathId
{
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathId == %@", [NSString stringWithFormat:@"%@",pathId]];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"levelNumber" ascending:YES]];
    
    NSArray *levels = fetchManagedObjects(entityName, predicate, sortDescriptors, defaultManagedObjectContext());
    return levels;
}
+(void)deleteAllLevels:(NSManagedObjectContext*)moc
{
    NSArray *allLevels=[self getAllLevels];
    for(int i=0;i<allLevels.count;i++){
        [moc deleteObject:[allLevels objectAtIndex:i]];
    }}
+(void)deleteAllLevels
{
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    [Levels deleteAllLevels:moc];
}

@end