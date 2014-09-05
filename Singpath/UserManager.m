//
//  UserManager.m
//  Singpath
//
//  Created by Rishik Bahri on 28/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "UserManager.h"

static NSString *entityName = @"Users";

@implementation Users ( Management )

+(Users*)insertUser:(BOOL)sound managedObjectContext:(NSManagedObjectContext*)moc
{
    Users *user=(Users *) [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                                          inManagedObjectContext:moc];
    
    user.sound=sound;
    
    return user;
}

+(Users*)insertUser:(BOOL)sound
{
    
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    return [Users insertUser:sound managedObjectContext:moc];
}

+(NSArray *)getAllUsers
{
    
    NSArray *users = fetchManagedObjects(entityName, NULL, NULL, defaultManagedObjectContext());
    
    return users;
}

@end