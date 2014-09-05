//
//  Users.h
//  Singpath
//
//  Created by Rishik on 22/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Achievments;

@interface Users : NSManagedObject

@property (nonatomic) BOOL sound;
@property (nonatomic, retain) NSSet *hasAchievments;
@end

@interface Users (CoreDataGeneratedAccessors)

- (void)addHasAchievmentsObject:(Achievments *)value;
- (void)removeHasAchievmentsObject:(Achievments *)value;
- (void)addHasAchievments:(NSSet *)values;
- (void)removeHasAchievments:(NSSet *)values;

@end
