//
//  gobang_board.m
//  jedi_gobang
//
//  Created by dev on 2019/6/11.
//  Copyright © 2019 李杰. All rights reserved.
//

#import "gobang_board.h"

#import "modules/NSString+Reverse.h"
#import "AIAction.h"


#define add_index_scoretree         if(i<0 || i>(kBoardSize-1) || j<0 || j>(kBoardSize-1) )\
                                    {\
                                        index_scoretree += 2*pow(3,y);\
                                        continue;\
                                    }\
                                    if( current_color == boardarray[i][j] )\
                                        index_scoretree += pow(3,y);\
                                    else if( -1*current_color == boardarray[i][j] )\
                                        index_scoretree += 2*pow(3,y);\

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
int current_color;

- (id) init
{
    self = [super init];
    if(self)
    {
        current_color = 1;
        for(int i=0;i<kBoardSize;++i)
        {
            for(int j=0;j<kBoardSize;++j)
            {
                boardarray[i][j] = 0;
                _beginPoint = [[Board_point alloc] init];
                _endPoint = [[Board_point alloc] init];
            }
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
        current_color *= -1;
        return true;
    }
    return false;
}

- (void)remove_chess:(Board_point*)point
{
    if(![point isNULL])
    {
        boardarray[point.index_row-1][point.index_col-1] = 0;
        current_color *= -1;
    }
}

-(int)get_chess_color:(int)x y:(int)y
{
    return boardarray[x][y];
}

- (int) isOver:(Board_point*)point
{
    if([point isNULL] || point.index_row <= 0 || point.index_col <= 0 )
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

#pragma mark - 获取落子点得分
- (short) get_score:(Board_point*)point
{
    return [self get_L_R_score:point]+[self get_U_D_score:point]+[self get_LT_RD_score:point]+[self get_RT_LD_score:point];
}

- (short) get_L_R_score:(Board_point*)point
{
    int index_scoretree = 0;
    for(int i = point.index_row-1,j = point.index_col-2, y = 4; y<8 ;--j,++y)//落子点左边4位：3^7 3^6 3^5 3^4  右边4位：3^3 3^2 3^1 3^0
    {
        add_index_scoretree
//        else if( 0 == boardarray[point.index_row][j] )
//            index_scoretree += 0;
//+0 等于不加
    }
    for(int i = point.index_row-1,j = point.index_col, y = 3; y>=0;++j,--y)//落子点左边4位：3^7 3^6 3^5 3^4  右边4位：3^3 3^2 3^1 3^0
    {
        add_index_scoretree
    }
    return scoretree[index_scoretree];
}

- (short) get_U_D_score:(Board_point*)point
{
    int index_scoretree = 0;
    for(int i = point.index_row-2,j = point.index_col-1, y = 4; y<8 ;--i,++y)
    {
        add_index_scoretree
    }
    for(int i = point.index_row,j = point.index_col-1, y = 3; y>=0 ;++i,--y)
    {
        add_index_scoretree
    }
    return scoretree[index_scoretree];
}

- (short) get_LT_RD_score:(Board_point*)point
{
    int index_scoretree = 0;
    for(int i = point.index_row-2,j = point.index_col-2, y = 4; y<8 ;--i,--j,++y)
    {
        add_index_scoretree
    }
    for(int i = point.index_row,j = point.index_col, y = 3; y>=0 ;++i,++j,--y)
    {
        add_index_scoretree
    }
    return scoretree[index_scoretree];
}

- (short) get_RT_LD_score:(Board_point*)point
{
    int index_scoretree = 0;
    for(int i = point.index_row-2,j = point.index_col, y = 4; y<8 ;--i,++j,++y)
    {
        add_index_scoretree
    }
    for(int i = point.index_row,j = point.index_col-2, y = 3; y>=0;++i,--j,--y)
    {
        add_index_scoretree
    }
    return scoretree[index_scoretree];
}

#pragma mark - 获取获胜五子连线
- (void) getWinPath:(Board_point*)point
{
    current_color = current_color*-1;
    if( [self get_L_R_score:point] == 10000 )
    {
        [self get_L_R_begin_end:point];
    }
    else if ( [self get_U_D_score:point] == 10000 )
    {
        [self get_U_D_begin_end:point];
    }
    else if ( [self get_LT_RD_score:point] == 10000 )
    {
        [self get_LT_RD_begin_end:point];
    }
    else if ( [self get_RT_LD_score:point] == 10000 )
    {
        [self get_RT_LD_begin_end:point];
    }
    current_color = current_color*-1;
}

- (void)get_L_R_begin_end:(Board_point*)point
{
    _beginPoint.index_row = point.index_row;
    _beginPoint.index_col = point.index_col;
    _endPoint.index_row = point.index_row;
    _endPoint.index_col = point.index_col;
    for(int i = point.index_row-1,j = point.index_col-2; j>=0 && j<kBoardSize; --j)
    {
        if( current_color == boardarray[i][j] )
        {
            _beginPoint.index_row = i+1;
            _beginPoint.index_col = j+1;
        }
        else
            break;
    }
    for(int i = point.index_row-1,j = point.index_col; j>=0 && j<kBoardSize; ++j)
    {
        if( current_color == boardarray[i][j] )
        {
            _endPoint.index_row = i+1;
            _endPoint.index_col = j+1;
        }
        else
            break;
    }
}

- (void)get_U_D_begin_end:(Board_point*)point
{
    _beginPoint.index_row = point.index_row;
    _beginPoint.index_col = point.index_col;
    _endPoint.index_row = point.index_row;
    _endPoint.index_col = point.index_col;
    for(int i = point.index_row-2,j = point.index_col-1; i>=0 && i<kBoardSize; --i)
    {
        if( current_color == boardarray[i][j] )
        {
            _beginPoint.index_row = i+1;
            _beginPoint.index_col = j+1;
        }
        else
            break;
    }
    for(int i = point.index_row,j = point.index_col-1; i>=0 && i<kBoardSize; ++i)
    {
        if( current_color == boardarray[i][j] )
        {
            _endPoint.index_row = i+1;
            _endPoint.index_col = j+1;
        }
        else
            break;
    }
}

- (void)get_LT_RD_begin_end:(Board_point*)point
{
    _beginPoint.index_row = point.index_row;
    _beginPoint.index_col = point.index_col;
    _endPoint.index_row = point.index_row;
    _endPoint.index_col = point.index_col;
    for(int i = point.index_row-2,j = point.index_col-2; i>=0 && i<kBoardSize && j>=0 && j<kBoardSize; --i,--j)
    {
        if( current_color == boardarray[i][j] )
        {
            _beginPoint.index_row = i+1;
            _beginPoint.index_col = j+1;
        }
        else
            break;
    }
    for(int i = point.index_row,j = point.index_col; i>=0 && i<kBoardSize && i>=0 && i<kBoardSize; ++i,++j)
    {
        if( current_color == boardarray[i][j] )
        {
            _endPoint.index_row = i+1;
            _endPoint.index_col = j+1;
        }
        else
            break;
    }
}

- (void)get_RT_LD_begin_end:(Board_point*)point
{
    _beginPoint.index_row = point.index_row;
    _beginPoint.index_col = point.index_col;
    _endPoint.index_row = point.index_row;
    _endPoint.index_col = point.index_col;
    for(int i = point.index_row-2,j = point.index_col; i>=0 && i<kBoardSize && j>=0 && j<kBoardSize; --i,++j)
    {
        if( current_color == boardarray[i][j] )
        {
            _beginPoint.index_row = i+1;
            _beginPoint.index_col = j+1;
        }
        else
            break;
    }
    for(int i = point.index_row,j = point.index_col-2; i>=0 && i<kBoardSize && i>=0 && i<kBoardSize; ++i,--j)
    {
        if( current_color == boardarray[i][j] )
        {
            _endPoint.index_row = i+1;
            _endPoint.index_col = j+1;
        }
        else
            break;
    }
}

#pragma mark - AI
- (Board_point*)getBestPoint
{
    AIAction* AI = [[AIAction alloc] init];
    
    
    return [AI getBestPoint:boardarray current_color:current_color];
}
@end
