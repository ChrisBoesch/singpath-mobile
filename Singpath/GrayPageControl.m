//
//  GrayPageControl.m
//  Singpath
//
//  Created by Rishik on 03/12/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "GrayPageControl.h"
//This class is used for the custom page indicators.
@implementation GrayPageControl

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    activeImage = [UIImage imageNamed:@"slider1.png"] ;
    inactiveImage = [UIImage imageNamed:@"slider2.png"];
    return self;
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        dot.frame = CGRectMake(dot.frame.origin.x, dot.frame.origin.y, 30., 30.);
        if (i == self.currentPage) dot.image = activeImage;
        else dot.image = inactiveImage;
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self updateDots];
}
-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}
@end
