//
//  ConsoleViewController.m
//  Singpath
//
//  Created by Rishik Bahri on 29/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//



#import "ConsoleViewController.h"
#import "LeveyPopListViewCell.h"


#define POPLISTVIEW_SCREENINSET 40.
#define POPLISTVIEW_HEADER_HEIGHT 50.
#define RADIUS 5.
//This class initialises the console in the gameplay screens.
@interface ConsoleViewController (private)

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
- (void)fadeIn;
- (void)fadeOut;
@end

@implementation ConsoleViewController
@synthesize delegate;


#pragma mark - initialization & cleaning up
- (id)initWithTitle:(NSString *)aTitle consoleTxt:(NSString*)consoleTxt
{
    
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    rect.size.height=500;
    rect.size.width=430;
    rect.origin.x=515;
    rect.origin.y=270;
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor clearColor];
        _title = [aTitle copy];
        _options=[NSArray arrayWithObjects:@"hahahah",@"hahahah",@"hhahaah",nil];

        _table1=[[UITableView alloc] initWithFrame:CGRectMake(50,90,50,300)];
        _table1.dataSource = self;
        _table1.delegate = self;
        [self addSubview:_table1];
        
        _table2=[[UITableView alloc] initWithFrame:CGRectMake(200,90,50,300)];
        _table2.dataSource = self;
        _table2.delegate = self;
        [self addSubview:_table2];
        
      [_table1 reloadData];
        /*
        CallTableViewController *firstTable=[[CallTableViewController alloc] initWithFrame:CGRectMake(50,90,100,300)];
        firstTable.choices=[NSArray arrayWithObjects:@"hahahah",@"hahahah",@"hhahaah",nil];
        
        
        [self addSubview:firstTable];
        
        CallTableViewController *secondTable=[[CallTableViewController alloc] initWithFrame:CGRectMake(200,90,100,300)];
        secondTable.choices=[NSArray arrayWithObjects:@"1",@"2",@"3",nil];
        
        
        [self addSubview:secondTable];
        [firstTable reloadData];*/
        
        /*
        UITextView *console=[[UITextView alloc] initWithFrame:CGRectMake(40,
                                                                             90 ,
                                                                             300,300)];
        console.text=consoleTxt;
        [console setUserInteractionEnabled:NO];
        [console setBackgroundColor:[UIColor clearColor]];
        [console setTextColor:[UIColor whiteColor]];
        [self addSubview:console];
         */
        
           }
    return self;
}
- (id)initWithTitle:(NSString *)aTitle hintTxt:(NSString*)hintTxt
{
    
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    rect.size.height=300;
    rect.size.width=330;
    rect.origin.x=620;
    rect.origin.y=80;
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor clearColor];
        _title = [aTitle copy];
        
        
        UITextView *console=[[UITextView alloc] initWithFrame:CGRectMake(40,
                                                                         90 ,
                                                                         300,200)];
        console.text=hintTxt;
        [console setBackgroundColor:[UIColor clearColor]];
        [console setTextColor:[UIColor whiteColor]];
        [console setUserInteractionEnabled:NO];

        [self addSubview:console];
        
        
    }
    return self;
}
#pragma mark - Private Methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
-(void)end
{
    [self fadeOut];
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            
            
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}
#pragma mark - DrawDrawDraw

- (void)drawRect:(CGRect)rect
{
    CGRect bgRect = CGRectInset(rect, POPLISTVIEW_SCREENINSET, POPLISTVIEW_SCREENINSET);
    //  CGREctInse
    
    CGRect titleRect = CGRectMake(POPLISTVIEW_SCREENINSET + 10, POPLISTVIEW_SCREENINSET + 10 + 5,
                                  rect.size.width -  2 * (POPLISTVIEW_SCREENINSET + 10), 30);
    CGRect separatorRect = CGRectMake(POPLISTVIEW_SCREENINSET, POPLISTVIEW_SCREENINSET + POPLISTVIEW_HEADER_HEIGHT - 2,
                                      rect.size.width - 2 * POPLISTVIEW_SCREENINSET, 2);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw the background with shadow
    CGContextSetShadowWithColor(ctx, CGSizeZero, 6., [UIColor colorWithWhite:0 alpha:.75].CGColor);
    [[UIColor colorWithWhite:0 alpha:.75] setFill];
    
    
    float x = POPLISTVIEW_SCREENINSET;
    float y = POPLISTVIEW_SCREENINSET;
    float width = bgRect.size.width;
    float height = bgRect.size.height;
    CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, x, y + RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y, x + RADIUS, y, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y, x + width, y + RADIUS, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y + height, x + width - RADIUS, y + height, RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y + height, x, y + height - RADIUS, RADIUS);
	CGPathCloseSubpath(path);
	CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGPathRelease(path);
    
    // Draw the title and the separator with shadow
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 0.5f, [UIColor blackColor].CGColor);
    [[UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.] setFill];
    [_title drawInRect:titleRect withFont:[UIFont systemFontOfSize:16.]];
    CGContextFillRect(ctx, separatorRect);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"PopListViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        cell = [[LeveyPopListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity] ;
    }
    int row = [indexPath row];
    NSLog(@"%@",[_options objectAtIndex:row] );
    cell.textLabel.text = [_options objectAtIndex:row] ;
    
  //  [cell addSubview:[_options objectAtIndex:row]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


@end