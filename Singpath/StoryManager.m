//
//  StoryManager.m
//  Singpath
//
//  Created by Rishik on 31/10/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "StoryManager.h"

static NSString *entityName = @"Story";

@implementation Story ( Management )

+(Story*)insertStory:(NSString*)id name:(NSString*)name managedObjectContext:(NSManagedObjectContext*)moc
{
    Story *story=(Story *) [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                        inManagedObjectContext:moc];
    
    story.id=id;
    story.name=name;
    return story;
}

+(Story*)insertStory:(NSString*)id name:(NSString*)name
{
    
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    return [Story insertStory:id name:name managedObjectContext:moc];
}

+(NSArray *)getAllStories
{
    
    NSArray *stories = fetchManagedObjects(entityName, NULL, NULL, defaultManagedObjectContext());
    
    return stories;
}
+(Story *)getStoryWithId:(NSString*)storyId
{
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", storyId];
    
    
    Story *story = (Story *)fetchManagedObject(entityName, predicate,NULL, defaultManagedObjectContext());
    
    return story;

}

@end