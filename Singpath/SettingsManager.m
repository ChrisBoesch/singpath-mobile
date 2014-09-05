//
//  SettingsManager.m
//  Singpath
//
//  Created by Rishik on 22/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "SettingsManager.h"

static NSString *entityName = @"Settings";

@implementation Settings ( Management )

+(Settings *)insertSetting:(BOOL)autoCompile autoAdvance:(BOOL)autoAdvance  managedObjectContext:(NSManagedObjectContext*)moc
{
    Settings *setting=(Settings *) [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                                     inManagedObjectContext:moc];
    
    setting.autoAdvance=autoAdvance;
    setting.autoComplete=autoCompile;
    return setting;
}

+(Settings *)insertSetting:(BOOL)autoCompile autoAdvance:(BOOL)autoAdvance
{
    
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    return [Settings insertSetting:autoCompile autoAdvance:autoAdvance managedObjectContext:moc];
}

+(Settings *)getSettings
{
    
    NSArray *levels = fetchManagedObjects(entityName, NULL, NULL, defaultManagedObjectContext());
    
    return levels[0];
}

@end
