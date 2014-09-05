//
//  StoryQuestionsManager.h
//  Singpath
//
//  Created by Rishik on 31/10/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "StoryQuestions.h"
#import "ModelUtil.h"
#import "StoryLevels.h"


@interface StoryQuestions ( Management )

+(StoryQuestions *)insertQuestion:(int)order pathId:(NSString*)pathId levelId:(NSString*)levelId questionId:(NSString*)questionId completed:(BOOL)completed questionLevel:(StoryLevels*)questionLevel managedObjectContext:(NSManagedObjectContext*)moc;
+(StoryQuestions *)insertQuestion:(int)order pathId:(NSString*)pathId levelId:(NSString*)levelId  questionId:(NSString*)questionId completed:(BOOL)completed questionLevel:(StoryLevels*)questionLevel;
+(StoryQuestions *)getQuestionWithId:(NSString *)levelId questionId:(NSString*)questionId;

+(NSArray *)getAllQuestions;
+(void)deleteAllQuestions:(NSManagedObjectContext*)moc;
+(void)deleteAllQuestions;


@end