//
//  Achievments.h
//  Singpath
//
//  Created by Rishik on 22/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Users;

@interface Achievments : NSManagedObject

@property (nonatomic, retain) NSString * descrip;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) BOOL unlocked;
@property (nonatomic, retain) Users *usersAchievments;

@end
