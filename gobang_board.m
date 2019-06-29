//
//  gobang_board.m
//  jedi_gobang
//
//  Created by dev on 2019/6/11.
//  Copyright © 2019 李杰. All rights reserved.
//

#import "gobang_board.h"

#import "modules/NSString+Reverse.h"

#define add_index_scoretree         if( current_color == boardarray[i][j] )\
                                        index_scoretree += pow(3,4+y);\
                                    else if( -1*current_color == boardarray[i][j] )\
                                        index_scoretree += 2*pow(3,4+y);\

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
        [self isOver:point];
        current_color = -1*current_color;
        return true;
    }
    return false;
}

-(int)get_chess_color:(int)x y:(int)y
{
    return boardarray[x][y];
}

- (int) isOver:(Board_point*)point
{
    if([point isNULL] || point.index_row < 0 || point.index_col < 0 )
        return 0;
        
    short score = [self get_score:point];
    
    NSLog(@"score is %d",score);
    if( score >= 10000 )
    {
        NSLog(@"color : %d  is winner!!!",current_color);
        return current_color;
    }
    return 0;
}

- (short) get_score:(Board_point*)point
{
    return [self get_L_R_score:point]+[self get_U_D_score:point]+[self get_LT_RD_score:point]+[self get_RT_LD_score:point];
}

- (short) get_L_R_score:(Board_point*)point
{
    int index_scoretree = 0;
    NSLog(@"current color is %d",current_color);
    for(int i = point.index_row-1,j = point.index_col-2, y = 0; j>0;--j,++y)
    {
        add_index_scoretree
//        else if( 0 == boardarray[point.index_row][j] )
//            index_scoretree += 0;
//+0 等于不加
    }
    for(int i = point.index_row-1,j = point.index_col, y = 0; j<kBoardSize;++j,++y)
    {
        add_index_scoretree
    }
    NSLog(@"L_R_index_scoretree: %d",index_scoretree);
    return scoretree[index_scoretree];
}

- (short) get_U_D_score:(Board_point*)point
{
    int index_scoretree = 0;
    for(int i = point.index_row-2,j = point.index_col-1, y = 0; i>0;--i,++y)
    {
        add_index_scoretree
    }
    for(int i = point.index_row,j = point.index_col-1, y = 0; i<kBoardSize;++i,++y)
    {
        add_index_scoretree
    }
    NSLog(@"U_D_index_scoretree: %d",index_scoretree);
    return scoretree[index_scoretree];
}

- (short) get_LT_RD_score:(Board_point*)point
{
    int index_scoretree = 0;
    for(int i = point.index_row-2,j = point.index_col-2, y = 0; i>0 && j>0;--i,--j,++y)
    {
        add_index_scoretree
    }
    for(int i = point.index_row,j = point.index_col, y = 0; i<kBoardSize && j<kBoardSize;++i,++j,++y)
    {
        add_index_scoretree
    }
    NSLog(@"LT_RD_index_scoretree: %d",index_scoretree);
    return scoretree[index_scoretree];
}

- (short) get_RT_LD_score:(Board_point*)point
{
    int index_scoretree = 0;
    for(int i = point.index_row-2,j = point.index_col, y = 0; i>0 && j>0;--i,++j,++y)
    {
        add_index_scoretree
    }
    for(int i = point.index_row,j = point.index_col-2, y = 0; i<kBoardSize && j<kBoardSize;++i,--j,++y)
    {
        add_index_scoretree
    }
    NSLog(@"RT_LD_index_scoretree: %d",index_scoretree);
    return scoretree[index_scoretree];
}

@end
