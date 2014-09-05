//
//  PathManager.m
//  Singpath
//
//  Created by Rishik Bahri on 03/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "PathManager.h"

static NSString *entityName = @"Paths";

@implementation Paths ( Management )

+(Paths *)insertPath:(NSString*)pathID pathName:(NSString*)pathName isDownloaded:(BOOL)isDownloaded  managedObjectContext:(NSManagedObjectContext*)moc
{
    Paths *path=(Paths *) [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                        inManagedObjectContext:moc];

    path.pathId=pathID;
    path.pathName=pathName;
    path.downloaded=isDownloaded;
    
    
    return path;
}

+(Paths *)insertPath:(NSString*)pathID pathName:(NSString*)pathName isDownloaded:(BOOL)isDownloaded
{
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    return [Paths insertPath:pathID pathName:pathName isDownloaded:isDownloaded managedObjectContext:moc];
}

+(Paths *)getPathWithId:(NSString *)pathId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathId == %@", pathId];
    
    
    Paths *path = (Paths *)fetchManagedObject(entityName, predicate,NULL, defaultManagedObjectContext());

    return path;
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
     [Paths deleteAllPaths:moc];
}

@end
