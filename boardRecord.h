//
//  boardRecord.h
//  jedi_gobang
//
//  Created by 司开发 on 2019/7/21.
//  Copyright © 2019 李杰. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "gobang_board.h"

NS_ASSUME_NONNULL_BEGIN

@interface boardRecord : NSObject

- (void)addChess:(NSInteger)row col:(NSInteger)col;
- (void)preStep;

@property (nonatomic, readwrite) NSMutableArray *boardArray;

@end

NS_ASSUME_NONNULL_END
