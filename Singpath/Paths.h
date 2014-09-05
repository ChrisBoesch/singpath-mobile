//
//  Paths.h
//  Singpath
//
//  Created by Rishik on 22/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Levels;

@interface Paths : NSManagedObject

@property (nonatomic) BOOL downloaded;
@property (nonatomic, retain) NSString * pathId;
@property (nonatomic, retain) NSString * pathName;
@property (nonatomic, retain) NSSet *pathLevels;
@end

@interface Paths (CoreDataGeneratedAccessors)

- (void)addPathLevelsObject:(Levels *)value;
- (void)removePathLevelsObject:(Levels *)value;
- (void)addPathLevels:(NSSet *)values;
- (void)removePathLevels:(NSSet *)values;

@end
