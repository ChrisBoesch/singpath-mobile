//
//  StoryQuestionsManager.m
//  Singpath
//
//  Created by Rishik on 31/10/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "StoryQuestionsManager.h"

static NSString *entityName = @"StoryQuestions";

@implementation StoryQuestions ( Management )

+(StoryQuestions *)insertQuestion:(int)order pathId:(NSString*)pathId levelId:(NSString*)levelId questionId:(NSString*)questionId completed:(BOOL)completed questionLevel:(StoryLevels*)questionLevel managedObjectContext:(NSManagedObjectContext*)moc
{
    StoryQuestions *question=(StoryQuestions *) [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                                    inManagedObjectContext:moc];
    
    question.order=order;
    question.pathId=pathId;
    question.levelId=levelId;
    question.questionId=questionId;
    question.completed=completed;
    question.questionLevel=questionLevel;
    
    return question;
}

+(StoryQuestions *)insertQuestion:(int)order pathId:(NSString*)pathId levelId:(NSString*)levelId questionId:(NSString*)questionId completed:(BOOL)completed questionLevel:(StoryLevels*)questionLevel
{
    
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    return [StoryQuestions insertQuestion:order pathId:pathId levelId:levelId questionId:questionId completed:completed questionLevel:questionLevel managedObjectContext:moc];
}

+(StoryQuestions *)getQuestionWithId:(NSString *)levelId questionId:(NSString*)questionId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"levelId == %@", levelId];
    
    
    NSArray *questions =fetchManagedObjects(entityName, predicate, NULL, defaultManagedObjectContext());
    for(int i=0;i<questions.count;i++){
        StoryQuestions *tempQuestion=[questions objectAtIndex:i];
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
    [StoryQuestions deleteAllQuestions:moc];
}


@end