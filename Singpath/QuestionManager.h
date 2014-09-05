//
//  QuestionManager.h
//  Singpath
//
//  Created by Rishik Bahri on 04/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "Questions.h"
#import "ModelUtil.h"


@interface Questions ( Management )

+(Questions *)insertQuestion:(NSString *)levelId questionId:(NSString*)questionId completed:(BOOL)completed timeTaken:(int)timeTaken nonCompilableTries:(int)nonCompilableTries wrongCompilableTries:(int)wrongCompilableTries questionLevel:(Levels*)questionLevel managedObjectContext:(NSManagedObjectContext*)moc;
+(Questions *)insertQuestion:(NSString *)levelId questionId:(NSString*)questionId completed:(BOOL)completed timeTaken:(int)timeTaken nonCompilableTries:(int)nonCompilableTries wrongCompilableTries:(int)wrongCompilableTries questionLevel:(Levels*)questionLevel;
+(Questions *)getQuestionWithId:(NSString *)levelId questionId:(NSString*)questionId;

+(NSArray *)getAllQuestions;
+(void)deleteAllQuestions:(NSManagedObjectContext*)moc;
+(void)deleteAllQuestions;


@end