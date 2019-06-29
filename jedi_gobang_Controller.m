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
    self = [super init];
    if (self)
    {
        [self setViewFrame:frame];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    init_scoretree();
    self.view.clipsToBounds = YES;//超出边界点子视图内容裁掉
    
    gobangview = [[jedi_gobang_view alloc] init];
    [self.view addSubview:gobangview];
}

- (void)setViewFrame:(CGRect) frame
{
    self.view.frame = frame;
    [gobangview setFrameForReSet:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    //gobangview.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    CGFloat w = self.view.frame.size.width;
    NSLog(@"jedi_gobang_Controller setViewFrame w: %1.2f",w);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
