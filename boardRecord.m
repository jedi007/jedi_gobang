//
//  boardRecord.m
//  jedi_gobang
//
//  Created by 司开发 on 2019/7/21.
//  Copyright © 2019 李杰. All rights reserved.
//

#import "boardRecord.h"

@implementation boardRecord

NSInteger lastStepIndex;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _boardArray = [[NSMutableArray alloc]initWithCapacity:kBoardSize];
        lastStepIndex = 0;
        for (int i=0; i<kBoardSize; ++i) {
            NSMutableArray* rowArray = [[NSMutableArray alloc]initWithCapacity:kBoardSize];
            for (int j=0; j<kBoardSize; ++j) {
                NSNumber *number = [NSNumber numberWithInt:0];
                [rowArray addObject:number];
            }
            [_boardArray addObject:rowArray];
        }
    }
    return self;
}

- (void)addChess:(NSInteger)row col:(NSInteger)col
{
    NSLog(@"boardRecord's addChess is called");
    lastStepIndex++;
    [[_boardArray objectAtIndex:row] replaceObjectAtIndex:col withObject:[NSNumber numberWithInteger:lastStepIndex]];
}

- (void)preStep
{
    
    if(lastStepIndex>0)
    {
        for (int i=0; i<kBoardSize; ++i) {
            for (int j=0; j<kBoardSize; ++j) {
                if( [[[_boardArray objectAtIndex:i] objectAtIndex:j] integerValue] == lastStepIndex)
                {
                    [[_boardArray objectAtIndex:i] replaceObjectAtIndex:j withObject:[NSNumber numberWithInteger:0]];
                    lastStepIndex--;
                    return;
                }
            }
        }
    }
}
@end
