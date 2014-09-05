//
//  StoryManager.h
//  Singpath
//
//  Created by Rishik on 31/10/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "Story.h"
#import "ModelUtil.h"


@interface Story ( Management )

+(Story*)insertStory:(NSString*)id name:(NSString*)name managedObjectContext:(NSManagedObjectContext*)moc;
+(Story*)insertStory:(NSString*)id name:(NSString*)name;

+(NSArray *)getAllStories;
+(Story *)getStoryWithId:(NSString*)storyId;


@end
