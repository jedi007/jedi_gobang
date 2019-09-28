//
//  settingView.m
//  jedi_gobang
//
//  Created by 司开发 on 2019/7/14.
//  Copyright © 2019 李杰. All rights reserved.
//

#import "settingView.h"

#import "modules/UIColor+Expanded.h"

@implementation settingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init
{
    self =[super init];
    if(self)
    {
        NSLog(@"init is called");
        [self setBackgroundColor:[UIColor hexStringToColor:@"FFB6C1"]];
        UIButton *btnAgain = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAgain.frame = CGRectMake(10, 10, 100, 50);
        [btnAgain setTitle:@"再来一局" forState:UIControlStateNormal];
        btnAgain.backgroundColor = [UIColor hexStringToColor:@"D8BFD8"];
        [btnAgain addTarget:self action:@selector(btnAgainClicked) forControlEvents:UIControlEventTouchUpInside];
        //关键语句
        btnAgain.layer.cornerRadius = 8.0;
        btnAgain.layer.borderColor = [UIColor blackColor].CGColor;//设置边框颜色
        btnAgain.layer.borderWidth = 1.0f;
        [self addSubview:btnAgain];
        
        UIButton *btnPreStep = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPreStep.frame = CGRectMake(10, 70, 100, 50);
        [btnPreStep setTitle:@"悔棋" forState:UIControlStateNormal];
        btnPreStep.backgroundColor = [UIColor hexStringToColor:@"D8BFD8"];
        [btnPreStep addTarget:self action:@selector(btnPreStepClicked) forControlEvents:UIControlEventTouchUpInside];
        //关键语句
        btnPreStep.layer.cornerRadius = 8.0;
        btnPreStep.layer.borderColor = [UIColor blackColor].CGColor;//设置边框颜色
        btnPreStep.layer.borderWidth = 1.0f;
        [self addSubview:btnPreStep];
    }
    return self;
}

-(void)btnAgainClicked
{
    NSLog(@"btnAgainClicked ");
    if(_delegate)
    {
        [_delegate AgainClicked];
    }
}

-(void)btnPreStepClicked
{
    NSLog(@"btnPreStepClicked ");
    if(_delegate)
    {
        [_delegate PreStepClicked];
    }
}

@end
