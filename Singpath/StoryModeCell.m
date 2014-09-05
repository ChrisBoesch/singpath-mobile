//
//  StoryModeCell.m
//  Singpath
//
//  Created by Rishik on 25/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "StoryModeCell.h"
#import "ZipArchive.h"
#import "StoryManager.h"
#import "StoryPathManager.h"
#import "StoryLevelManager.h"
#import "StoryQuestions.h"
#import "StoryQuestionsManager.h"
#import "PathManager.h"
#import "Paths.h"
#import "LevelManager.h"
#import "QuestionManager.h"

@implementation StoryModeCell
@synthesize storyId=_storyId,storyNmae=_storyName,downloadLink=_downloadLink,storyOrder=_storyOrder,storyNumOfLvls=_storyNumOfLvls,storyNumOfVideos=_storyNumOfVideos,clickStory=_clickStory,loading=_loading,storyPaths=_storyPaths;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)buyItemButton{
    UIActivityIndicatorView *myIndicator = [[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.buyItem setTitle:@"" forState:UIControlStateNormal];
    
    // Position the spinner
    [myIndicator setCenter:CGPointMake(60.0, 30.0)];
    
    // Add to button
    
    // Start the animation
    [myIndicator startAnimating];

    
    
    [self.buyItem addSubview:myIndicator];
    
  //  [self.loading setBounds:self.superview.frame];
    UIView *vie=[[UIView alloc]initWithFrame:self.superview.superview.bounds];
    UIImageView *img=[[UIImageView alloc] initWithFrame:[vie bounds]];
    [img setImage:[UIImage imageNamed:@"greyOut"]];
    UIActivityIndicatorView *act=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(480, 310, 100, 100)];
    [act startAnimating];
    [act setBackgroundColor:[UIColor clearColor]];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(450, 300, 200, 200)];
    [lbl setFont: [UIFont fontWithName:@"Arial" size:30.0f]];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:[UIColor whiteColor]];
    lbl.text=@"Downloading";
    [vie addSubview:img];
    [vie addSubview:lbl];
    [vie addSubview:act];
    self.loading=vie;
    
    [self.superview.superview addSubview:self.loading];
    
    
   // NSLog(@"HAHAHAHAHAHAAHAHAH");
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:self.downloadLink];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        
        if(!error)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *zipPath = [path stringByAppendingPathComponent:[self.downloadLink lastPathComponent]];
            
            [data writeToFile:zipPath options:0 error:&error];
            
            if(!error)
            {
                ZipArchive *za = [[ZipArchive alloc] init];
                if ([za UnzipOpenFile: zipPath]) {
                    BOOL ret = [za UnzipFileTo: path overWrite: YES];
                    if (NO == ret){} [za UnzipCloseFile];
                    
                /*    NSString *imageFilePath = [path stringByAppendingPathComponent:@"photo.png"];
                    NSString *textFilePath = [path stringByAppendingPathComponent:@"text.txt"];
                    NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath options:0 error:nil];
                    UIImage *img = [UIImage imageWithData:imageData];
                    NSString *textString = [NSString stringWithContentsOfFile:textFilePath encoding:NSASCIIStringEncoding error:nil];*/
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                //        self.imageView.image = img;
                //        self.label.text = textString;
                        if(self.clickStory){
                            [self checkStory];
                        }else{
                            [self checkPaths];
                        }
                        commitDefaultMOC();
                        [myIndicator stopAnimating];
                        [self.loading removeFromSuperview];
                        [self.price setText:@"Downloaded"];
                        [self.buyItem removeFromSuperview];

                    });
                }
            }
            else
            {
                NSLog(@"Error saving file %@",error);
            }
        }
        else
        {
            NSLog(@"Error downloading zip file: %@", error);
        }
        
    });
}
-(BOOL)checkIfPathExists:(NSString*) pathId{
    NSArray *allPaths=[Paths getAllPaths];
    NSArray *pathsInStory=[self.storyPaths componentsSeparatedByString:@","];
    NSLog(@"%@",pathsInStory);
    for(int i=0;i<allPaths.count;i++){
        Paths *p=[allPaths objectAtIndex:i];
        if([[NSString stringWithFormat:@"%@",pathId] isEqualToString:[NSString stringWithFormat:@"%@",p.pathId]]){
            for(int j=0;j<pathsInStory.count;j++){
                if([[NSString stringWithFormat:@"%@",pathId] isEqualToString:[NSString stringWithFormat:@"%@",[pathsInStory objectAtIndex:j]]]){
                    return true;
                }
            }
            
            
            
           // return TRUE;
        }
    }
    return FALSE;
}
-(void)checkStory
{
    
   // if([StoryPaths getAllPaths].count==0){
    NSLog(@"GOT THE FILE");

        Story *firstStory=[Story insertStory:self.storyId name:self.storyNmae];
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Downloaded %@",self.storyNmae]];

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath=[path stringByAppendingPathComponent:@"mobile_paths.json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if(data==NULL){
        filePath=[[NSBundle mainBundle] pathForResource:@"mobile_paths" ofType:@"json"];
        data=[NSData dataWithContentsOfFile:filePath];
    }
    
    
   //     NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mobile_paths" ofType:@"json"];
   //     NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray *pathName=[[NSMutableArray alloc] init];
        NSArray *pathIds=[[NSMutableArray alloc] init];
        NSArray *numOfLvls=[[NSMutableArray alloc] init];
        if (!json) {
            NSLog(@"Error parsing JSON: %@", error);
        } else {
            pathName=[json valueForKey:@"description"];
            pathIds=[json valueForKey:@"path_id"];
            numOfLvls=[json valueForKey:@"number_of_problemsets"];
            
        }
        //  NSLog(@"%@",pathName);
    for(int i=0;i<pathIds.count;i++){
        if([self checkIfPathExists:[pathIds objectAtIndex:i]]){
            StoryPaths *p = [StoryPaths getPathWithId:[NSString stringWithFormat:@"%@",[pathIds objectAtIndex:i]] storyId:firstStory.id];
            
            
            if(!p){
                if([self.storyNumOfLvls intValue]<=[[numOfLvls objectAtIndex:i] intValue]*2 ){
                    StoryPaths *insertedPath=[StoryPaths insertPath:[NSString stringWithFormat:@"%@",[pathIds objectAtIndex:i]] pathName:[pathName objectAtIndex:i] storyId:firstStory.id pathsStory:[NSSet setWithObject:firstStory]];
                    
                    
                    [self checkStoryLevel:[NSString stringWithFormat:@"%@",[pathIds objectAtIndex:i]]sentPath:insertedPath sentStory:firstStory];
                }
            }
        }
    }
   /* }else{
        NSLog(@"Already in DB");
    }*/
}
-(void)checkStoryLevel:(NSString*)pathid sentPath:(StoryPaths*)sentPath sentStory:(Story*)sentStory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"l_%@.json",pathid]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if(data==NULL){
        NSString *urlStr=[NSString stringWithFormat:@"l_%@",pathid];
        filePath=[[NSBundle mainBundle] pathForResource:urlStr ofType:@"json"];
        data=[NSData dataWithContentsOfFile:filePath];
    }
    
    
  //  NSString *urlStr=[NSString stringWithFormat:@"l_%@",pathid];
  //  NSString *filePath = [[NSBundle mainBundle] pathForResource:urlStr ofType:@"json"];
    
    
    
    int videoNumber=1;
    int levelNumber=1;
    int levelNameTag=1;
 //   NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSMutableArray *allLevels=[[NSMutableArray alloc] init];
    
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
    int levels=1;
    int levelsNum=1;
    for(int i=0;i<[self.storyNumOfLvls intValue]/2;i++){
        StoryLevels *l=[StoryLevels getLevelWithId:[NSString stringWithFormat:@"%@",[levelId objectAtIndex:i] ]storyId:sentStory.id];
        
        
        
        if(!l){
            if(![numberOfQuestions objectAtIndex:i]==0){
                NSString *firstLevelID=[NSString stringWithFormat:@"%@_1",[levelId objectAtIndex:i]];
                NSString *secondLevelID=[NSString stringWithFormat:@"%@_2",[levelId objectAtIndex:i]];
                StoryLevels *firstLevel=[StoryLevels insertLevel:firstLevelID levelName:[NSString stringWithFormat:@"%i",levels] pathId:[NSString stringWithFormat:@"%@",[sentPath pathId]] storyId:[NSString stringWithFormat:@"%@",[sentStory id]] isCompleted:NO video:NO levelPath:sentPath levelNumber:levelsNum];
                
           /*
                [[StoryLevels alloc] init];
                firstLevel.levelId=firstLevelID;
                firstLevel.levelName=[NSString stringWithFormat:@"%i",levels];
                firstLevel.pathId=[NSString stringWithFormat:@"%@",[sentPath pathId]];
                firstLevel.storyId=[NSString stringWithFormat:@"%@",[sentStory id]];
                firstLevel.completed=NO;
                firstLevel.video=NO;
                firstLevel.hasPath=sentPath;
                firstLevel.levelNumber=levelsNum;*/
                levelsNum++;
                levels++;
                
                StoryLevels *secondLevel=[StoryLevels insertLevel:secondLevelID levelName:[NSString stringWithFormat:@"%i",levels] pathId:[NSString stringWithFormat:@"%@",[sentPath pathId]] storyId:[NSString stringWithFormat:@"%@",[sentStory id]] isCompleted:NO video:NO levelPath:sentPath levelNumber:levelsNum];
                

           /*
                [[StoryLevels alloc] init];
                firstLevel.levelId=secondLevelID;
                firstLevel.levelName=[NSString stringWithFormat:@"%i",levels];
                firstLevel.pathId=[NSString stringWithFormat:@"%@",[sentPath pathId]];
                firstLevel.storyId=[NSString stringWithFormat:@"%@",[sentStory id]];
                firstLevel.completed=NO;
                firstLevel.video=NO;
                firstLevel.hasPath=sentPath;
                firstLevel.levelNumber=levelsNum;*/
                levelsNum++;
                levels++;
                
                [allLevels addObject:firstLevel];
                [allLevels addObject:secondLevel];
                
            }
        }
    }
    NSArray *storyVidArr=[self.storyOrder componentsSeparatedByString:@","];
    int storyVideoNum=1;
    NSLog(@"%@",self.storyNumOfVideos);
    for(int i=0;i<[self.storyNumOfVideos intValue];i++){
        NSString *firstStory=[NSString stringWithFormat:@"Scene%i_%@",storyVideoNum,sentStory.id];
        StoryLevels *storyVideo=[StoryLevels insertLevel:firstStory levelName:@"Video" pathId:[NSString stringWithFormat:@"%@",[sentPath pathId]] storyId:[NSString stringWithFormat:@"%@",[sentStory id]] isCompleted:NO video:YES levelPath:sentPath levelNumber:[[storyVidArr objectAtIndex:i] intValue]+1];
        
        /*
        
        [[StoryLevels alloc] init];
        storyVideo.levelId=firstStory;
        storyVideo.levelName=@"Video";
        storyVideo.pathId=[NSString stringWithFormat:@"%@",[sentPath pathId]];
        storyVideo.storyId=[NSString stringWithFormat:@"%@",[sentStory id]];
        storyVideo.completed=NO;
        storyVideo.video=YES;
        storyVideo.hasPath=sentPath;
        storyVideo.levelNumber=[[storyVidArr objectAtIndex:i] intValue]+1;*/
        storyVideoNum++;
        
        [allLevels insertObject:storyVideo atIndex:[[storyVidArr objectAtIndex:i] intValue]];
        NSLog(@"%i",allLevels.count);
        NSLog(@"%i",[[storyVidArr objectAtIndex:i] intValue]);
        NSLog(@"%@",storyVidArr);
        for(int j=[[storyVidArr objectAtIndex:i] intValue]+1;j<allLevels.count;j++){
            StoryLevels *currentLvl=[allLevels objectAtIndex:j];
            currentLvl.levelNumber=currentLvl.levelNumber+1;
            [allLevels replaceObjectAtIndex:j withObject:currentLvl];
        }
    }
    for(int i=0;i<allLevels.count;i++){
        StoryLevels *currentStory=[allLevels objectAtIndex:i];
        NSLog(@"%@ - %@ - %d - %c",currentStory.levelName,currentStory.levelId,currentStory.levelNumber,currentStory.video);
    }
    for(int i=0;i<allLevels.count;i++){
        StoryLevels *currentStory=[allLevels objectAtIndex:i];
      //  StoryLevels *insertLvl;
        if(i==0){
        /*insertLvl=[StoryLevels insertLevel:currentStory.levelId levelName:currentStory.levelName pathId:currentStory.pathId storyId:currentStory.storyId isCompleted:YES video:currentStory.video levelPath:currentStory.hasPath levelNumber:currentStory.levelNumber];*/
            currentStory.completed=YES;
        }else{
          /*  insertLvl=[StoryLevels insertLevel:currentStory.levelId levelName:currentStory.levelName pathId:currentStory.pathId storyId:currentStory.storyId isCompleted:currentStory.completed video:currentStory.video levelPath:currentStory.hasPath levelNumber:currentStory.levelNumber];*/
        }
        NSLog(@"%@ - %i",currentStory.levelName,currentStory.levelNumber);
        NSLog(@"%i - %@",currentStory.levelId.length,currentStory.levelId);
        NSLog(@"%c",[currentStory.levelId characterAtIndex:currentStory.levelId.length-1]);
        if(!currentStory.video){
       //     NSLog(@"%@ - %i",insertLvl.levelName,insertLvl.levelNumber);
            
            if([currentStory.levelId characterAtIndex:currentStory.levelId.length-1]=='1'){
                
                [self checkStoryQuestions:[NSString stringWithFormat:@"%@",[sentPath pathId]] sentLevel:currentStory check:YES levelId:[NSString stringWithFormat:@"%@",[currentStory.levelId substringToIndex:currentStory.levelId.length-2]]];
            }else{
                [self checkStoryQuestions:[NSString stringWithFormat:@"%@",[sentPath pathId]] sentLevel:currentStory check:NO levelId:[NSString stringWithFormat:@"%@",[currentStory.levelId substringToIndex:currentStory.levelId.length-2]]];
            }
            
        }
        
        
        
        
       
        
    }
    /*
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
    }*/
}/*
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
}*/
-(void) checkStoryQuestions: (NSString*)pathId sentLevel:(StoryLevels*)sentLevel check:(BOOL)check levelId:(NSString*)levelId
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"p_%@.json",levelId]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if(data==NULL){
        NSString *urlStr=[NSString stringWithFormat:@"p_%@",levelId];
        filePath = [[NSBundle mainBundle] pathForResource:urlStr ofType:@"json"];
        data = [NSData dataWithContentsOfFile:filePath];

    }
    
  //  NSString *urlStr=[NSString stringWithFormat:@"p_%@",levelId];
  //  NSString *filePath = [[NSBundle mainBundle] pathForResource:urlStr ofType:@"json"];
  //  NSData *data = [NSData dataWithContentsOfFile:filePath];
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
    
    

            Paths *p = [Paths getPathWithId:[NSString stringWithFormat:@"%@",self.storyId]];

    
            if(!p){
                Paths *insertedPath;
                
                insertedPath=[Paths insertPath:self.storyId pathName:self.storyNmae isDownloaded:YES];
                [TestFlight passCheckpoint:[NSString stringWithFormat:@"Downloaded %@",self.storyNmae]];

                [self checkLevels:self.storyId  :insertedPath];
            }
        

}

-(void) checkLevels: (NSString*) pathid :(Paths*) sentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
 //   url = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4v",self.storyLevel.levelId]]];
    
    
    NSString *urlStr=[NSString stringWithFormat:@"l_%@",pathid];
    NSString *filePath=[path stringByAppendingPathComponent:urlStr];
    filePath=[filePath stringByAppendingFormat:@".json"];

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
-(void) checkQuestions: (NSString*)levelId level:(Levels*) sentLevel
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *urlStr=[NSString stringWithFormat:@"p_%@",levelId];
    
    
    NSString *filePath=[path stringByAppendingPathComponent:urlStr];
    filePath=[filePath stringByAppendingFormat:@".json"];

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
