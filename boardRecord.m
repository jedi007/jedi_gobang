//
//  boardRecord.m
//  jedi_gobang
//
//  Created by 司开发 on 2019/7/21.
//  Copyright © 2019 李杰. All rights reserved.
//

#import "boardRecord.h"

@implementation boardRecord

@synthesize lastPoint = _lastPoint;

NSInteger lastStepIndex;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _boardArray = [[NSMutableArray alloc]initWithCapacity:kBoardSize];
        _lastPoint = [[Board_point alloc] init];
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
    lastStepIndex++;
    NSLog(@"boardRecord's addChess is called，lastStepIndex is : %ld ",lastStepIndex);
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
                    NSLog(@"boardRecord's preStep is called，lastStepIndex is : %ld ",lastStepIndex);
                    return;
                }
            }
        }
    }
}

- (Board_point*)lastPoint
{
    NSLog(@"getlastPoint is called");
    if(lastStepIndex>0)
    {
        for (int i=0; i<kBoardSize; ++i) {
            for (int j=0; j<kBoardSize; ++j) {
                if( [[[_boardArray objectAtIndex:i] objectAtIndex:j] integerValue] == lastStepIndex)
                {
                    _lastPoint.index_row = i+1;
                    _lastPoint.index_col = j+1;
                }
            }
        }
    }
    else
        return nil;
    return _lastPoint;
}

@end
