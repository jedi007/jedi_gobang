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
 
    
    
    bestScorePoint* bestSP = [[bestScorePoint alloc] init];
    int cScore;
    for (int i=0; i<kBoardSize; i++) {
        for (int j=0; j<kBoardSize; j++) {
            if( board[i][j] == 0 )
            {
                cScore = [self getScore:i j:j];
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



- (int)getScore:(int)i j:(int)j
{
    return 0;
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
