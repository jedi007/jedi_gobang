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
@property (nonatomic, readwrite) CGPoint PinchPerCenter;//按百分比描述到缩放中心
@property (nonatomic, readwrite) CGPoint PinchRelativeCenter;//以两根手指中心点为缩放中心，该中心相对显示view的左上角相对坐标始终不变
@property (nonatomic, readwrite) CGRect ofram;
@property (nonatomic, readwrite) CGRect lastfram;
@property (nonatomic, readwrite) CGPoint lastcenter;
@property (nonatomic, readwrite) double lastscale;

@property (nonatomic, readwrite) gobang_board* gboard;

@end

@implementation jedi_gobang_view

NSTimer* timer;//用于区分棋盘点单击和双击

- (void)setFrameForReSet:(CGRect)frame
{
    _lastfram = _ofram = self.frame = frame;
    [self initruntimeinfo];
    
    _gboard = [[gobang_board alloc] init];
    
    _lastcenter = _ocenter = self.center;
    _lastscale = 1;
    
    self.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:192.0/255.0 blue:148.0/255.0 alpha:1.0];
    
    self.layer.shadowOpacity = 0.8;// 阴影透明度
    self.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    self.layer.shadowRadius = 2;// 阴影扩散的范围控制
    self.layer.shadowOffset  = CGSizeMake(4, 3);// 阴影的偏移范围
    
    //self.userInteractionEnabled = true;
    UIPinchGestureRecognizer* PinRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(foundPinch:)];
    
    UITapGestureRecognizer* TapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foundTap:)];
    [TapRecognizer setNumberOfTapsRequired:1];
    
    UITapGestureRecognizer* doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foundDoubleTap:)];
    [doubleTapRecognizer setNumberOfTapsRequired:2];
    
    UIPanGestureRecognizer* PanRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(foundPan:)];
    PanRecognizer.minimumNumberOfTouches = 1;
    
    [self addGestureRecognizer:TapRecognizer];
    [self addGestureRecognizer:doubleTapRecognizer];
    [self addGestureRecognizer:PinRecognizer];
    [self addGestureRecognizer:PanRecognizer];
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
    //NSLog(@"foundPinch");
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan://缩放开始
        {
            NSUInteger touchCount = recognizer.numberOfTouches;
            if (touchCount == 2)
            {
                CGPoint p1 = [recognizer locationOfTouch: 0 inView:self ];
                CGPoint p2 = [recognizer locationOfTouch: 1 inView:self ];
                CGPoint newCenter = CGPointMake( (p1.x+p2.x)/2 , (p1.y+p2.y)/2 );
                _PinchPerCenter = CGPointMake(newCenter.x/_fW, newCenter.y/_fH);
                
                _PinchRelativeCenter = [self convertPoint:newCenter toView:self.superview];
            }
            break;
        }
        case UIGestureRecognizerStateChanged://缩放改变
        {
            double scale=recognizer.scale;
            
            if( fabs(_lastscale - scale) < 0.01 )
            {
                return;
            }
            _lastscale = scale;
            
            NSUInteger touchCount = recognizer.numberOfTouches;
            if (touchCount == 2)
            {
                CGFloat targetW = _lastfram.size.width*scale;
                CGFloat targetH = _lastfram.size.height*scale;
                
                CGPoint finger_center = CGPointMake(targetW*_PinchPerCenter.x, targetH*_PinchPerCenter.y);
                CGFloat targetX = -(finger_center.x-_PinchRelativeCenter.x);
                CGFloat targetY = -(finger_center.y-_PinchRelativeCenter.y);
                
                self.frame = [self makeTargetFrame:targetX targetY:targetY targetW:targetW targetH:targetH];
                
                [self initruntimeinfo];
            }
            break;
        }
        case UIGestureRecognizerStateEnded://缩放结束
        {
            [self endGestureRecognizer];
            break;
        }
        default:
            break;
    }
}

- (void)foundTap:(UITapGestureRecognizer *)recognizer
{
    [timer invalidate];
    timer = nil;
    CGPoint point = [recognizer locationInView:self];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:NO block:^(NSTimer* timer){
        NSLog(@"timer is out");
        [timer invalidate];
        NSLog(@"after invalidate timer is: %@",timer);
        
        //CGPoint point = [recognizer locationInView:self];
        Board_point *bpoint = [self getbPoint:point];
        NSLog(@"found tap bPoint ---- row:%ld  col:%ld",(long)bpoint.index_row,(long)bpoint.index_col);
        
        int overkey = [self->_gboard isOver:bpoint];
        
        if( [self->_gboard add_chess:bpoint] )
        {
            self->_lastfram = self.frame = self->_ofram;
            [self initruntimeinfo];
            [self setNeedsDisplay];
        }
        
        NSLog(@"引发通知！！！ overkey:%d",overkey);
        if( overkey )
        {
            Board_point* beginPoint = [[Board_point alloc] init];
            Board_point* endPoint = [[Board_point alloc] init];
            [self->_gboard getWinPath:bpoint beginPoint:&beginPoint endPoint:&endPoint];
            NSLog(@"beginPoint is: %d,%d ,endPoint is : %d,%d",beginPoint.index_row,beginPoint.index_col,endPoint.index_row,endPoint.index_col);
            
            [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:NO block:^(NSTimer* timer){
                NSString* color = overkey==1?@"黑方":@"白方";
                //引发通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertWinner" object:color];
            }];
        }
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)foundDoubleTap:(UITapGestureRecognizer *)recognizer
{
    [timer invalidate];
    
    CGPoint newCenter = [recognizer locationInView:self];
    NSLog(@"foundDoubleTap and newCenter: %1.2f - %1.2f",newCenter.x,newCenter.y);
    _PinchPerCenter = CGPointMake(newCenter.x/_fW, newCenter.y/_fH);
    _PinchRelativeCenter = [self convertPoint:newCenter toView:self.superview];
    
    CGFloat targetW = _lastfram.size.width*1.3;
    CGFloat targetH = _lastfram.size.height*1.3;
    CGPoint finger_center = CGPointMake(targetW*_PinchPerCenter.x, targetH*_PinchPerCenter.y);
    CGFloat targetX = -(finger_center.x-_PinchRelativeCenter.x);
    CGFloat targetY = -(finger_center.y-_PinchRelativeCenter.y);
    
    self.frame = [self makeTargetFrame:targetX targetY:targetY targetW:targetW targetH:targetH];
    
    [self initruntimeinfo];
    [self endGestureRecognizer];
}

- (void)foundPan:(UIPanGestureRecognizer *)pan
{
    //NSLog(@"foundPan is called");
    CGPoint point = [pan translationInView:pan.view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan://开始
        case UIGestureRecognizerStateChanged://改变
        {
            CGFloat targetX = _lastfram.origin.x+point.x;
            CGFloat targetY = _lastfram.origin.y+point.y;
            self.frame = [self makeTargetFrame:targetX targetY:targetY targetW:_lastfram.size.width targetH:_lastfram.size.height];
            break;
        }
        case UIGestureRecognizerStateEnded://结束
        {
            NSLog(@"foundPan end");
            [self endGestureRecognizer];
            break;
        }
        default:
            break;
    }
    
    //pan.view.transform =CGAffineTransformMakeTranslation(point.x, point.y);
    //pan.view.transform = CGAffineTransformTranslate(pan.view.transform, point.x, point.y);
    //[pan setTranslation:CGPointZero inView:pan.view];
}

- (CGRect)makeTargetFrame:(CGFloat)targetX targetY:(CGFloat)targetY targetW:(CGFloat)targetW targetH:(CGFloat)targetH
{
    CGRect rect;
    
    if( targetH < _ofram.size.height )
    {
        targetW = _ofram.size.width;
        targetH = _ofram.size.height;
    }
    
    if( targetX > 0 )
        targetX = 0;
    else if( targetX < (-targetW+_ofram.size.width) )
        targetX = -targetW+_ofram.size.width;
    
    if( targetY > 0 )
        targetY = 0;
    else if ( targetY < (-targetH+_ofram.size.height) )
        targetY = (-targetH+_ofram.size.height);
    
    rect.origin.x = targetX;
    rect.origin.y = targetY;
    rect.size.width = targetW;
    rect.size.height = targetH;
    return rect;
}

- (void)endGestureRecognizer
{
    _lastcenter =  self.center;
    _lastfram = self.frame;
    _lastscale = 1;
}

@end
