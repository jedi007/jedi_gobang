//
//  scoretree.m
//  jedi_gobang
//
//  Created by dev on 2019/6/13.
//  Copyright © 2019 李杰. All rights reserved.
//

#import "scoretree.h"
#import "modules/NSString+Reverse.h"

short scoretree[6561];
short get_score_base(NSString *str)
{
    //字条串是否包含有某字符串
    if ( [str rangeOfString:@"11111"].location != NSNotFound ) {
        return 10000;
    }
    else if( [str rangeOfString:@"011110"].location != NSNotFound )//活4
    {
        return 3000;
    }
    else if( [str rangeOfString:@"011100"].location != NSNotFound )//活3
    {
        return 1000;
    }
    else if( [str rangeOfString:@"011010"].location != NSNotFound )//活3
    {
        return 1000;
    }
    else if( [str rangeOfString:@"11110"].location != NSNotFound )//冲4
    {
        return 600;
    }
    else if( [str rangeOfString:@"11101"].location != NSNotFound )//冲4
    {
        return 600;
    }
    else if( [str rangeOfString:@"11011"].location != NSNotFound )//冲4
    {
        return 600;
    }
    else if( [str rangeOfString:@"011000"].location != NSNotFound )//活2
    {
        return 100;
    }
    else if( [str rangeOfString:@"001100"].location != NSNotFound )//活2
    {
        return 100;
    }
    else if( [str rangeOfString:@"010100"].location != NSNotFound )//活2
    {
        return 100;
    }
    else if( [str rangeOfString:@"11100"].location != NSNotFound )//冲3
    {
        return 100;
    }
    else if( [str rangeOfString:@"11010"].location != NSNotFound )//冲3
    {
        return 100;
    }
    else if( [str rangeOfString:@"11001"].location != NSNotFound )//冲3
    {
        return 100;
    }
    else if( [str rangeOfString:@"11000"].location != NSNotFound )//冲2
    {
        return 50;
    }
    else if( [str rangeOfString:@"01100"].location != NSNotFound )//冲2
    {
        return 50;
    }
    
    return 0;
}

short get_score(NSString *str)
{
    short L = get_score_base(str);
    short R = get_score_base( [str stringByReversed] );
    
    return L>R?L:R;
}

void init_scoretree()
{
    NSLog(@"init_scoretree is called");
    
    int i=0;
    for( int N1 = 0; N1 < 3; ++N1)
    {
        for( int N2 = 0; N2 < 3; ++N2)
        {
            for( int N3 = 0; N3 < 3; ++N3)
            {
                for( int N4 = 0; N4 < 3; ++N4)
                {
                    for( int N5 = 0; N5 < 3; ++N5)
                    {
                        for( int N6 = 0; N6 < 3; ++N6)
                        {
                            for( int N7 = 0; N7 < 3; ++N7)
                            {
                                for( int N8 = 0; N8 < 3; ++N8)
                                {
                                    NSString *str = [[NSString alloc] initWithFormat:@"%d%d%d%d1%d%d%d%d", N1,N2,N3,N4,N5,N6,N7,N8];
                                    scoretree[i] = get_score(str);
                                    NSLog(@"%@",str);
                                    NSLog(@"scoretree[%d]: %d",i,scoretree[i]);
                                    i++;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
