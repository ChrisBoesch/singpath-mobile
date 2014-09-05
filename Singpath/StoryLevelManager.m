//
//  StoryLevelManager.m
//  Singpath
//
//  Created by Rishik on 17/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//


#import "StoryLevelManager.h"

static NSString *entityName = @"StoryLevels";

@implementation StoryLevels ( Management )

/*+(StoryLevels *)newLevel:(NSString*)levelId levelName:(NSString*)levelName pathId:(NSString*)pathId  storyId:(NSString*)storyId isCompleted:(BOOL)isCompleted video:(BOOL)video levelPath:(StoryPaths*)levelPath levelNumber:(int)levelNumber
{
    return [StoryLevels insertLevel:[NSString stringWithFormat:@"%@",levelId] levelName:levelName pathId:[NSString stringWithFormat:@"%@",pathId] storyId:[NSString stringWithFormat:@"%@",storyId] isCompleted:isCompleted video:video levelPath:levelPath levelNumber:(int)levelNumber];
}*/

+(StoryLevels *)insertLevel:(NSString*)levelId levelName:(NSString*)levelName pathId:(NSString*)pathId  storyId:(NSString*)storyId isCompleted:(BOOL)isCompleted video:(BOOL)video levelPath:(StoryPaths*)levelPath levelNumber:(int)levelNumber managedObjectContext:(NSManagedObjectContext*)moc
{
    StoryLevels *level=(StoryLevels *) [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                           inManagedObjectContext:moc];
    
    level.levelId=[NSString stringWithFormat:@"%@",levelId];
    level.levelName=levelName;
    level.completed=isCompleted;
    level.pathId=[NSString stringWithFormat:@"%@",pathId];;
    level.hasPath=levelPath;
    level.storyId=storyId;
    level.video=video;
    level.hasPath=levelPath;
    level.levelNumber=levelNumber;
    return level;
}

+(StoryLevels *)insertLevel:(NSString*)levelId levelName:(NSString*)levelName pathId:(NSString*)pathId  storyId:(NSString*)storyId isCompleted:(BOOL)isCompleted video:(BOOL)video levelPath:(StoryPaths*)levelPath levelNumber:(int)levelNumber
{
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    return [StoryLevels insertLevel:[NSString stringWithFormat:@"%@",levelId] levelName:levelName pathId:[NSString stringWithFormat:@"%@",pathId] storyId:[NSString stringWithFormat:@"%@",storyId] isCompleted:isCompleted video:video levelPath:levelPath levelNumber:(int)levelNumber managedObjectContext:moc];
}

+(StoryLevels *)getLevelWithId:(NSString *)levelId storyId:(NSString*)storyId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storyId == %@", levelId];
    NSArray *paths = fetchManagedObjects(entityName, predicate, NULL, defaultManagedObjectContext());
    for(int i=0;i<paths.count;i++){
        if([[[paths objectAtIndex:i] levelId] isEqualToString:levelId]){
            return [paths objectAtIndex:i];
        }
    }

    
    //StoryLevels *level = (StoryLevels *)fetchManagedObject(entityName, predicate,NULL, defaultManagedObjectContext());
    
    return NULL;
}
+(NSArray *)getAllLevels
{
    
    NSArray *levels = fetchManagedObjects(entityName, NULL, NULL, defaultManagedObjectContext());
    
    return levels;
}
+(NSArray *)getAllLevelsWithPath:(NSString*)pathId storyId:(NSString*)storyId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(storyId==%@) AND (pathId == %@)",[NSString stringWithFormat:@"%@",storyId],[NSString stringWithFormat:@"%@",pathId]];
  //  NSPredicate *p=[NSPredicate predicateWithFormat:<#(NSString *), ...#>]
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
    [StoryLevels deleteAllLevels:moc];
}

@end