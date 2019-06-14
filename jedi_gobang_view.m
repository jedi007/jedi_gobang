//
//  jedi_gobang_view.m
//  octest
//
//  Created by 李杰 on 2019/4/22.
//  Copyright © 2019 李杰. All rights reserved.
//

#import "jedi_gobang_view.h"

@interface jedi_gobang_view()

@property (nonatomic, readwrite) double fW;
@property (nonatomic, readwrite) double fH;
@property (nonatomic, readwrite) double cellW;
@property (nonatomic, readwrite) double cellH;
@property (nonatomic, readwrite) double keyboardW;
@property (nonatomic, readwrite) double keyboardH;

@property (nonatomic, readwrite) CGPoint ocenter;
@property (nonatomic, readwrite) CGRect ofram;
@property (nonatomic, readwrite) CGRect lastfram;

@property (nonatomic, readwrite) gobang_board* gboard;

@end

@implementation jedi_gobang_view

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self initruntimeinfo];
        
        _gboard = [[gobang_board alloc] init];
        
        _ocenter = self.center;
        _lastfram = _ofram = self.frame;
        
        self.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:192.0/255.0 blue:148.0/255.0 alpha:1.0];
        
        self.layer.shadowOpacity = 0.8;// 阴影透明度
        self.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
        self.layer.shadowRadius = 3;// 阴影扩散的范围控制
        self.layer.shadowOffset  = CGSizeMake(5, 3);// 阴影的偏移范围
        
        self.userInteractionEnabled = true;
        UIPinchGestureRecognizer *PinRecognizer = [[UIPinchGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(foundPinch:)];
        
        
        UITapGestureRecognizer *TapRecognizer = [[UITapGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(foundTap:)];
        [TapRecognizer setNumberOfTapsRequired:1];
        [self addGestureRecognizer:TapRecognizer];
        [self addGestureRecognizer:PinRecognizer];
    }
    
    return self;
}

- (void) initruntimeinfo
{
    _fW = self.frame.size.width;
    _fH = self.frame.size.height;
    _cellW = _fW/(kBoardSize+1);
    _cellH = _fH/(kBoardSize+1);
    _keyboardW = _cellW*(kBoardSize-1);
    _keyboardH = _cellH*(kBoardSize-1);
}

- (Board_point *) getbPoint:(CGPoint)tpoint
{
    Board_point *point = [[Board_point alloc] init];
    
    double row_rem = tpoint.y/_cellH;
    row_rem = row_rem - (int)row_rem;
    double col_rem = tpoint.x/_cellW;
    col_rem = col_rem - (int)col_rem;
    if( (0.3<row_rem  &&  row_rem<0.7) || (0.3<col_rem  &&  col_rem<0.7) )
        return point;
    
    point.index_row = 0.5+tpoint.y/_cellH;
    point.index_col = 0.5+tpoint.x/_cellW;
    return point;
}

//一个空的实现产生不利的影响会表现在动画。
- (void)drawRect:(CGRect)rect
{
    // 绘制代码
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self initboard:context];
    
    for(int i=0;i<kBoardSize;++i)
    {
        for(int j=0;j<kBoardSize;++j)
        {
            int color = [_gboard get_chess_color:i y:j];
            if(color != 0)
            {
                Board_point *point = [[Board_point alloc] initWhithi:i j:j];
                [self drawchess:context chess_point:point color:color];
            }
        }
    }
}

- (void)initboard:(CGContextRef)context {
    
    //设置画笔颜色
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.5);
    //设置线条粗细
    CGContextSetLineWidth(context, 1.0);
    
    for(int i = 0; i<kBoardSize; ++i)
    {
        [self drawline:context firstPoint:CGPointMake(_cellW,(i+1)*_cellH) secondPoint:CGPointMake(_keyboardW+_cellW,(i+1)*_cellH)];
        
        [self drawline:context firstPoint:CGPointMake((i+1)*_cellW,_cellH) secondPoint:CGPointMake((i+1)*_cellW,_keyboardH+_cellH)];
    }
    CGContextStrokePath(context);
    
    //画黑点
    [[UIColor blackColor] set];
    for(int i=3;i<kBoardSize;i+=4)
    {
        for(int j=3;j<kBoardSize;j+=4)
        {
            Board_point *point = [[Board_point alloc] initWhithi:i j:j];
            CGRect frame = CGRectMake(_cellW*(point.index_col-0.1), _cellH*(point.index_row-0.1), _cellW*0.2, _cellH*0.2);
            CGContextAddEllipseInRect(context, frame);
        }
    }
    CGContextFillPath(context);
}

- (void)drawline:(CGContextRef)context firstPoint:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint
{
    CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
    CGContextAddLineToPoint(context, secondPoint.x, secondPoint.y);
}

- (void)drawchess:(CGContextRef)context chess_point:(Board_point *)point color:(int)color
{
    if( ![point isNULL] )
    {
        CGRect frame = CGRectMake(_cellW*(point.index_col-0.4), _cellH*(point.index_row-0.4), _cellW*0.8, _cellH*0.8);
        CGContextAddEllipseInRect(context, frame);
        if(color == 1)
            [[UIColor blackColor] set];
        else
            [[UIColor whiteColor] set];
        CGContextFillPath(context);
    }
}

- (void)foundPinch:(UIPinchGestureRecognizer *)recognizer
{
    NSLog(@"foundPinch");
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan://缩放开始
        case UIGestureRecognizerStateChanged://缩放改变
        {
            double scale=recognizer.scale;
            NSLog(@"scale : %1.3f",scale);
            
            self.frame = CGRectMake(_lastfram.origin.x, _lastfram.origin.y , _lastfram.size.height*scale , _lastfram.size.width*scale );
            [self initruntimeinfo];
            
            break;
        }
        case UIGestureRecognizerStateEnded://缩放结束
        {
            _lastfram = self.frame;
            break;
        }
        default:
            break;
    }
}

- (void)foundTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    Board_point *bpoint = [self getbPoint:point];
    NSLog(@"found tap bPoint ---- row:%ld  col:%ld",(long)bpoint.index_row,(long)bpoint.index_col);
    
    if( [_gboard add_chess:bpoint] )
    {
        _lastfram = self.frame = _ofram;
        [self initruntimeinfo];
        [self setNeedsDisplay];
    }
}
@end
