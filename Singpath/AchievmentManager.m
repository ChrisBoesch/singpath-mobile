//
//  AchievmentManager.m
//  Singpath
//
//  Created by Rishik Bahri on 28/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "AchievmentManager.h"

static NSString *entityName = @"Achievments";

@implementation Achievments ( Management )

+(Achievments *)insertAchievment:(NSString *)name unlocked:(BOOL)unlocked descrip:(NSString*)descrip achievmentUser:(Users*)achievmentUser managedObjectContext:(NSManagedObjectContext*)moc
{
    Achievments *achievment=(Achievments *) [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                                    inManagedObjectContext:moc];
    
    achievment.name=name;
    achievment.unlocked=unlocked;
    achievment.descrip=descrip;
    achievment.usersAchievments=achievmentUser;
    return achievment;
}

+(Achievments *)insertAchievment:(NSString *)name unlocked:(BOOL)unlocked descrip:(NSString*)descrip achievmentUser:(Users*)achievmentUser
{
    
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    return [Achievments insertAchievment:name unlocked:unlocked descrip:descrip achievmentUser:achievmentUser managedObjectContext:moc];
}

+(NSArray *)getAllAchievments
{
     
    NSArray *achievments = fetchManagedObjects(entityName, NULL, NULL, defaultManagedObjectContext());
    
    return achievments;
}
+(Achievments *)getPerticularAchievment:(NSString*)name
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    
    
    NSArray *achievment =fetchManagedObjects(entityName, predicate, NULL, defaultManagedObjectContext());
    if(achievment.count>0){
        return [achievment objectAtIndex:0];
    }
        return NULL;
}

@end
