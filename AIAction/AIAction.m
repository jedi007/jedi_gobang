//
//  AIAction.m
//  jedi_gobang
//
//  Created by 司开发 on 2019/10/1.
//  Copyright © 2019 李杰. All rights reserved.
//

#import "AIAction.h"


#define add_index_scoretree         if(i<0 || i>(kBoardSize-1) || j<0 || j>(kBoardSize-1) )\
                                    {\
                                        index_scoretree += 2*pow(3,y);\
                                        continue;\
                                    }\
                                    if( _current_color == tBoard[i][j] )\
                                        index_scoretree += pow(3,y);\
                                    else if( -1*_current_color == tBoard[i][j] )\
                                        index_scoretree += 2*pow(3,y);\


@implementation bestScorePoint
- (id) init
{
    if (self = [super init])
    {
        _i = -1;
        _j = -1;
        _score = -1;
    }
    return self;
}
- (void) dealloc
{
    NSLog(@"bestScorePoint dealloc is called");
}
@end

@interface AIAction()
{
    intsptr tBoard;
    
}

@end

@implementation AIAction

- (Board_point *)getBestPoint: ( intsptr )board current_color:(int)c_color
{
    [self boardCopy:board];
    _current_color = c_color;
    NSLog(@"c_color: %d",c_color);
    [self showtBoard];
    
 
    
    
    bestScorePoint* bestSP = [[bestScorePoint alloc] init];
    int cScore;
    for (int i=0; i<kBoardSize; i++) {
        for (int j=0; j<kBoardSize; j++) {
            if( tBoard[i][j] == 0 )
            {
                cScore = [self getScore:i j:j];
                NSLog(@"get the score is : %d",cScore);
                if ( cScore > bestSP.score) {
                    bestSP.score = cScore;
                    bestSP.i = i;
                    bestSP.j = j;
                }
            }
        }
    }
    
    
    
    
    
    return [[Board_point alloc] initWhithi:bestSP.i j:bestSP.j];
}

-(void)showtBoard
{
    for (int i=0; i<kBoardSize; i++) {
        for (int j=0; j<kBoardSize; j++) {
            NSLog(@"tBoard[%d][%d]: %d",i,j,tBoard[i][j]);
        }
    }
}

- (int)getScore:(int)i j:(int)j
{
    return [self get_L_R_score:i j:j] + [self get_U_D_score:i j:j] + [self get_LT_RD_score:i j:j] + [self get_RT_LD_score:i j:j];
}

- (short) get_L_R_score:(int)it j:(int)jt
{
    int index_scoretree = 0;
    for(int i = it,j = jt-1, y = 4; y<8 ;--j,++y)//落子点左边4位：3^7 3^6 3^5 3^4  右边4位：3^3 3^2 3^1 3^0
    {
        add_index_scoretree
//        else if( 0 == boardarray[i+1][j] )
//            index_scoretree += 0;
//+0 等于不加
    }
    for(int i = it,j = jt+1, y = 3; y>=0;++j,--y)//落子点左边4位：3^7 3^6 3^5 3^4  右边4位：3^3 3^2 3^1 3^0
    {
        add_index_scoretree
    }
    NSLog(@"L_R_index_scoretree: %d",index_scoretree);
    return scoretree[index_scoretree];
}

- (short) get_U_D_score:(int)it j:(int)jt
{
    int index_scoretree = 0;
    for(int i = it-1,j = jt, y = 4; y<8 ;--i,++y)
    {
        add_index_scoretree
    }
    for(int i = it+1,j = jt, y = 3; y>=0 ;++i,--y)
    {
        add_index_scoretree
    }
    NSLog(@"U_D_index_scoretree: %d",index_scoretree);
    return scoretree[index_scoretree];
}

- (short) get_LT_RD_score:(int)it j:(int)jt
{
    int index_scoretree = 0;
    for(int i = it-1,j = jt-1, y = 4; y<8 ;--i,--j,++y)
    {
        add_index_scoretree
    }
    for(int i = it+1,j = jt+1, y = 3; y>=0 ;++i,++j,--y)
    {
        add_index_scoretree
    }
    NSLog(@"LT_RD_index_scoretree: %d",index_scoretree);
    return scoretree[index_scoretree];
}

- (short) get_RT_LD_score:(int)it j:(int)jt
{
    int index_scoretree = 0;
    for(int i = it-1,j = jt+1, y = 4; y<8 ;--i,++j,++y)
    {
        add_index_scoretree
    }
    for(int i = it+1,j = jt-1, y = 3; y>=0;++i,--j,--y)
    {
        add_index_scoretree
    }
    NSLog(@"RT_LD_index_scoretree: %d",index_scoretree);
    return scoretree[index_scoretree];
}

- (void)boardCopy:(intsptr)board
{
    for(int i=0;i<kBoardSize;i++)
    {
        for (int j=0; j<kBoardSize; j++) {
            tBoard[i][j] = board[i][j];
        }
    }
}
@end
