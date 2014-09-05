//
//  AchievementViewController.m
//  Singpath
//
//  Created by Rishik Bahri on 28/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//


#import "AchievementViewController.h"
#import "LeveyPopListViewCell.h"
// This class handels the achievements
#define POPLISTVIEW_SCREENINSET 40.
#define POPLISTVIEW_HEADER_HEIGHT 50.
#define RADIUS 5.

@interface AchievementViewController (private)
- (void)fadeIn;
- (void)fadeOut;
@end

@implementation AchievementViewController
@synthesize delegate,count=_count,timeLoop=_timeLoop;


#pragma mark - initialization & cleaning up
- (id)initWithTitle:(NSString *)aTitle achievements:(NSArray*)achievements
{
    
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    rect.size.height=0;
    rect.size.width=0;
    rect.origin.x=250;
    rect.origin.y=250;
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor clearColor];
        
    
        _options=[achievements copy];
        self.count=0;
        NSString* imgName=[NSString stringWithFormat:@"%@.png",[achievements objectAtIndex:self.count]];
        UIImageView *achievement=[[UIImageView alloc] initWithFrame:CGRectMake(430,-280,300,200)];
        achievement.image=[UIImage imageNamed:imgName];
        [self addSubview:achievement];
       
        self.timeLoop = [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self
                                                          selector: @selector(callAfterTwoSecond:) userInfo: nil repeats: YES];
       
    }
    return self;
}

-(void) callAfterTwoSecond:(NSTimer*) t
{
    [self fadeOut];
    if(_options.count>1){
        self.count=self.count+1;
        if(self.count<_options.count){
            NSString* imgName=[NSString stringWithFormat:@"%@.png",[_options objectAtIndex:self.count]];
            UIImageView *achievement=[[UIImageView alloc] initWithFrame:CGRectMake(430,-280,300,200)];
            achievement.image=[UIImage imageNamed:imgName];
            [self addSubview:achievement];
            [self fadeIn];
        }else{
            [self.timeLoop invalidate];
        }
    }
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

#pragma mark - Tableview datasource & delegates
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
    cell.textLabel.text = [[_options objectAtIndex:row] objectForKey:@"text"];
    [cell addSubview:[[_options objectAtIndex:row] objectForKey:@"swt"]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
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

@end