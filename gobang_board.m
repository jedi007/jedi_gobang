//
//  gobang_board.m
//  jedi_gobang
//
//  Created by dev on 2019/6/11.
//  Copyright © 2019 李杰. All rights reserved.
//

#import "gobang_board.h"

@implementation Board_point
- (id) init
{
    if (self = [super init])
    {
        _index_row = -1;
        _index_col = -1;
    }
    return self;
}

- (id) initWhithi:(int)i j:(int)j
{
    if (self = [super init])
    {
        _index_row = i+1;
        _index_col = j+1;
    }
    return self;
}

- (BOOL) isNULL
{
    if(_index_col < 0 || _index_row < 0)
        return true;
    else
        return false;
}

- (void) dealloc
{
    //NSLog(@"Board_point dealloc is called");
}
@end

@implementation gobang_board

int boardarray[15][15];
int current_color = 1;

- (id) init
{
    self = [super init];
    for(int i=0;i<15;++i)
    {
        for(int j=0;j<15;++j)
        {
            boardarray[i][j] = 0;
        }
    }
    return self;
}

-(bool)add_chess:(Board_point*)point
{
    if(![point isNULL] && boardarray[point.index_row-1][point.index_col-1]==0 )
    {
        boardarray[point.index_row-1][point.index_col-1] = current_color;
        current_color = -1*current_color;
        return true;
    }
    return false;
}

-(int)get_chess_color:(int)x y:(int)y
{
    return boardarray[x][y];
}
@end
