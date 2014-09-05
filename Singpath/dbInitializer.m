//
//  dbInitializer.m
//  Singpath
//
//  Created by Rishik Bahri on 26/08/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "dbInitializer.h"
#import "Levels.h"
#import "StoryPaths.h"
#import "StoryLevels.h"

#import "PathManager.h"
#import "LevelManager.h"
#import "QuestionManager.h"
#import "UserManager.h"
#import "AchievmentManager.h"
#import "StoryManager.h"
#import "StoryPathManager.h"
#import "StoryLevelManager.h"
#import "StoryQuestions.h"
#import "StoryQuestionsManager.h"
#import "Settings.h"
#import "SettingsManager.h"
@implementation dbInitializer


-(void)checkStory
{
    
 //   NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                               //   pathForResource:@"p_6920764" ofType:@"json"]];
   /* NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"json"];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];

    NSError *error=Nil;
   // [[NSFileManager defaultManager] copyItemAtPath:[url path] toPath:path error:&error];
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:path error:&error];
    //[self copyResources];*/
    
    if([StoryPaths getAllPaths].count==0){
        Story *firstStory=[Story insertStory:@"s_1" name:@"First Story"];

        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mobile_paths" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray *pathName=[[NSMutableArray alloc] init];
        NSArray *pathIds=[[NSMutableArray alloc] init];
        if (!json) {
            NSLog(@"Error parsing JSON: %@", error);
        } else {
            pathName=[json valueForKey:@"description"];
            pathIds=[json valueForKey:@"path_id"];
            
        }
      //  NSLog(@"%@",pathName);
        for(int i=0;i<pathIds.count;i++){
            StoryPaths *p = [StoryPaths getPathWithId:[NSString stringWithFormat:@"%@",[pathIds objectAtIndex:i]] storyId:firstStory.id];
            

            if(!p){
                StoryPaths *insertedPath;
                insertedPath=[StoryPaths insertPath:[NSString stringWithFormat:@"%@",[pathIds objectAtIndex:i]] pathName:[pathName objectAtIndex:i] storyId:firstStory.id pathsStory:[NSSet setWithObject:firstStory]];
                              
                
                [self checkStoryLevels:[NSString stringWithFormat:@"%@",[pathIds objectAtIndex:i]]sentPath:insertedPath sentStory:firstStory];
            }
        }
    }else{
        NSLog(@"Already in DB");
    }
}
// Story Mode
// method that Initializes the story path into the Database
// It assigns  all videos with level intervals
// Plays the first video if the user is starting at level 1

-(void) checkStoryLevels:(NSString*)pathid sentPath:(StoryPaths*)sentPath sentStory:(Story*)sentStory
{
    NSString *urlStr=[NSString stringWithFormat:@"l_%@",pathid];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:urlStr ofType:@"json"];
    int videoNumber=1;
    int levelNumber=1;
    int levelNameTag=1;
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *levelName=[[NSMutableArray alloc] init];
    NSArray *levelId=[[NSMutableArray alloc] init];
    
  //  NSLog(@"%@",json);
    NSArray *numberOfQuestions=[[NSArray alloc] init];
    if (!json) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        levelName=[[json valueForKey:@"problemsets" ] valueForKey:@"description"];
        levelId=[[json valueForKey:@"problemsets" ] valueForKey:@"id"];
        numberOfQuestions=[[json valueForKey:@"problemsets" ] valueForKey:@"numProblems"];
    }
    BOOL check=TRUE;
    for(int i=0;i<levelId.count;i++){
        StoryLevels *l=[StoryLevels getLevelWithId:[NSString stringWithFormat:@"%@",[levelId objectAtIndex:i] ]storyId:sentStory.id];
        
        
        
        if(!l){
            if(![numberOfQuestions objectAtIndex:i]==0){
                
                    
                    
                    
                    
                   
                    
                NSString *firstStory=[NSString stringWithFormat:@"Scene%i_%@",videoNumber,sentStory.id];
                NSLog(@"%@",firstStory);
                NSString *firstLevel=[NSString stringWithFormat:@"%@_1",[levelId objectAtIndex:i]];
                NSString *secondLevel=[NSString stringWithFormat:@"%@_2",[levelId objectAtIndex:i]];
                
                
                if(levelNumber==1){
                    StoryLevels *insertFirstVideo=[StoryLevels insertLevel:firstStory levelName:[NSString stringWithFormat:@"%i",levelNumber] pathId:[NSString stringWithFormat:@"%@",[sentPath pathId]] storyId:[NSString stringWithFormat:@"%@",[sentStory id]] isCompleted:YES video:YES levelPath:sentPath levelNumber:levelNumber];
                }else{
                    StoryLevels *insertFirstVideo=[StoryLevels insertLevel:firstStory levelName:[NSString stringWithFormat:@"%i",levelNumber] pathId:[NSString stringWithFormat:@"%@",[sentPath pathId]] storyId:[NSString stringWithFormat:@"%@",[sentStory id]] isCompleted:NO video:YES levelPath:sentPath levelNumber:levelNumber];
                }
                
                
                
                
                
                levelNumber++;
                videoNumber++;
                firstStory=[NSString stringWithFormat:@"Scene%i_%@",videoNumber,sentStory.id];
                
                StoryLevels *insertFirstLevel=[StoryLevels insertLevel:firstLevel levelName:[NSString stringWithFormat:@"%i",levelNameTag] pathId:[NSString stringWithFormat:@"%@",[sentPath pathId]] storyId:[NSString stringWithFormat:@"%@",[sentStory id]] isCompleted:NO video:NO levelPath:sentPath levelNumber:levelNumber];
                [self checkStoryQuestions:[NSString stringWithFormat:@"%@",[sentPath pathId]] sentLevel:insertFirstLevel check:YES levelId:[NSString stringWithFormat:@"%@",[levelId objectAtIndex:i]]];
                levelNumber++;
                levelNameTag++;
                
                StoryLevels *insertsecondVideo=[StoryLevels insertLevel:firstStory levelName:[NSString stringWithFormat:@"%i",levelNumber] pathId:[NSString stringWithFormat:@"%@",[sentPath pathId]] storyId:[NSString stringWithFormat:@"%@",[sentStory id]] isCompleted:NO video:YES levelPath:sentPath levelNumber:levelNumber];
                
                levelNumber++;
                videoNumber++;
                
                firstStory=[NSString stringWithFormat:@"Scene%i_%@",videoNumber,sentStory.id];
                
                StoryLevels *insertSecondLevel=[StoryLevels insertLevel:secondLevel levelName:[NSString stringWithFormat:@"%i",levelNameTag] pathId:[NSString stringWithFormat:@"%@",[sentPath pathId]] storyId:[NSString stringWithFormat:@"%@",[sentStory id]] isCompleted:NO video:NO levelPath:sentPath levelNumber:levelNumber];
                [self checkStoryQuestions:[NSString stringWithFormat:@"%@",[sentPath pathId]] sentLevel:insertSecondLevel check:NO levelId:[NSString stringWithFormat:@"%@",[levelId objectAtIndex:i]]];
                levelNumber++;
                levelNameTag++;
                
                if(i==levelId.count-1){
                    firstStory=[NSString stringWithFormat:@"Scene%i_%@",videoNumber,sentStory.id];
                    StoryLevels *insertFirstVideo=[StoryLevels insertLevel:firstStory levelName:[NSString stringWithFormat:@"%i",levelNameTag] pathId:[NSString stringWithFormat:@"%@",[sentPath pathId]] storyId:[NSString stringWithFormat:@"%@",[sentStory id]] isCompleted:NO video:YES levelPath:sentPath levelNumber:levelNumber];
                    levelNumber++;
                    videoNumber++;
                    levelNameTag++;
                }
              //  [self checkQuestions:[NSString stringWithFormat:@"%@",[levelId objectAtIndex:i]] level:insertLevel];
            }
        }
    }
}

// Initializes the questions in a particular path for story mode.
// It also checks wheter once a question is completed, wheter the level is completed and wheter the Next video should be shown.

-(void) checkStoryQuestions: (NSString*)pathId sentLevel:(StoryLevels*)sentLevel check:(BOOL)check levelId:(NSString*)levelId
{
    
    NSString *urlStr=[NSString stringWithFormat:@"p_%@",levelId];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:urlStr ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    int num=1;
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data //1
                          
                          options:kNilOptions
                          error:&error];
    NSLog(@"%@",[json allKeys]);
    if (!json) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        int num=0;
        NSArray *problemsArray=[json valueForKey:@"problems"];
        for(int i=0;i<problemsArray.count;i++){
            if(check){
                if(num<5){
                    StoryQuestions *insertQuestion=[StoryQuestions insertQuestion:num pathId:pathId levelId:[NSString stringWithFormat:@"%@",sentLevel.levelId] questionId:[NSString stringWithFormat:@"%@",[[problemsArray objectAtIndex:i] valueForKey:@"id"]]completed:NO questionLevel:sentLevel];
                }
            }else{
                if(num>4 && num<10){
                    StoryQuestions *insertQuestion=[StoryQuestions insertQuestion:num pathId:pathId levelId:[NSString stringWithFormat:@"%@",sentLevel.levelId] questionId:[NSString stringWithFormat:@"%@",[[problemsArray objectAtIndex:i] valueForKey:@"id"]] completed:NO questionLevel:sentLevel];
                }
            }
            
            num++;
        }/*
        for(NSString *keyStr in [json allKeys]) {
            
            if(check){
                if(num<5){
                    NSLog(@"%@",keyStr);
                    StoryQuestions *insertQuestion=[StoryQuestions insertQuestion:num pathId:pathId levelId:[NSString stringWithFormat:@"%@",sentLevel.levelId] questionId:keyStr completed:NO questionLevel:sentLevel];
                }
            }else{
                if(num>4 && num<10){
                    StoryQuestions *insertQuestion=[StoryQuestions insertQuestion:num pathId:pathId levelId:[NSString stringWithFormat:@"%@",sentLevel.levelId] questionId:keyStr completed:NO questionLevel:sentLevel];
                }
            }
            
                   num++;
        }*/
    }
}


-(void) checkPaths
{
    // If there is nothing in the Database, then Create User and save all details into user.
    
    
    
    if([Paths getAllPaths].count==0){
        Users* user=[Users insertUser:NO];
        NSArray* achievmentName=[NSArray arrayWithObjects:@"Ace",@"n000b",@"Rockstar",@"Superstar",@"Baby Steps",@"Insider",nil];
        NSArray* achievementsDescrip=[NSArray arrayWithObjects:@"Complete 3 problems in a row with 0 errors",@"Hit a score of zero three times in a row",@"Get three stars on all levels in a Path",@"Get 3 stars in all levels",@"Complete One Level",@"Send us some feedback", nil];
        for(int i=0;i<achievmentName.count;i++){
            Achievments* achievment=[Achievments insertAchievment:[achievmentName objectAtIndex:i] unlocked:NO descrip:[achievementsDescrip objectAtIndex:i] achievmentUser:user];
        }
        Settings *setting =[Settings insertSetting:NO autoAdvance:NO];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mobile_paths" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];

        
        // calls out the paths and the corresponding levels in the paths
        // initialize all levels and all paths.
        // Parse all Json files in Database and use them.
        
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *pathName=[[NSMutableArray alloc] init];
    NSArray *pathIds=[[NSMutableArray alloc] init];
    if (!json) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        pathName=[json valueForKey:@"name"];
        pathIds=[json valueForKey:@"path_id"];
        
    }
    for(int i=0;i<pathIds.count;i++){
        Paths *p = [Paths getPathWithId:[NSString stringWithFormat:@"%@",[pathIds objectAtIndex:i]]];
        
 
        if(!p){
            Paths *insertedPath;
               
                insertedPath=[Paths insertPath:[NSString stringWithFormat:@"%@",[pathIds objectAtIndex:i]] pathName:[pathName objectAtIndex:i] isDownloaded:YES];
                [self checkLevels:[NSString stringWithFormat:@"%@",[pathIds objectAtIndex:i]]  :insertedPath];            
        }
    }
    }else{
        NSLog(@"Already in DB");
    }
}

// parses all levels in a path.
// Adds levels into path

-(void) checkLevels: (NSString*) pathid :(Paths*) sentPath
{
    NSString *urlStr=[NSString stringWithFormat:@"l_%@",pathid];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:urlStr ofType:@"json"];
   
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *levelName=[[NSMutableArray alloc] init];
    NSArray *levelId=[[NSMutableArray alloc] init];
    NSArray *numberOfQuestions=[[NSArray alloc] init];
    if (!json) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        levelName=[[json valueForKey:@"problemsets" ] valueForKey:@"description"];
        levelId=[[json valueForKey:@"problemsets" ] valueForKey:@"id"];
        numberOfQuestions=[[json valueForKey:@"problemsets" ] valueForKey:@"numProblems"];
    }
    
    for(int i=0;i<levelId.count;i++){
        Levels *l=[Levels getLevelWithId:[NSString stringWithFormat:@"%@",[levelId objectAtIndex:i]]];
        
        if(!l){
            if(![numberOfQuestions objectAtIndex:i]==0){
            Levels *insertLevel=[Levels insertLevel:[NSString stringWithFormat:@"%@",[levelId objectAtIndex:i]] levelName:[levelName objectAtIndex:i] isDownloaded:YES isCompleted:NO points:0 stars:0 time:0 pathId:pathid levelNumber:(i+1) levelPath:sentPath];
            [self checkQuestions:[NSString stringWithFormat:@"%@",[levelId objectAtIndex:i]] level:insertLevel];
            }
        }
    }
}

// parses Questions in a level
// Adds level into path.

-(void) checkQuestions: (NSString*)levelId level:(Levels*) sentLevel
{
    NSString *urlStr=[NSString stringWithFormat:@"p_%@",levelId];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:urlStr ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
       
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data //1
                          
                          options:kNilOptions
                          error:&error];
    
    if (!json) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        
        for(NSString *keyStr in [json allKeys]) {
            Questions *insertQuestion=[Questions insertQuestion:levelId questionId:keyStr completed:NO timeTaken:0 nonCompilableTries:0 wrongCompilableTries:0 questionLevel:sentLevel];
        }
    }
}
@end
