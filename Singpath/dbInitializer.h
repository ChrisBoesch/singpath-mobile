//
//  
//  Singpath
//
//  Created by Rishik Bahri on 26/08/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paths.h"
#import "Levels.h"

@interface dbInitializer : NSObject


-(void)checkPaths;
-(void) checkLevels: (NSString*) pathid :(Paths *) path;
-(void) checkQuestions: (NSString*)levelId level:(Levels*) sentLevel;
-(void)checkStory;

- (NSMutableArray *)getAllPaths;


@end
