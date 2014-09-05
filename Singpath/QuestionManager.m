//
//  QuestionManager.m
//  Singpath
//
//  Created by Rishik Bahri on 04/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "QuestionManager.h"

static NSString *entityName = @"Questions";

@implementation Questions ( Management )

+(Questions *)insertQuestion:(NSString *)levelId questionId:(NSString*)questionId completed:(BOOL)completed timeTaken:(int)timeTaken nonCompilableTries:(int)nonCompilableTries wrongCompilableTries:(int)wrongCompilableTries questionLevel:(Levels*)questionLevel managedObjectContext:(NSManagedObjectContext*)moc
{
    Questions *question=(Questions *) [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                        inManagedObjectContext:moc];
    
    question.levelId=levelId;
    question.questionId=questionId;
    question.completed=completed;
    question.time=timeTaken;
    question.nonCompilableTries=nonCompilableTries;
    question.wrongCompilableTries=wrongCompilableTries;
    question.questionLevel=questionLevel;
    return question;
}

+(Questions *)insertQuestion:(NSString *)levelId questionId:(NSString*)questionId completed:(BOOL)completed timeTaken:(int)timeTaken nonCompilableTries:(int)nonCompilableTries wrongCompilableTries:(int)wrongCompilableTries questionLevel:(Levels*)questionLevel
{
    
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    return [Questions insertQuestion:levelId questionId:questionId completed:completed timeTaken:timeTaken nonCompilableTries:nonCompilableTries wrongCompilableTries:wrongCompilableTries questionLevel:questionLevel managedObjectContext:moc];
}

+(Questions *)getQuestionWithId:(NSString *)levelId questionId:(NSString*)questionId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"levelId == %@", levelId];
    
    
    NSArray *questions =fetchManagedObjects(entityName, predicate, NULL, defaultManagedObjectContext());
    for(int i=0;i<questions.count;i++){
        Questions *tempQuestion=[questions objectAtIndex:i];
        if([[tempQuestion questionId] isEqualToString:questionId]){
            return tempQuestion;
        }
    }
    return NULL;
}
+(NSArray *)getAllQuestions
{
  
    
    NSArray *questions = fetchManagedObjects(entityName, NULL, NULL, defaultManagedObjectContext());
    
    return questions;
}
+(void)deleteAllQuestions:(NSManagedObjectContext*)moc
{
    NSArray *allQuestions=[self getAllQuestions];
    for(int i=0;i<allQuestions.count;i++){
        [moc deleteObject:[allQuestions objectAtIndex:i]];
    }
}
+(void)deleteAllQuestions
{
    NSManagedObjectContext *moc = defaultManagedObjectContext();
     [Questions deleteAllQuestions:moc];
}


@end
