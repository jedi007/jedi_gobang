//
//  ViewController.m
//  jedi_gobang
//
//  Created by 李杰 on 2019/4/22.
//  Copyright © 2019 李杰. All rights reserved.
//

#import "ViewController.h"




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    double gW = [[UIScreen mainScreen] bounds].size.width;
    
    //获取状态栏的rect
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    //那么导航栏+状态栏的高度
    int topheight = statusRect.size.height+navRect.size.height;
    
    jedi_gobang_view *gobangview = [[jedi_gobang_view alloc] initWithFrame:CGRectMake(gW*0.025, gW*0.025+topheight, gW*0.95, gW*0.95)];
    
    init_scoretree();
    
    [self.view addSubview:gobangview];
}

@end
