//
//  gobang_board.h
//  jedi_gobang
//
//  Created by dev on 2019/6/11.
//  Copyright © 2019 李杰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface Board_point : NSObject

- (id) initWhithi:(int)i j:(int)j;
- (BOOL) isNULL;

@property (nonatomic, readwrite) int index_row;
@property (nonatomic, readwrite) int index_col;

@end

@interface gobang_board : NSObject
-(bool)add_chess:(Board_point*)point;
-(int)get_chess_color:(int)x y:(int)y;
@end

static NSInteger kBoardSize = 15;

NS_ASSUME_NONNULL_END
