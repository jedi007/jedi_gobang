//
//  AIAction.h
//  jedi_gobang
//
//  Created by 司开发 on 2019/10/1.
//  Copyright © 2019 李杰. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "gobang_board.h"

typedef int intsptr[15][15];

NS_ASSUME_NONNULL_BEGIN

@interface AIAction : NSObject

- (Board_point *)getBestPoint: (intsptr _Nonnull )board;

@end

NS_ASSUME_NONNULL_END
