//
//  GoBoard.m
//  nixGoBoard
//
//  Created by nixzhu on 12-7-1.
//  Copyright (c) 2012年 CandyStar. All rights reserved.
//  Email: zhuhongxu@gmail.com

#import "GoBoard.h"

@implementation GoBoard
@synthesize touch;
@synthesize touchX;
@synthesize touchY;
@synthesize gridlen;
@synthesize offset;
@synthesize movecount;

- (void)initBoard
{
    int i, j;
    for (i = 0; i < LINE_NUM; i++) {
        for (j = 0; j < LINE_NUM; j++) {
            trueBoard[i][j] = 0;
        }
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self setGridlen:38];
        [self setOffset:32];
        [self setTouchX:-100]; //TODO
        [self setTouchY:-100];
        [self initBoard];
        [self setMovecount:0];
        jie = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)grid:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {0.0, 0.0, 0.0, 1.0};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetStrokeColorWithColor(context, color);
    int i;
    
    for (i = 0; i < LINE_NUM; i++) {
        CGContextMoveToPoint(context, 0+offset, i*gridlen+offset);
        CGContextAddLineToPoint(context, (LINE_NUM-1)*gridlen+offset, i*gridlen+offset);
        CGContextStrokePath(context);

    }
    for (i = 0; i < LINE_NUM; i++) {
        CGContextMoveToPoint(context, i*gridlen+offset, 0+offset);
        CGContextAddLineToPoint(context, i*gridlen+offset, (LINE_NUM-1)*gridlen+offset);
        CGContextStrokePath(context);
        
    }
    
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}
- (void)ninePoints:(CGContextRef)context // TODO, LINE_NUM xxx
{
    /* Draw some circles */
    CGFloat r = 4;
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor]));    
    CGContextAddArc(context, 3*gridlen+offset, 3*gridlen+offset, r, 0, M_PI*2, 0);
    CGContextClosePath(context); 
    CGContextFillPath(context); 
    
    CGContextAddArc(context, 9*gridlen+offset, 3*gridlen+offset, r, 0, M_PI*2, 0);
    CGContextClosePath(context); 
    CGContextFillPath(context); 
    
    CGContextAddArc(context, 15*gridlen+offset, 3*gridlen+offset, r, 0, M_PI*2, 0);
    CGContextClosePath(context); 
    CGContextFillPath(context); 
    
    CGContextAddArc(context, 3*gridlen+offset, 9*gridlen+offset, r, 0, M_PI*2, 0);
    CGContextClosePath(context); 
    CGContextFillPath(context); 
    
    CGContextAddArc(context, 9*gridlen+offset, 9*gridlen+offset, r, 0, M_PI*2, 0);
    CGContextClosePath(context); 
    CGContextFillPath(context); 
    
    CGContextAddArc(context, 15*gridlen+offset, 9*gridlen+offset, r, 0, M_PI*2, 0);
    CGContextClosePath(context); 
    CGContextFillPath(context); 
    
    CGContextAddArc(context, 3*gridlen+offset, 15*gridlen+offset, r, 0, M_PI*2, 0);
    CGContextClosePath(context); 
    CGContextFillPath(context); 
    
    CGContextAddArc(context, 9*gridlen+offset, 15*gridlen+offset, r, 0, M_PI*2, 0);
    CGContextClosePath(context); 
    CGContextFillPath(context); 
    
    CGContextAddArc(context, 15*gridlen+offset, 15*gridlen+offset, r, 0, M_PI*2, 0);
    CGContextClosePath(context); 
    CGContextFillPath(context); 
}

- (void)showPoints:(CGContextRef)context
{
    CGFloat r = gridlen/2;//-1;
    
    int i, j;
    for (i = 0; i < LINE_NUM; i++) {
        for (j = 0; j < LINE_NUM; j++) {
            if (trueBoard[i][j] == 1) {
                CGContextSetFillColor(context, CGColorGetComponents( [[UIColor colorWithRed:0 green:0 blue:0 alpha:1 ] CGColor]));    
                CGContextAddArc(context, i*gridlen+offset, j*gridlen+offset, r, 0, M_PI*2, 0);
                CGContextClosePath(context); 
                CGContextFillPath(context);
            } else if (trueBoard[i][j] == 2) {
                CGContextSetFillColor(context, CGColorGetComponents( [[UIColor colorWithRed:255 green:255 blue:255 alpha:1 ] CGColor]));    
                CGContextAddArc(context, i*gridlen+offset, j*gridlen+offset, r, 0, M_PI*2, 0);
                CGContextClosePath(context); 
                CGContextFillPath(context);
            }
        }
    }
    
}

//********************************************************************
- (BOOL)haveAirX:(int)x Y:(int)y
{
    printf("Air %d %d\n", x,y);
    if (x > 0 && x < LINE_NUM-1 && y > 0 && y < LINE_NUM-1) { //非边角
        if (trueBoard[x+1][y] != 0 &&
            trueBoard[x-1][y] != 0 &&
            trueBoard[x][y+1] != 0 &&
            trueBoard[x][y-1] != 0 ) {
            return false;
        } else {
            return true;
        }
    } else if (x == 0 && y > 0 && y < LINE_NUM-1) { //边 x == 0
        if (trueBoard[x+1][y] != 0 &&
            trueBoard[x][y+1] != 0 &&
            trueBoard[x][y-1] != 0 ) {
            return false;
        } else {
            return true;
        }
    } else if (x == LINE_NUM-1 && y > 0 && y < LINE_NUM-1) { // x == LINE_NUM-1
        if (trueBoard[x-1][y] != 0 &&
            trueBoard[x][y+1] != 0 &&
            trueBoard[x][y-1] != 0 ) {
            return false;
        } else {
            return true;
        }
    } else if (y == 0 && x > 0 && x < LINE_NUM-1) { // y == 0
        if (trueBoard[x][y+1] != 0 &&
            trueBoard[x+1][y] != 0 &&
            trueBoard[x-1][y] != 0 ) {
            return false;
        } else {
            return true;
        }
    } else if (y == LINE_NUM-1 && x > 0 && x < LINE_NUM-1) { // y == LINE_NUM-1
        if (trueBoard[x][y-1] != 0 &&
            trueBoard[x+1][y] != 0 &&
            trueBoard[x-1][y] != 0 ) {
            return false;
        } else {
            return true;
        }
    } else if (x == 0 && y == 0) { //角 0 0
        if (trueBoard[x][y+1] != 0 &&
            trueBoard[x+1][y] != 0 ) {
            return false;
        } else {
            return true;
        }
    } else if (x == 0 && y == LINE_NUM-1) { //角 0 LINE_NUM-1
        if (trueBoard[x][y-1] != 0 &&
            trueBoard[x+1][y] != 0 ) {
            return false;
        } else {
            return true;
        }
    } else if (x == LINE_NUM-1 && y == 0) { //角 LINE_NUM-1 0
        if (trueBoard[x][y+1] != 0 &&
            trueBoard[x-1][y] != 0 ) {
            printf("false---\n");
            return false;
        } else {
            printf("true---\n");
            return true;
        }
    } else if (x == LINE_NUM-1 && y == LINE_NUM-1) { //角 LINE_NUM-1 0
        if (trueBoard[x][y-1] != 0 &&
            trueBoard[x-1][y] != 0 ) {
            return false;
        } else {
            return true;
        }
    }
    printf("haveAir: should not be there!!\n");
    return true;
}
- (BOOL)haveMyPeopleX:(int)x Y:(int)y Color:(int)color//color是将落子的颜色
{
    if (x > 0 && x < LINE_NUM-1 && y > 0 && y < LINE_NUM-1) { //非边角
        if (trueBoard[x+1][y] == color ||
            trueBoard[x-1][y] == color ||
            trueBoard[x][y+1] == color ||
            trueBoard[x][y-1] == color) {
            printf("my peoplr\n");
            return true;
        }
    } else if (x == 0 && y > 0 && y < LINE_NUM-1) { //边 x == 0
        if (trueBoard[x+1][y] == color ||
            trueBoard[x][y+1] == color ||
            trueBoard[x][y-1] == color ) {
            return true;
        }
    } else if (x == LINE_NUM-1 && y > 0 && y < LINE_NUM-1) { // x == LINE_NUM-1
        if (trueBoard[x-1][y] == color ||
            trueBoard[x][y+1] == color ||
            trueBoard[x][y-1] == color ) {
            return true;
        }
    } else if (y == 0 && x > 0 && x < LINE_NUM-1) { // y == 0
        if (trueBoard[x][y+1] == color ||
            trueBoard[x+1][y] == color ||
            trueBoard[x-1][y] == color ) {
            return true;
        }
    } else if (y == LINE_NUM-1 && x > 0 && x < LINE_NUM-1) { // y == LINE_NUM-1
        if (trueBoard[x][y-1] == color ||
            trueBoard[x+1][y] == color ||
            trueBoard[x-1][y] == color ) {
            return true;
        }
    } else if (x == 0 && y == 0) { //角 0 0
        if (trueBoard[x][y+1] == color ||
            trueBoard[x+1][y] == color ) {
            return true;
        }
    } else if (x == 0 && y == LINE_NUM-1) { //角 0 LINE_NUM-1
        if (trueBoard[x][y-1] == color ||
            trueBoard[x+1][y] == color ) {
            return true;
        }
    } else if (x == LINE_NUM-1 && y == 0) { //角 LINE_NUM-1 0
        if (trueBoard[x][y+1] == color ||
            trueBoard[x-1][y] == color ) {
            return true;
        }
    } else if (x == LINE_NUM-1 && y == LINE_NUM-1) { //角 LINE_NUM-1 0
        if (trueBoard[x][y-1] == color ||
            trueBoard[x-1][y] == color ) {
            return true;
        }
    }

    printf("my not peoplr\n");
    return false;
}
- (void)makeShadow
{
    int i, j;
    for (i = 0; i < LINE_NUM; i++) {
        for (j = 0; j < LINE_NUM; j++) {
            shadowBoard[i][j] = trueBoard[i][j];
        }
    }
}
- (void)floodFillX:(int)x Y:(int)y Color:(int)color
{
    if (x < 0 || x > LINE_NUM-1 || y < 0 || y > LINE_NUM-1) {
        return;
    }
    int antiColor = 2;
    if (color == 2)
        antiColor = 1;
    if (shadowBoard[x][y] != antiColor && shadowBoard[x][y] != 7) {
        shadowBoard[x][y] = 7; //已被填充
        [self floodFillX:x+1 Y:y Color:color];
        [self floodFillX:x-1 Y:y Color:color];
        [self floodFillX:x Y:y+1 Color:color];
        [self floodFillX:x Y:y-1 Color:color];
    }
}
- (BOOL)fillBlockHaveAirX:(int)x Y:(int)y Color:(int)color
{
    int i, j;
    for (i = 0; i < LINE_NUM; i++) {
        for (j = 0; j < LINE_NUM; j++) {
            if (i != x && j != y) {
                if (shadowBoard[i][j] == 7 && trueBoard[i][j] != color) {
                    return true;
                }
            }
        }
    }
    return false;
}
- (BOOL)antiFillBlockHaveAir:(int)color
{
    int i, j;
    for (i = 0; i < LINE_NUM; i++) {
        for (j = 0; j < LINE_NUM; j++) {
            if (shadowBoard[i][j] == 7 && trueBoard[i][j] != color) {
                return true;
            }
        }
    }
    return false;
}
- (void)pushIn:(NSMutableArray*)deadBody X:(int)x Y:(int)y
{
    NSNumber *n1 = [[NSNumber alloc] initWithInt:x];
    NSNumber *n2 = [[NSNumber alloc] initWithInt:y];
    NSArray *p1 = [NSArray arrayWithObjects:n1, n2, nil];
    [deadBody addObject:p1];
}
- (void)pushIn:(NSMutableArray*)jie_ X:(int)x Y:(int)y MoveCount:(int)moveCount
{
    NSNumber *n1 = [[NSNumber alloc] initWithInt:x];
    NSNumber *n2 = [[NSNumber alloc] initWithInt:y];
    NSNumber *n3 = [[NSNumber alloc] initWithInt:moveCount];
    NSArray *p1 = [NSArray arrayWithObjects:n1, n2, n3, nil];
    [jie_ addObject:p1];
}
- (BOOL)recordDeadBody:(NSMutableArray *)deadBody
{
    BOOL ret = false;
    int i, j;
    for (i = 0; i < LINE_NUM; i++) {
        for (j = 0; j < LINE_NUM; j++) {
            if (shadowBoard[i][j] == 7) {
                [self pushIn:deadBody X:i Y:j];
                printf("dead %d,%d\n", i ,j);
                ret = true;
            }
        }
    }
    return ret;
}
- (BOOL)canEatX:(int)x Y:(int)y Color:(int)color DeadBody:(NSMutableArray *)deadBody
{
    BOOL ret = false;
    int antiColor = 2;
    if (color == 2) {
        antiColor = 1;
    }
    
    if (x+1 <= LINE_NUM-1 && trueBoard[x+1][y] == antiColor) {
        [self makeShadow];
        shadowBoard[x][y] = color;
        [self floodFillX:x+1 Y:y Color:antiColor];
        if (![self antiFillBlockHaveAir:antiColor]) {
            BOOL rret = [self recordDeadBody:deadBody];
            ret = ret || rret;
        }
    }
    if (x-1 >= 0 && trueBoard[x-1][y] == antiColor) {
        [self makeShadow];
        shadowBoard[x][y] = color;
        [self floodFillX:x-1 Y:y Color:antiColor];
        if (![self antiFillBlockHaveAir:antiColor]) {
            BOOL rret = [self recordDeadBody:deadBody];
            ret = ret || rret;
        }
    }
    if (y+1 <= LINE_NUM-1 && trueBoard[x][y+1] == antiColor) {
        [self makeShadow];
        shadowBoard[x][y] = color;
        [self floodFillX:x Y:y+1 Color:antiColor];
        if (![self antiFillBlockHaveAir:antiColor]) {
            BOOL rret = [self recordDeadBody:deadBody];
            ret = ret || rret;
        }
    }
    if (y-1 >= 0 && trueBoard[x][y-1] == antiColor) {
        [self makeShadow];
        shadowBoard[x][y] = color;
        [self floodFillX:x Y:y-1 Color:antiColor];
        if (![self antiFillBlockHaveAir:antiColor]) {
            BOOL rret = [self recordDeadBody:deadBody];
            ret = ret || rret;
        }
    }
    
    return ret;
}
- (void)cleanDeadBody:(NSMutableArray *)deadBody
{
    int x, y;
    for (NSArray* obj in deadBody) {
        x = [[obj objectAtIndex:0] intValue];
        y = [[obj objectAtIndex:1] intValue];
        trueBoard[x][y] = 0;
    }
}
- (BOOL)isJieX:(int)x Y:(int)y DeadBody:(NSMutableArray *)deadBody
{
    if ([deadBody count] == 1) {
        for (NSArray* obj in jie) {
            if ([[obj objectAtIndex:0] intValue] == [[[deadBody objectAtIndex:0] objectAtIndex:0] intValue] &&
                [[obj objectAtIndex:1] intValue] == [[[deadBody objectAtIndex:0] objectAtIndex:1] intValue] &&
                [[obj objectAtIndex:2] intValue] == movecount) {
                // TODO 通知用户，弹个窗口什么的，或者写个Label
                return true;
            } else {

            }
        }
        [self pushIn:jie X:x Y:y MoveCount:(movecount+1)];
        return false;
    }

    return false;
}
- (void)playinX:(int)x Y:(int)y // 落子的算法
{
    if (x < 0 || x > LINE_NUM || y < 0 || y > LINE_NUM) {
        return; //TODO
    }
    if (trueBoard[x][y] != 0) {
        return; //TODO 此处已有棋子
    }
    BOOL canDown = false;
    int color = 2;
    if (movecount % 2 == 0) { //未落子之前是白
        color = 1; //那就该黑了
    }
    if (![self haveAirX:x Y:y]) {
        if ([self haveMyPeopleX:x Y:y Color:color]) {
            [self makeShadow];
            [self floodFillX:x Y:y Color:color];
            if ([self fillBlockHaveAirX:x Y:y Color:color]) {
                canDown = true;
                NSMutableArray *deadBody = [NSMutableArray arrayWithCapacity:0];
                [self canEatX:x Y:y Color:color DeadBody:deadBody];
                [self cleanDeadBody:deadBody];
            } else {
                NSMutableArray *deadBody = [NSMutableArray arrayWithCapacity:0];
                BOOL cret = [self canEatX:x Y:y Color:color DeadBody:deadBody];
                [self cleanDeadBody:deadBody];
                
                if (cret)
                    canDown = true;
                else
                    printf("无气，不能落子！"); //TODO 通知机制要改哦
            }
        } else {
            NSMutableArray *deadBody = [NSMutableArray arrayWithCapacity:0];
            BOOL cret = [self canEatX:x Y:y Color:color DeadBody:deadBody];
            if (cret) {
                if (![self isJieX:x Y:y DeadBody:deadBody]) {
                    [self cleanDeadBody:deadBody];
                    canDown = true;
                } else {
                    // TODO 通知
                }
            }
        }
        
    } else {
        canDown = true;
        NSMutableArray *deadBody = [NSMutableArray arrayWithCapacity:0];
        [self canEatX:x Y:y Color:color DeadBody:deadBody];
        [self cleanDeadBody:deadBody];
    }
    
    if (canDown) {
        if (movecount % 2 == 0) {
            trueBoard[x][y] = 1;
        } else {
            trueBoard[x][y] = 2;
        }
        movecount++;
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self grid:context];
    [self ninePoints:context];
    [self showPoints:context];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //UITouch *t = [touches anyObject];
    //touch = [t locationInView:self];
    //[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event //只在触摸结束时处理，开始和中间暂时不用
{
    UITouch *t = [touches anyObject];
    touch = [t locationInView:self];
    
    CGFloat x = touch.x;
    CGFloat y = touch.y;
    int i;
    int xok, yok;
    int theX, theY;
    for (i = 0; i < LINE_NUM; i++) {
        if (x > i*gridlen+offset-gridlen/2 && x < i*gridlen+offset+gridlen/2) {
            touchX = i*gridlen+offset;
            xok = 1;
            theX = i;
        }
        if (y > i*gridlen+offset-gridlen/2 && y < i*gridlen+offset+gridlen/2) {
            touchY = i*gridlen+offset;
            yok = 1;
            theY = i;
        }
    }
    if (xok && yok) {
        [self playinX:theX Y:theY];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //UITouch *t = [touches anyObject];
    //touch = [t locationInView:self];
    //[self setNeedsDisplay];
}

@end
