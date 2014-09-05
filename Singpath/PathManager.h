//
//  PathManager.h
//  Singpath
//
//  Created by Rishik Bahri on 03/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "Paths.h"
#import "ModelUtil.h"


@interface Paths ( Management )

+(Paths *)insertPath:(NSString*)pathID pathName:(NSString*)pathName isDownloaded:(BOOL)isDownloaded  managedObjectContext:(NSManagedObjectContext*)moc;
+(Paths *)insertPath:(NSString*)pathID pathName:(NSString*)pathName isDownloaded:(BOOL)isDownloaded;
+(Paths *)getPathWithId:(NSString *)pathId;
+(NSArray *)getAllPaths;
+(void)deleteAllPaths:(NSManagedObjectContext*)moc;
+(void)deleteAllPaths;


@end
