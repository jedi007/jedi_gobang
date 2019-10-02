//
//  jedi_gobang_view.h
//  octest
//
//  Created by 李杰 on 2019/4/22.
//  Copyright © 2019 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "gobang_board.h"
#import "boardRecord.h"

NS_ASSUME_NONNULL_BEGIN


IB_DESIGNABLE
@interface jedi_gobang_view : UIView

- (void)setFrameForReSet:(CGRect)frame;
- (void)preStep;

- (void)add_chess:(Board_point *)bpoint;
- (Board_point *)getBestPoint;

@property (nonatomic, readwrite) gobang_board* gboard;

@end

NS_ASSUME_NONNULL_END
