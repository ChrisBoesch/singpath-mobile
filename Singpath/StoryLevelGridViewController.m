//
//  ViewController.m
//  Singpath
//
//  Created by Rishik Bahri on 04/07/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "StoryLevelGridViewController.h"
#import "CollectionViewCell.h"
#import "StoryGameViewController.h"
@interface StoryLevelGridViewController ()

@end

@implementation StoryLevelGridViewController
@synthesize levelIdArray,levelNameArray,videoArray,completedArray,levelsArray;
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [levelNameArray count] / 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}
//Navigates to the level selected for a perticular story
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    StoryLevels *currentLevel=[levelsArray objectAtIndex:(indexPath.section*5 + indexPath.row)];
    if(currentLevel.completed){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        StoryGameViewController* storyLevelViewController = (StoryGameViewController*)[storyboard instantiateViewControllerWithIdentifier:@"storyGameViewController"];
        
        
        storyLevelViewController.storyLevel=[levelsArray objectAtIndex:(indexPath.section*5 + indexPath.row)];
        storyLevelViewController.problemSetId=[levelIdArray objectAtIndex:(indexPath.section*5 + indexPath.row)];
        storyLevelViewController.pathID=[[levelsArray objectAtIndex:(indexPath.section*5 + indexPath.row)] pathId];
        [self.navController pushViewController:storyLevelViewController animated:YES];
        
    }else{
    CollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    


    CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-30.0));
    CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(30.0));
    
    cell.transform = leftWobble;  // starting point
    
    [UIView beginAnimations:@"wobble" context:(__bridge void *)(cell)];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:2]; // adjustable
    [UIView setAnimationDuration:0.075];
    [UIView setAnimationDelegate:self];
    cell.transform = rightWobble; // end here & auto-reverse
    cell.transform=CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0.0));

    [UIView commitAnimations];
    }
    
}
//Display logic for the levels of a perticular story.
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *levelName = [levelNameArray objectAtIndex:(indexPath.section*5 + indexPath.row)];
    NSString *levelId=[levelIdArray objectAtIndex:(indexPath.section*5 + indexPath.row)];
    NSString *video=[videoArray objectAtIndex:(indexPath.section*5 + indexPath.row)];
    NSString *completed=[completedArray objectAtIndex:(indexPath.section*5 + indexPath.row)] ;
    
    
    if([video isEqualToString:@"True"]){
        if([completed isEqualToString:@"True"]){
            UIImage *backImg=[UIImage imageNamed:@"PlayIcon.png"];
            
            UIImageView *img=[[UIImageView alloc] initWithImage:backImg];
            [cell setBackgroundView:img];
        }else{
            UIImage *backImg=[UIImage imageNamed:@"lockedPlayIcon.png"];
            
            UIImageView *img=[[UIImageView alloc] initWithImage:backImg];
            [cell setBackgroundView:img];
        
        }
    }else{
        if([completed isEqualToString:@"True"]){
            cell.label.text = levelName;
          
            UIImage *backImg=[UIImage imageNamed:@"blankIcon.png"];

            UIImageView *img=[[UIImageView alloc] initWithImage:backImg];
            [cell setBackgroundView:img];
        }else{
            UIImage *backImg=[UIImage imageNamed:@"LockedblankIcon.png"];
            
            UIImageView *img=[[UIImageView alloc] initWithImage:backImg];
            [cell setBackgroundView:img];

        }
    }
    [cell.imageView setBackgroundColor:[UIColor clearColor]];
    
    
    
    
    return cell;
}
@end
