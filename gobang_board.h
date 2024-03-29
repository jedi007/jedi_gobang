//
//  gobang_board.h
//  jedi_gobang
//
//  Created by dev on 2019/6/11.
//  Copyright © 2019 李杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "scoretree.h"


NS_ASSUME_NONNULL_BEGIN

@interface Board_point : NSObject

- (id) initWhithi:(int)i j:(int)j;
- (BOOL) isNULL;

@property (nonatomic, readwrite) int index_row;
@property (nonatomic, readwrite) int index_col;

@end


@interface gobang_board : NSObject

@property (nonatomic, readwrite) Board_point* beginPoint;
@property (nonatomic, readwrite) Board_point* endPoint;

- (bool)add_chess:(Board_point*)point;
- (void)remove_chess:(Board_point*)point;
- (int) get_chess_color:(int)x y:(int)y;
- (int) isOver:(Board_point*)point;
- (void) getWinPath:(Board_point*)point;
- (Board_point*)getBestPoint;

@end

static NSInteger kBoardSize = 15;

NS_ASSUME_NONNULL_END
