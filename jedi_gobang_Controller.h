//
//  jedi_gobang_Controller.h
//  jedi_gobang
//
//  Created by dev on 2019/6/29.
//  Copyright © 2019 王启帆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jedi_gobang_view.h"

NS_ASSUME_NONNULL_BEGIN

@interface jedi_gobang_Controller : UIViewController

- (id)initWithViewFrame:(CGRect)frame;
- (void)setViewFrame:(CGRect) frame;

-(void)showAlertViewTitle:(NSString *)title subTitle:(NSString *)subTitle;
- (void)Restart;

@end

NS_ASSUME_NONNULL_END
