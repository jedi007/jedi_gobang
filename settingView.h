//
//  settingView.h
//  jedi_gobang
//
//  Created by 司开发 on 2019/7/14.
//  Copyright © 2019 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 声明一个协议
@protocol settingViewDelegate
// 协议中的方法
- (void)AgainClicked;

@end

@interface settingView : UIView

// 采用上面协议的物件
@property (weak) id delegate;

@end

NS_ASSUME_NONNULL_END
