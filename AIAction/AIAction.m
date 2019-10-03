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
                                    if( color == board[i][j] )\
                                        index_scoretree += pow(3,y);\
                                    else if( -1*color == board[i][j] )\
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

- (id) initWith_i:(int)i j:(int)j score:(int)score
{
    if (self = [super init])
    {
        _i = i;
        _j = j;
        _score = score;
    }
    return self;
}
@end

@interface AIAction()


@end

@implementation AIAction

- (bestScorePoint *)getBestPoint: ( intsptr )board current_color:(int)c_color deep:(int)deep width:(int)width
{
    if (deep>0) {
        NSArray* sortedArray = [self get_sortedScoreArray:board color:c_color width:width];
        NSArray* enemy_sortedArray = [self get_sortedScoreArray:board color:c_color*-1 width:width];
        
        bestScorePoint* bestSP = [sortedArray objectAtIndex:0];
        bestScorePoint* enemy_bestSP = [enemy_sortedArray objectAtIndex:0];
        if (bestSP.score > 9999) {
            return bestSP;
        } else if (enemy_bestSP.score > 9999){
            return enemy_bestSP;
        } else if (bestSP.score > 2999){
            return bestSP;
        } else if (enemy_bestSP.score > 2999){
            return enemy_bestSP;
        }
        
        
        NSMutableArray *total_sortedArray = [self get_total_sortedArray:sortedArray ayyay2:enemy_sortedArray];
        
        if (deep ==4) {
            [self showArray:total_sortedArray];
        }
        
        
        
        NSInteger count =total_sortedArray.count;
        int random = arc4random()%10000;
        NSString* dispatch_queue_name = [[NSString alloc] initWithFormat:@"com.jedigobang.concurrentDispatchQueue.%d.%d",deep,random];
        dispatch_queue_t myConcurrentDispatchQueue = dispatch_queue_create( [dispatch_queue_name UTF8String], DISPATCH_QUEUE_CONCURRENT);
        dispatch_apply(count, myConcurrentDispatchQueue, ^(size_t index){
            //NSLog(@"index in myConcurrentDispatchQueue: %zu ,deep is %d",index,deep);
            intsptr dispatch_tBoard;
            [self boardCopy:board tboard:dispatch_tBoard];
            bestScorePoint *tPoint = [total_sortedArray objectAtIndex:index];
            dispatch_tBoard[tPoint.i][tPoint.j] = c_color;
            
            AIAction* action = [[AIAction alloc] init];
            bestScorePoint *dispatch_best_point = [action getBestPoint:dispatch_tBoard current_color:c_color*-1 deep:deep-1 width:width];
            ((bestScorePoint *)[total_sortedArray objectAtIndex:index]).score = - dispatch_best_point.score;
        });
        
        NSArray* resultArray = [self sortArray:total_sortedArray];
        
        bestScorePoint* bp = [resultArray objectAtIndex:0];
        NSLog(@"return bp is i:%d  j:%d  score:%d",bp.i,bp.j,bp.score);
        
        return [resultArray objectAtIndex:0];
    } else {
        NSArray* sortedArray = [self get_sortedScoreArray:board color:c_color width:10];
        
        NSArray* enemy_sortedArray = [self get_sortedScoreArray:board color:c_color*-1 width:10];
        
        int sortedArray_totalScore = 0;
        for (int  i =0; i<sortedArray.count; i++) {
            sortedArray_totalScore += ( (bestScorePoint *)[sortedArray objectAtIndex:i]).score;
        }
        
        int enemy_sortedArray_totalScore = 0;
        for (int  i =0; i<sortedArray.count; i++) {
            enemy_sortedArray_totalScore += ( (bestScorePoint *)[enemy_sortedArray objectAtIndex:i]).score;
        }
        
        return [[bestScorePoint alloc] initWith_i:-1 j:-1 score:sortedArray_totalScore-enemy_sortedArray_totalScore];
    }
}

- (NSArray* )get_sortedScoreArray:( intsptr )board color:(int)color width:(int)width{
    NSMutableArray* bestsSP = [[NSMutableArray alloc] init];
    int cScore;
    for (int i=0; i<kBoardSize; i++) {
        for (int j=0; j<kBoardSize; j++) {
            if (i==6 && j==9) {
                NSLog(@"board[6][9]: %d",board[i][j]);
                NSLog(@"board[6][13]: %d",board[6][13]);
            }
            if( board[i][j] == 0 )
            {
                cScore = [self getScore:board color:color i:i j:j];
                if (i==6 && j==9) {
                    NSLog(@"board[6][9]  cScore: %d",cScore);
                }
                if ( cScore > 0) {
                    [bestsSP addObject:[[bestScorePoint alloc] initWith_i:i j:j score:cScore] ];
                }
            }
        }
    }
    NSInteger twidth = width;
    NSArray *tArray = [self sortArray:bestsSP];
    if (tArray.count > width) {
        tArray = [tArray subarrayWithRange:NSMakeRange(0, twidth)];
    }
    
    return tArray;
}

- (NSMutableArray*)get_total_sortedArray:(NSArray*)array1 ayyay2:(NSArray*)array2
{
    NSMutableArray* total_sortedArray = [[NSMutableArray alloc] initWithArray:array1];
    
    for (int i = 0; i<array2.count; i++) {
        bestScorePoint *p2 = [array2 objectAtIndex:i];
        bool shouldAdd = true;
        for (int j = 0;j<array1.count; j++) {
            bestScorePoint *p1 = [array1 objectAtIndex:j];
            if ( p1.i == p2.i && p1.j == p2.j) {
                shouldAdd = false;
                break;
            }
        }
        if ( shouldAdd ) {
            p2.score *= 0.9;
            [total_sortedArray addObject:p2];
        }
    }
    
    return total_sortedArray;
}

- (NSArray* )sortArray:(NSArray* )array
{
    return [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        bestScorePoint *p1 = (bestScorePoint *)obj1;
        bestScorePoint *p2 = (bestScorePoint *)obj2;
        // 因为不满足sortedArrayUsingComparator方法的默认排序顺序，则需要交换
        if ( p1.score < p2.score ) return NSOrderedDescending;
        return NSOrderedAscending;
    }];
}

- (void)showArray:( NSArray* )array
{
    NSLog(@"begin show array");
    for (int i = 0; i<array.count; i++) {
        bestScorePoint* p = [array objectAtIndex:i];
        NSLog(@"array[%d]: i:%d j%d score:%d",i,p.i,p.j,p.score);
    }
    NSLog(@"end show array");
}

- (int)getScore:( intsptr )board color:(int)c_color i:(int)i j:(int)j
{
    return [self get_L_R_score:board color:c_color i:i j:j] + [self get_U_D_score:board color:c_color i:i j:j] + [self get_LT_RD_score:board color:c_color i:i j:j] + [self get_RT_LD_score:board color:c_color i:i j:j];
}

- (short) get_L_R_score:( intsptr )board color:(int)color i:(int)it j:(int)jt
{
    int index_scoretree = 0;
    for(int i = it,j = jt-1, y = 4; y<8 ;--j,++y)//落子点左边4位：3^7 3^6 3^5 3^4  右边4位：3^3 3^2 3^1 3^0
    {
        if(i<0 || i>(kBoardSize-1) || j<0 || j>(kBoardSize-1) )
        {
            index_scoretree += 2*pow(3,y);
            continue;
        }
        if( color == board[i][j] )
            index_scoretree += pow(3,y);
        else if( -1*color == board[i][j] )
            index_scoretree += 2*pow(3,y);
//        else if( 0 == boardarray[i+1][j] )
//            index_scoretree += 0;
//+0 等于不加
    }
    for(int i = it,j = jt+1, y = 3; y>=0;++j,--y)//落子点左边4位：3^7 3^6 3^5 3^4  右边4位：3^3 3^2 3^1 3^0
    {
        if(i<0 || i>(kBoardSize-1) || j<0 || j>(kBoardSize-1) )
        {
            index_scoretree += 2*pow(3,y);
            continue;
        }
        if (it==6 && jt==9) {
            NSLog(@"======== board[%d][%d]: %d",i,j,board[i][j]);
            
        }
        if( color == board[i][j] )
            index_scoretree += pow(3,y);
        else if( -1*color == board[i][j] )
            index_scoretree += 2*pow(3,y);
    }
    //NSLog(@"L_R_index_scoretree: %d",index_scoretree);
    if (it==6 && jt==9) {
        NSLog(@"board[6][9]  index_scoretree: %d",index_scoretree);
        
    }
    return scoretree[index_scoretree];
}

- (short) get_U_D_score:( intsptr )board color:(int)color i:(int)it j:(int)jt
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
    //NSLog(@"U_D_index_scoretree: %d",index_scoretree);
    return scoretree[index_scoretree];
}

- (short) get_LT_RD_score:( intsptr )board color:(int)color i:(int)it j:(int)jt
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
    //NSLog(@"LT_RD_index_scoretree: %d",index_scoretree);
    return scoretree[index_scoretree];
}

- (short) get_RT_LD_score:( intsptr )board color:(int)color i:(int)it j:(int)jt
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
    //NSLog(@"RT_LD_index_scoretree: %d",index_scoretree);
    return scoretree[index_scoretree];
}

- (void)boardCopy:(intsptr)board tboard:(intsptr)tboard
{
    for(int i=0;i<kBoardSize;i++)
    {
        for (int j=0; j<kBoardSize; j++) {
            tboard[i][j] = board[i][j];
        }
    }
}
@end
