//
//  AchievmentManager.h
//  Singpath
//
//  Created by Rishik Bahri on 28/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "Achievments.h"
#import "ModelUtil.h"


@interface Achievments ( Management )

+(Achievments *)insertAchievment:(NSString *)name unlocked:(BOOL)unlocked descrip:(NSString*)descrip achievmentUser:(Users*)achievmentUser managedObjectContext:(NSManagedObjectContext*)moc;
+(Achievments *)insertAchievment:(NSString *)name unlocked:(BOOL)unlocked descrip:(NSString*)descrip achievmentUser:(Users*)achievmentUser;

+(NSArray *)getAllAchievments;
+(Achievments *)getPerticularAchievment:(NSString*)name;


@end