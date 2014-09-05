//
//  StoryPathManager.m
//  Singpath
//
//  Created by Rishik on 31/10/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "StoryPathManager.h"

static NSString *entityName = @"StoryPaths";

@implementation StoryPaths ( Management )

+(StoryPaths *)insertPath:(NSString*)pathID pathName:(NSString*)pathName storyId:(NSString*)storyId pathsStory:(NSSet*)pathsStory managedObjectContext:(NSManagedObjectContext*)moc
{
    StoryPaths *storyPaths=(StoryPaths *) [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                        inManagedObjectContext:moc];
    
    storyPaths.pathId=pathID;
    storyPaths.pathName=pathName;
    storyPaths.storyId=storyId;
    storyPaths.pathsStory=pathsStory;
    
    return storyPaths;
}

+(StoryPaths *)insertPath:(NSString*)pathID pathName:(NSString*)pathName storyId:(NSString*)storyId pathsStory:(NSSet*)pathsStory
{
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    return [StoryPaths insertPath:pathID pathName:pathName storyId:storyId pathsStory:pathsStory managedObjectContext:moc];
}

+(StoryPaths *)getPathWithId:(NSString *)pathId storyId:(NSString*)storyId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storyId == %@", storyId];
    
    NSArray *paths = fetchManagedObjects(entityName, predicate, NULL, defaultManagedObjectContext());
    for(int i=0;i<paths.count;i++){
        if([[[paths objectAtIndex:i] pathId] isEqualToString:pathId]){
            return [paths objectAtIndex:i];
        }
    }
   // StoryPaths *path = (StoryPaths *)fetchManagedObject(entityName, predicate,NULL, defaultManagedObjectContext());
    
    return NULL;
}
+(NSArray *)getPathsWithStoryId:(NSString*)storyId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storyId == %@", storyId];
    
    NSArray *paths = fetchManagedObjects(entityName, predicate, NULL, defaultManagedObjectContext());
    
    return paths;
}
+(NSArray *)getAllPaths
{
    NSArray *paths = fetchManagedObjects(entityName, NULL, NULL, defaultManagedObjectContext());
    
    return paths;
}
+(void)deleteAllPaths:(NSManagedObjectContext*)moc
{
    NSArray *allPaths=[self getAllPaths];
    for(int i=0;i<allPaths.count;i++){
        [moc deleteObject:[allPaths objectAtIndex:i]];
    }
}
+(void)deleteAllPaths
{
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    [StoryPaths deleteAllPaths:moc];
}

@end