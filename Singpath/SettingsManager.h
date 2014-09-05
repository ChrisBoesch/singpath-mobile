//
//  SettingsManager.h
//  Singpath
//
//  Created by Rishik on 22/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "ModelUtil.h"
#import "Settings.h"

@interface Settings ( Management )

+(Settings *)insertSetting:(BOOL)autoCompile autoAdvance:(BOOL)autoAdvance  managedObjectContext:(NSManagedObjectContext*)moc;

+(Settings *)insertSetting:(BOOL)autoCompile autoAdvance:(BOOL)autoAdvance;

+(Settings *)getSettings;




@end
