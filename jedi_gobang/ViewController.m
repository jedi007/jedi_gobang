//
//  ViewController.m
//  jedi_gobang
//
//  Created by 李杰 on 2019/4/22.
//  Copyright © 2019 李杰. All rights reserved.
//

#import "ViewController.h"
#import "../jedi_gobang_Controller.h"


@implementation ViewController

jedi_gobang_Controller* gobang_controller;

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
    
    gobang_controller = [[jedi_gobang_Controller alloc] initWithViewFrame:CGRectMake(gW*0.025, gW*0.025+topheight, gW*0.95, gW*0.95)];
    //[gobang_controller setViewFrame:CGRectMake(0, gW*0.95+10, 200, 200)];
    [self.view addSubview:gobang_controller.view];
}

@end
