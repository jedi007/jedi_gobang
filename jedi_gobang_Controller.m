//
//  jedi_gobang_Controller.m
//  jedi_gobang
//
//  Created by dev on 2019/6/29.
//  Copyright © 2019 王启帆. All rights reserved.
//

#import "jedi_gobang_Controller.h"

@interface jedi_gobang_Controller ()

@end

@implementation jedi_gobang_Controller

jedi_gobang_view *gobangview;

- (id)initWithViewFrame:(CGRect)frame
{
    NSLog(@"initWithViewFrame is called");
    self = [super init];
    NSLog(@"initWithViewFrame is called over 1");
    if (self)
    {
        [self setViewFrame:frame];
    }
    NSLog(@"initWithViewFrame is called over 2");
    return self;
}

- (void)viewDidLoad {
    NSLog(@"jedi_gobang_view  viewDidLoad is called");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    init_scoretree();
    self.view.clipsToBounds = YES;//超出边界点子视图内容裁掉
    
    gobangview = [[jedi_gobang_view alloc] init];
    [self.view addSubview:gobangview];
}

- (void)setViewFrame:(CGRect) frame
{
    NSLog(@"1   jedi_gobang_Controller is : %@",gobangview);
    self.view.frame = frame;//通过测试知道，在这一步会触发viewDidLoad
    
    NSLog(@"2   jedi_gobang_Controller is : %@",gobangview);
    [gobangview setFrameForReSet:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    //gobangview.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    CGFloat w = self.view.frame.size.width;
    NSLog(@"jedi_gobang_Controller setViewFrame w: %1.2f",w);
    
//    [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer* timer){
//        [self showAlertViewTitle:@"test" subTitle:@"testalert"];
//    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertWinner:) name:@"AlertWinner" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AlertWinner" object:nil];
}

-(void)showAlertWinner:(NSNotification *)notification
{
    //[NSThread sleepForTimeInterval:2];等待2秒执行
    NSLog(@"showAlertWinner 收到通知");
    NSString* subTitle = [[NSString alloc] initWithFormat:@"Winner is %@ !",notification.object];
    [self showAlertViewTitle:@"Victory!" subTitle:subTitle];
}

-(void)showAlertViewTitle:(NSString *)title subTitle:(NSString *)subTitle{
    //1.创建UIAlertControler
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:subTitle preferredStyle:UIAlertControllerStyleAlert];
    /*
     参数说明：
     Title:弹框的标题
     message:弹框的消息内容
     preferredStyle:弹框样式：UIAlertControllerStyleAlert
     */
    
    //2.添加按钮动作
    //2.1 确认按钮
    UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确认按钮");
        self.view.userInteractionEnabled = NO;
        //NSLog(@"反馈的信息是：%@",alert.textFields.firstObject.text);
    }];
    //2.2 取消按钮
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"点击了取消按钮");
//    }];
    //2.3 还可以添加文本框 通过 alert.textFields.firstObject 获得该文本框
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"请填写您的反馈信息";
//    }];
    
    //3.将动作按钮 添加到控制器中
    [alert addAction:conform];
    //[alert addAction:cancel];
    
    //4.显示弹框
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)Restart
{
    CGRect frame = self.view.frame;
    gobangview = nil;
    gobangview = [[jedi_gobang_view alloc] init];
    [self.view addSubview:gobangview];
    [self setViewFrame:frame];
    
    self.view.userInteractionEnabled = YES;
}

- (void)PreStep
{
    NSLog(@"jedi_gobang_controller receive preStep");
    [gobangview preStep];
}

- (void)AIAction
{
    NSLog(@"jedi_gobang_controller receive AIAction");
    
    [gobangview add_chess:[gobangview getBestPoint] ];
}
@end
