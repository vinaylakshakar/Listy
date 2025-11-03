//
//  LoginScreenTitle_Blue.m
//  Listy
//
//  Created by Silstone on 07/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "LoginScreenTitle_Blue.h"

@implementation LoginScreenTitle_Blue

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ){
        [self layoutIfNeeded];
        [self configurefont];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if( (self = [super initWithFrame:frame]) ){
        [self layoutIfNeeded];
        [self configurefont];
    }
    return self;
}

- (void) configurefont {
    // CGFloat newFontSize = (self.font.pointSize * SCALE_FACTOR_H);
    //    self.font = [UIFont fontWithName:@"ProximaNova-Regular" size:24];
    //
    //    CGFloat newFontSize = (self.font.pointSize * SCALE_FACTOR_H);
    
    //self.font = [UIFont fontWithName:@"SegoeUI" size:18];
    
    self.textColor =  [UIColor colorWithRed:0.02 green:0.07 blue:0.26 alpha:1.0];
    
    CGFloat newFontSize;
    if([[UIScreen mainScreen] bounds].size.height == 568.0)
    {
        //iphone 5
        newFontSize = 15;;
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667.0)
    {
        //iphone 6
        newFontSize = 18;
    }
    else {
        newFontSize = 18;
    }
    
    [self setFont:[UIFont fontWithName:@"SFProDisplay-Bold" size:newFontSize]];
}


@end
