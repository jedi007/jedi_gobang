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
settingView* SettingView;

double gW;
double gH;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    gW = [[UIScreen mainScreen] bounds].size.width;
    gH = [[UIScreen mainScreen] bounds].size.height;
    
    //获取状态栏的rect
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    //那么导航栏+状态栏的高度
    int topheight = statusRect.size.height+navRect.size.height;
    NSLog(@"topheight : %d",topheight);
    
    CGRect gbangFrame = CGRectMake(gW*0.025, gW*0.025+topheight, gW*0.95, gW*0.95);
    gobang_controller = [[jedi_gobang_Controller alloc] initWithViewFrame:gbangFrame];
    //[gobang_controller setViewFrame:CGRectMake(0, gW*0.95+10, 200, 200)];
    [self.view addSubview:gobang_controller.view];
    
    SettingView = [[settingView alloc] init];
    SettingView.frame = CGRectMake(gbangFrame.origin.x, gbangFrame.origin.y+gbangFrame.size.height+10, gbangFrame.size.width, gH-(gbangFrame.origin.y+gbangFrame.size.height+20));
    SettingView.delegate = self;
    [self.view addSubview:SettingView];
    
    if(![UIDevice currentDevice].generatesDeviceOrientationNotifications){
        [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)AgainClicked
{
    NSLog(@"again clicked receive in main viewController");
}

//设备方向改变的处理
- (void)handleDeviceOrientationChange:(NSNotification*)notification{
    UIDeviceOrientation deviceOrientation= [UIDevice currentDevice].orientation;
    int topheight = [self getTopHeight];
    switch(deviceOrientation){
            
        case UIDeviceOrientationFaceUp:
            NSLog(@"屏幕朝上平躺");
            break;
        case UIDeviceOrientationFaceDown:
            NSLog(@"屏幕朝下平躺");
            break;
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"屏幕向左横置");
            NSLog(@"topheight : %d",topheight);
            gobang_controller.view.frame = CGRectMake(gW*0.025, gW*0.025+topheight, gW*0.95, gW*0.95);
            break;
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"屏幕向右橫置");
            NSLog(@"topheight : %d",topheight);
            gobang_controller.view.frame = CGRectMake(gW*0.025, gW*0.025+topheight, gW*0.95, gW*0.95);
            break;
        case UIDeviceOrientationPortrait:
            NSLog(@"屏幕直立");
            gobang_controller.view.frame = CGRectMake(gW*0.025, gW*0.025+topheight, gW*0.95, gW*0.95);
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕直立，上下顛倒");
            gobang_controller.view.frame = CGRectMake(gW*0.025, gW*0.025+topheight, gW*0.95, gW*0.95);
            break;
        default:
            NSLog(@"无法辨识");
            break;
    }
}

- (int)getTopHeight
{
    //获取状态栏的rect
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    //那么导航栏+状态栏的高度
    int topheight = statusRect.size.height+navRect.size.height;
    
    return topheight;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@" in willRotateToInterfaceOrientation ");
    switch (toInterfaceOrientation) {
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"屏幕向左横置");
            break;
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"屏幕向右橫置");
            break;
        case UIDeviceOrientationPortrait:
            NSLog(@"屏幕直立");
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕直立，上下顛倒");
            break;
        default:
            NSLog(@"无法辨识");
            break;
    }
}



// 能否自动旋转
-(BOOL)shouldAutorotate{
    return YES;
}

// 支持的屏幕方向
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}

// 默认的屏幕方向
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}



@end
