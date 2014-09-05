//
//  StoreViewController.m
//  Singpath
//
//  Created by Rishik on 25/11/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "StoreViewController.h"
#import "StoryModeCell.h"
#import "Story.h"
#import "StoryManager.h"
#import "Paths.h"
#import "PathManager.h"
#import "deepend.h"
#import "MainScreenViewController.h"
@interface StoreViewController()
@property (nonatomic, strong) NSMutableData *responseData;
@end

@implementation StoreViewController

@synthesize responseData = _responseData,tableView,tableData=_tableData,storyData=_storyData,pathData=_pathData,heading,backgrond,backToHome,labelTxt;

- (void)viewDidLoad {
    [super viewDidLoad];
    [deepend StopMotion];

    [deepend StartMotion:self.backgrond];
    [backToHome addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchUpInside];

    [self.heading setFont:[UIFont fontWithName:@"QuicksandDash-Regular" size:75.0]];

    NSLog(@"viewdidload");
    self.responseData = [NSMutableData data];
    [self.view addSubview:self.activity];
    [_activity startAnimating];
    NSString *jsonFileURL=@"http://singpathmobileapp.appspot.com/getAllStories.do";
    NSLog(@"%@",[[NSBundle mainBundle] bundleIdentifier]);
    if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.augmenta.singpath"]){
        jsonFileURL=@"http://singpathmobileapp.appspot.com/getNonTestFlightStore.do";
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:jsonFileURL]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [self.heading setFont:[UIFont fontWithName:@"QuicksandDash-Regular" size:75.0]];
 //   self.tableData=[NSArray arrayWithObjects:@"1",@"2", nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}
-(void)goToHome{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    MainScreenViewController* mainScreen = (MainScreenViewController*)[storyboard instantiateViewControllerWithIdentifier:@"mainScreenViewController"];
    
    
    
    //[TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
    //[[self navigationController] pushViewController:storyLevelViewController animated:YES];
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: mainScreen animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"%@",res);
    NSDictionary *storyArr=[res valueForKey:@"stories"];
    NSDictionary *pathArr=[res valueForKey:@"paths"];
    NSLog(@"%@",storyArr);
   /* NSLog(@"%@",[storyArr valueForKey:@"storyId"]);
    for(id key in res){
        NSLog(@"%@",key);
    }*/
    NSArray *storyIds=[storyArr valueForKey:@"storyId"];
    NSArray *storyName=[storyArr valueForKey:@"storyName"];
    NSArray *storyPrice=[storyArr valueForKey:@"storyPrice"];
    NSArray *storyDescription=[storyArr valueForKey:@"storyDescription"];
    NSArray *storyDownloadLink=[storyArr valueForKey:@"storyDownloadLink"];
    NSArray *storyNumOfLvls=[storyArr valueForKey:@"storyNumOfLvls"];
    NSArray *storyNumOfVideos=[storyArr valueForKey:@"storyNumOfVideos"];
    NSArray *storyOrder=[storyArr valueForKey:@"storyOrder"];
    NSArray *storyPaths=[storyArr valueForKey:@"storyPaths"];

    NSLog(@"%@",storyNumOfVideos);
    
    NSArray *pathIds=[pathArr valueForKey:@"pathId"];
    NSArray *pathName=[pathArr valueForKey:@"pathName"];
    NSArray *pathPrice=[pathArr valueForKey:@"pathPrice"];
    NSArray *pathDescription=[pathArr valueForKey:@"pathDescription"];
    NSArray *pathDownloadLink=[pathArr valueForKey:@"pathDownloadLink"];
  //  NSLog(@"%@",storyIds);
    self.storyData=[[NSMutableArray alloc] init];
    self.pathData=[[NSMutableArray alloc] init];
    // NSArray *currentStories=[Story getAllStories];
    for(int i=0;i<storyIds.count;i++){
        Story *s=[Story getStoryWithId:[storyIds objectAtIndex:i]];
        NSLog(@"%@",s);
        if(s==NULL){
            
            NSArray *arrValues=[NSArray arrayWithObjects:[storyIds objectAtIndex:i],[storyName objectAtIndex:i],[storyPrice objectAtIndex:i],[storyDescription objectAtIndex:i],[storyDownloadLink objectAtIndex:i],[storyNumOfLvls objectAtIndex:i],[storyNumOfVideos objectAtIndex:i],[storyOrder objectAtIndex:i],[storyPaths objectAtIndex:i], nil];
            NSArray *arrKeys=[NSArray arrayWithObjects:@"storyId",@"storyName",@"storyPrice",@"storyDescription",@"storyDownloadLink",@"storyNumOfLvls",@"storyNumOfVideos",@"storyOrder",@"storyPaths", nil];
            [self.storyData addObject:[NSDictionary dictionaryWithObjects:arrValues forKeys:arrKeys]];
             
             
            
            
        }
    }
    for(int i=0;i<pathIds.count;i++){
        Paths *p=[Paths getPathWithId:[pathIds objectAtIndex:i]];
        
        if(p==NULL){
            
            NSArray *arrValues=[NSArray arrayWithObjects:[pathIds objectAtIndex:i],[pathName objectAtIndex:i],[pathPrice objectAtIndex:i],[pathDescription objectAtIndex:i],[pathDownloadLink objectAtIndex:i], nil];
            NSArray *arrKeys=[NSArray arrayWithObjects:@"pathId",@"pathName",@"pathPrice",@"pathDescription",@"pathDownloadLink", nil];
            [self.pathData addObject:[NSDictionary dictionaryWithObjects:arrValues forKeys:arrKeys]];
            
            
            
            
        }
    }
    if(self.storyData.count>0){
    self.tableData=[NSArray arrayWithArray:self.storyData];
    NSLog(@"%i",self.storyData.count);
    NSLog(@"%@",[self.tableData objectAtIndex:0]);
    [self.tableView reloadData];
    NSString *BLA=@"";
    }else{
        self.tableData=[[NSArray alloc] init];
        
    }
    [_activity stopAnimating];
    [_activity removeFromSuperview];
    [self.tableView reloadData];
    if(self.tableData.count+self.pathData.count==0){
        labelTxt.text=@"No New Downloads Available";
    }
    // show all values
   /* for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
    }*/
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    if(section==0){
        return [self.tableData count];   
    }else{
        return [self.pathData count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoryCell";
    StoryModeCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    /*
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }*/
    if(indexPath.section==0){
        
        cell.description.text=[[self.tableData objectAtIndex:indexPath.row] valueForKey:@"storyDescription"];
        cell.imageView.image=[UIImage imageNamed:@"newStory"];
       // cell.price.text=[[self.tableData objectAtIndex:indexPath.row] valueForKey:@"storyPrice"];
        cell.name.text=[[self.tableData objectAtIndex:indexPath.row] valueForKey:@"storyName"];
        cell.storyId=[[self.tableData objectAtIndex:indexPath.row] valueForKey:@"storyId"];
        cell.storyNmae=[[self.tableData objectAtIndex:indexPath.row] valueForKey:@"storyName"];
        cell.downloadLink=[[self.tableData objectAtIndex:indexPath.row] valueForKey:@"storyDownloadLink"];
        cell.storyNumOfLvls=[[self.tableData objectAtIndex:indexPath.row] valueForKey:@"storyNumOfLvls"];
        cell.storyNumOfVideos=[[self.tableData objectAtIndex:indexPath.row] valueForKey:@"storyNumOfVideos"];
        cell.storyOrder=[[self.tableData objectAtIndex:indexPath.row] valueForKey:@"storyOrder"];
        cell.clickStory=YES;
        cell.storyPaths=[[self.tableData objectAtIndex:indexPath.row] valueForKey:@"storyPaths"];
    }
    else{
        cell.description.text=[[self.pathData objectAtIndex:indexPath.row] valueForKey:@"pathDescription"];
        cell.imageView.image=[UIImage imageNamed:@"newPath"];
    //    cell.price.text=[[self.pathData objectAtIndex:indexPath.row] valueForKey:@"pathPrice"];
        cell.name.text=[[self.pathData objectAtIndex:indexPath.row] valueForKey:@"pathName"];
        cell.storyId=[[self.pathData objectAtIndex:indexPath.row] valueForKey:@"pathId"];
        cell.storyNmae=[[self.pathData objectAtIndex:indexPath.row] valueForKey:@"pathName"];
        cell.downloadLink=[[self.pathData objectAtIndex:indexPath.row] valueForKey:@"pathDownloadLink"];
        cell.clickStory=NO;
    }
    // cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    
    [cell.buyItem addTarget:cell action:@selector(buyItemButton) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    
    SSViewController* ssViewController = (SSViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ssViewController"];
    ssViewController.problemSetId=[self.problemSetIds objectAtIndex:indexPath.row];
    ssViewController.pathID=self.levelid;
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@-%@",self.levelName,[self.tableData objectAtIndex:indexPath.row]]];
    //     [[self navigationController] pushViewController:ssViewController animated:YES];
    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.80];
    [[self navigationController] pushViewController: ssViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
     */
}


@end


