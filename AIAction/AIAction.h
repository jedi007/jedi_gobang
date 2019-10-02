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

@interface bestScorePoint: NSObject

@property (nonatomic, readwrite) int i;
@property (nonatomic, readwrite) int j;
@property (nonatomic, readwrite) int score;

@end

@interface AIAction : NSObject

- (bestScorePoint *)getBestPoint: (intsptr _Nonnull )board current_color:(int)c_color  deep:(int)deep width:(int)width;


@property (nonatomic, readwrite) int current_color;
@end

NS_ASSUME_NONNULL_END
