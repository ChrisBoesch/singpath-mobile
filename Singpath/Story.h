//
//  Story.h
//  Singpath
//
//  Created by Rishik on 22/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StoryPaths;

@interface Story : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *storyPaths;
@end

@interface Story (CoreDataGeneratedAccessors)

- (void)addStoryPathsObject:(StoryPaths *)value;
- (void)removeStoryPathsObject:(StoryPaths *)value;
- (void)addStoryPaths:(NSSet *)values;
- (void)removeStoryPaths:(NSSet *)values;

@end
