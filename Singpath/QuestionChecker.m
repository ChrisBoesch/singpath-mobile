//
//  QuestionChecker.m
//  Singpath
//
//  Created by Rishik Bahri on 04/07/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "QuestionChecker.h"
#import "StoryLevels.h"
#import "StoryQuestions.h"

@implementation QuestionChecker
@synthesize questions=questions,answers=answers,counter=counter,nonErrorResults=nonErrorResults,solved=solved,questionId=questionId,consoleValues=consoleValues,hintValues=hintValues;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil problemId:(NSString *) pId
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self){
           
    }
    return self;
}


// Initialize arrays For gameplay
// Loads all permuations of questions to figure out what is Compilable, Incompilable, Correct
-(void)initialiseArrays: (NSString *)problemsetId{
    NSString *urlStr=[NSString stringWithFormat:@"p_%@",problemsetId];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:urlStr ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if(data==NULL){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *newPath=[path stringByAppendingPathComponent:urlStr];
        newPath=[newPath stringByAppendingFormat:@".json"];
        data = [NSData dataWithContentsOfFile:newPath];
    }
    NSMutableArray *tempQuestions=[[NSMutableArray alloc] init];
    NSMutableArray *tempAnswers=[[NSMutableArray alloc] init];
    NSMutableArray *tempNonErrorResults=[[NSMutableArray alloc] init];
    NSMutableArray *tempSolved=[[NSMutableArray alloc] init];
    NSMutableArray *questionIndex=[[NSMutableArray alloc] init];
    NSMutableArray *tempConsoleValues=[[NSMutableArray alloc] init];
    NSMutableArray *tempHints=[[NSMutableArray alloc] init];
    
    
    questionId=[[NSMutableArray alloc] init];
    NSError* error;
    NSDictionary* json1 = [NSJSONSerialization
                              JSONObjectWithData:data //1
                              
                              options:kNilOptions
                              error:&error];
 
    NSArray *json=[json1 valueForKey:@"problems"];
        if (!json) {
            NSLog(@"Error parsing JSON: %@", error);
        } else {
                                     
            for(NSString *keyStr in json ) {
                [questionId addObject:[keyStr valueForKey:@"id"]];
                
                [tempQuestions addObject:[keyStr valueForKey:@"description"]];
                [questionIndex addObject:[keyStr valueForKey:@"problemsetorder"]];
                [tempHints addObject:[keyStr valueForKey:@"examples"]];
                NSMutableArray *temp=[[NSMutableArray alloc] init];
                NSMutableArray *temp2=[[NSMutableArray alloc] init];
                NSMutableArray *temp3=[[NSMutableArray alloc] init];
                NSMutableArray *temp4=[[NSMutableArray alloc] init];
                for (NSString *strs in [keyStr valueForKey:@"lines"]) {
                    [temp addObject:strs];
                }
                NSMutableDictionary *objNonErrorResult=[keyStr valueForKey:@"nonErrorResults" ];
                                                        
                for(NSString *strs in objNonErrorResult){
                    [temp2 addObject:strs];
                    NSDictionary *tempStore=[objNonErrorResult objectForKey:strs];
                    [temp3 addObject:[tempStore valueForKey:@"solved"]];
                    [temp4 addObject:[tempStore valueForKey:@"results"]];
                  
                    
                }
                [tempAnswers addObject:temp];
                [tempNonErrorResults addObject:temp2];
                [tempSolved addObject:temp3];
                [tempConsoleValues addObject:temp4];
                
                temp=NULL;
                temp2=NULL;
                temp3=NULL;
                temp4=NULL;
            }
            counter=0;
            for(int i=0;i<[questionIndex count]-1;i++){
                for(int j=i;j<[questionIndex count];j++){
                    id objIDi=[questionIndex objectAtIndex:i];
                    NSString *objSTRi= (@"%@",objIDi);
                    int objINTi=[objSTRi intValue];
                    id objIDj=[questionIndex objectAtIndex:j];
                    NSString *objSTRj= (@"%@",objIDj);
                    int objINTj=[objSTRj intValue];
                    
                    
                    if(objINTi>objINTj){
                        id tempIndex=[questionIndex objectAtIndex:i];
                        [questionIndex replaceObjectAtIndex:i withObject:[questionIndex objectAtIndex:j]];
                        [questionIndex replaceObjectAtIndex:j withObject:tempIndex];
                        
                        id tempQuestionIndex=[tempQuestions objectAtIndex:i];
                        [tempQuestions replaceObjectAtIndex:i withObject:[tempQuestions objectAtIndex:j]];
                        [tempQuestions replaceObjectAtIndex:j withObject:tempQuestionIndex];
                        
                        id tempAnswerIndex=[tempAnswers objectAtIndex:i];
                        [tempAnswers replaceObjectAtIndex:i withObject:[tempAnswers objectAtIndex:j]];
                        [tempAnswers replaceObjectAtIndex:j withObject:tempAnswerIndex];
                        
                        id tempNonErrorResultIndex=[tempNonErrorResults objectAtIndex:i];
                        [tempNonErrorResults replaceObjectAtIndex:i withObject:[tempNonErrorResults objectAtIndex:j]];
                        [tempNonErrorResults replaceObjectAtIndex:j withObject:tempNonErrorResultIndex];
                        
                        id tempSolvedIndex=[tempSolved objectAtIndex:i];
                        [tempSolved replaceObjectAtIndex:i withObject:[tempSolved objectAtIndex:j]];
                        [tempSolved replaceObjectAtIndex:j withObject:tempSolvedIndex];
                        
                        id tempConsoleValuesIndex=[tempConsoleValues objectAtIndex:i];
                        [tempConsoleValues replaceObjectAtIndex:i withObject:[tempConsoleValues objectAtIndex:j]];
                        [tempConsoleValues replaceObjectAtIndex:j withObject:tempConsoleValuesIndex];
                        
                        id tempHintsIndex=[tempHints objectAtIndex:i];
                        [tempHints replaceObjectAtIndex:i withObject:[tempHints objectAtIndex:j]];
                        [tempHints replaceObjectAtIndex:j withObject:tempHintsIndex];
                        
                        id questionIdIndex=[self.questionId objectAtIndex:i];
                        [questionId  replaceObjectAtIndex:i withObject:[self.questionId  objectAtIndex:j]];
                        [questionId replaceObjectAtIndex:j withObject:questionIdIndex];


                        
                        
                    }
                }
            }
            questions=tempQuestions;
            answers=tempAnswers;
            nonErrorResults=tempNonErrorResults;
            solved=tempSolved;
            consoleValues=tempConsoleValues;
            hintValues=tempHints;
        }
}
-(BOOL)checkStoryQuestion:(NSString*)questionId questionArray:(NSArray*)questionArray
{

    for(int i=0;i<questionArray.count;i++){
        StoryQuestions *currentQuestion=[questionArray objectAtIndex:i];
        NSString *questionID=[NSString stringWithFormat:@"%@",[currentQuestion questionId]];

        if([questionID isEqualToString:[NSString stringWithFormat:@"%@",questionId]]){
            return TRUE;
        }
    }
    return FALSE;
}
-(void)initialiseStoryArrays: (StoryLevels *)level{
    NSString *levelId=level.levelId;
    
    if([level video]){
        
    }else{
        
        NSArray *questionsObj=[NSArray arrayWithArray:[level.hasQuestions allObjects]];
        levelId=[levelId substringToIndex:[levelId length]-2];
        NSString *urlStr=[NSString stringWithFormat:@"p_%@",levelId];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:urlStr ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if(data==NULL){
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *newPath=[path stringByAppendingPathComponent:urlStr];
            newPath=[newPath stringByAppendingFormat:@".json"];
            data = [NSData dataWithContentsOfFile:newPath];
        }
        NSMutableArray *tempQuestions=[[NSMutableArray alloc] init];
        NSMutableArray *tempAnswers=[[NSMutableArray alloc] init];
        NSMutableArray *tempNonErrorResults=[[NSMutableArray alloc] init];
        NSMutableArray *tempSolved=[[NSMutableArray alloc] init];
        NSMutableArray *questionIndex=[[NSMutableArray alloc] init];
        NSMutableArray *tempConsoleValues=[[NSMutableArray alloc] init];
        NSMutableArray *tempHints=[[NSMutableArray alloc] init];
        
        
        questionId=[[NSMutableArray alloc] init];
        NSError* error;
        NSDictionary* json1 = [NSJSONSerialization
                               JSONObjectWithData:data //1
                               
                               options:kNilOptions
                               error:&error];
        
        NSArray *json=[json1 valueForKey:@"problems"];
        if (!json) {
            NSLog(@"Error parsing JSON: %@", error);
        } else {
            
            for(NSString *keyStr in json ) {
                if([self checkStoryQuestion:[keyStr valueForKey:@"id"] questionArray:questionsObj]){
                    [questionId addObject:[keyStr valueForKey:@"id"]];
                    
                    [tempQuestions addObject:[keyStr valueForKey:@"description"]];
                    [questionIndex addObject:[keyStr valueForKey:@"problemsetorder"]];
                    [tempHints addObject:[keyStr valueForKey:@"examples"]];
                    NSMutableArray *temp=[[NSMutableArray alloc] init];
                    NSMutableArray *temp2=[[NSMutableArray alloc] init];
                    NSMutableArray *temp3=[[NSMutableArray alloc] init];
                    NSMutableArray *temp4=[[NSMutableArray alloc] init];
                    for (NSString *strs in [keyStr valueForKey:@"lines"]) {
                        [temp addObject:strs];
                    }
                    NSMutableDictionary *objNonErrorResult=[keyStr valueForKey:@"nonErrorResults" ];
                    
                    for(NSString *strs in objNonErrorResult){
                        [temp2 addObject:strs];
                        NSDictionary *tempStore=[objNonErrorResult objectForKey:strs];
                        [temp3 addObject:[tempStore valueForKey:@"solved"]];
                        [temp4 addObject:[tempStore valueForKey:@"results"]];
                        
                        
                    }
                    [tempAnswers addObject:temp];
                    [tempNonErrorResults addObject:temp2];
                    [tempSolved addObject:temp3];
                    [tempConsoleValues addObject:temp4];
                    
                    temp=NULL;
                    temp2=NULL;
                    temp3=NULL;
                    temp4=NULL;
                }
            }
            counter=0;
            for(int i=0;i<[questionIndex count]-1;i++){
                for(int j=i;j<[questionIndex count];j++){
                    id objIDi=[questionIndex objectAtIndex:i];
                    NSString *objSTRi= (@"%@",objIDi);
                    int objINTi=[objSTRi intValue];
                    id objIDj=[questionIndex objectAtIndex:j];
                    NSString *objSTRj= (@"%@",objIDj);
                    int objINTj=[objSTRj intValue];
                    
                    
                    if(objINTi>objINTj){
                        id tempIndex=[questionIndex objectAtIndex:i];
                        [questionIndex replaceObjectAtIndex:i withObject:[questionIndex objectAtIndex:j]];
                        [questionIndex replaceObjectAtIndex:j withObject:tempIndex];
                        
                        id tempQuestionIndex=[tempQuestions objectAtIndex:i];
                        [tempQuestions replaceObjectAtIndex:i withObject:[tempQuestions objectAtIndex:j]];
                        [tempQuestions replaceObjectAtIndex:j withObject:tempQuestionIndex];
                        
                        id tempAnswerIndex=[tempAnswers objectAtIndex:i];
                        [tempAnswers replaceObjectAtIndex:i withObject:[tempAnswers objectAtIndex:j]];
                        [tempAnswers replaceObjectAtIndex:j withObject:tempAnswerIndex];
                        
                        id tempNonErrorResultIndex=[tempNonErrorResults objectAtIndex:i];
                        [tempNonErrorResults replaceObjectAtIndex:i withObject:[tempNonErrorResults objectAtIndex:j]];
                        [tempNonErrorResults replaceObjectAtIndex:j withObject:tempNonErrorResultIndex];
                        
                        id tempSolvedIndex=[tempSolved objectAtIndex:i];
                        [tempSolved replaceObjectAtIndex:i withObject:[tempSolved objectAtIndex:j]];
                        [tempSolved replaceObjectAtIndex:j withObject:tempSolvedIndex];
                        
                        id tempConsoleValuesIndex=[tempConsoleValues objectAtIndex:i];
                        [tempConsoleValues replaceObjectAtIndex:i withObject:[tempConsoleValues objectAtIndex:j]];
                        [tempConsoleValues replaceObjectAtIndex:j withObject:tempConsoleValuesIndex];
                        
                        id tempHintsIndex=[tempHints objectAtIndex:i];
                        [tempHints replaceObjectAtIndex:i withObject:[tempHints objectAtIndex:j]];
                        [tempHints replaceObjectAtIndex:j withObject:tempHintsIndex];
                        
                        id questionIdIndex=[self.questionId objectAtIndex:i];
                        [questionId  replaceObjectAtIndex:i withObject:[self.questionId  objectAtIndex:j]];
                        [questionId replaceObjectAtIndex:j withObject:questionIdIndex];
                        
                        
                        
                        
                    }
                }
            }
            questions=tempQuestions;
            answers=tempAnswers;
            nonErrorResults=tempNonErrorResults;
            solved=tempSolved;
            consoleValues=tempConsoleValues;
            hintValues=tempHints;
        }
    }
    
}

// Pulls out the answer with the correct combination

- (NSMutableArray *)getSelectedOptions:(int)position{
    return [answers objectAtIndex:position];
}


// pulls out the hint with the correct combination
- (NSString *)getHintValue:(int) position{
    return [hintValues objectAtIndex:position];
}

// pulls out the question
- (NSString *)getQuestion:(int) position{
    return [questions objectAtIndex:position];
}

// pulls the order of answers and compares it with the array with all the possible answer
// proceeds if correct

-(BOOL)isCorrect:(NSMutableArray *) selectedChoices{
    NSMutableArray *nonErrorResult=[nonErrorResults objectAtIndex:counter];
    NSMutableArray *isSolved=[solved objectAtIndex:counter];
    NSString *givenAnswer=[[NSString alloc] init];
   //
    for(NSString *strs in selectedChoices){
        for(int i=0;i<[[answers objectAtIndex:counter] count];i++){
            NSMutableArray *tempArr=[answers objectAtIndex:counter];
            if([[tempArr objectAtIndex:i] isEqualToString:strs]){
                givenAnswer=[NSString stringWithFormat:@"%@%@", givenAnswer,[NSString stringWithFormat:@"%d", (i+1)]];
                break;
            }
        }
    }
    for(int i=0;i<[nonErrorResult count];i++){
        if([[nonErrorResult objectAtIndex:i] isEqualToString:givenAnswer]){
            if([[isSolved objectAtIndex:i]integerValue]==1 ){

                return TRUE;
            }
        }
    }
    return FALSE;
}

// Used to display what needs to be shown in Console.


-(NSMutableArray*)consoleData: (NSMutableArray *) selectedChoices{
    NSMutableArray *nonErrorResult=[nonErrorResults objectAtIndex:counter];
    NSMutableArray *isSolved=[solved objectAtIndex:counter];
    NSString *givenAnswer=[[NSString alloc] init];
    
    NSMutableArray *consoleErrors=[consoleValues objectAtIndex:counter];
    NSLog(@"%@",[consoleValues objectAtIndex:counter]);
    for(NSString *strs in selectedChoices){
        for(int i=0;i<[[answers objectAtIndex:counter] count];i++){
            NSMutableArray *tempArr=[answers objectAtIndex:counter];
            if([[tempArr objectAtIndex:i] isEqualToString:strs]){
                givenAnswer=[NSString stringWithFormat:@"%@%@", givenAnswer,[NSString stringWithFormat:@"%d", (i+1)]];
                break;
            }
        }
    }
    for(int i=0;i<[nonErrorResult count];i++){
        if([[nonErrorResult objectAtIndex:i] isEqualToString:givenAnswer]){
            if([[isSolved objectAtIndex:i]integerValue]==1 ){
                NSLog(@"%@",[consoleErrors objectAtIndex:i]);
                return [consoleErrors objectAtIndex:i];
            }else {
                return [consoleErrors objectAtIndex:i];
            }
        }
    }
    return nil;
}


-(NSString*)feedback:(NSMutableArray *) selectedChoices{
    NSMutableArray *nonErrorResult=[nonErrorResults objectAtIndex:counter];
    NSMutableArray *isSolved=[solved objectAtIndex:counter];
    NSString *givenAnswer=[[NSString alloc] init];
    
    NSMutableArray *consoleErrors=[consoleValues objectAtIndex:counter];
    
    for(NSString *strs in selectedChoices){
        for(int i=0;i<[[answers objectAtIndex:counter] count];i++){
            NSMutableArray *tempArr=[answers objectAtIndex:counter];
            if([[tempArr objectAtIndex:i] isEqualToString:strs]){
                givenAnswer=[NSString stringWithFormat:@"%@%@", givenAnswer,[NSString stringWithFormat:@"%d", (i+1)]];
                break;
            }
        }
    }
    for(int i=0;i<[nonErrorResult count];i++){
        if([[nonErrorResult objectAtIndex:i] isEqualToString:givenAnswer]){
            if([[isSolved objectAtIndex:i]integerValue]==1 ){
                
                return @"Correct!";
            }else {
                return [NSString stringWithFormat:@"%@",[consoleErrors objectAtIndex:i]];
            }
        }
    }
    return @"Uncompilable!";
}


@end
