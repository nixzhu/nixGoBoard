//
//  GoBoard.h
//  nixGoBoard
//
//  Created by nixzhu on 12-7-1.
//  Copyright (c) 2012年 CandyStar. All rights reserved.
//  Email: zhuhongxu@gmail.com

#import <UIKit/UIKit.h>

#define LINE_NUM 19
@interface GoBoard : UIView {
    int trueBoard[LINE_NUM][LINE_NUM];
    int shadowBoard[LINE_NUM][LINE_NUM];
    CGPoint touch;
    CGFloat touchX;
    CGFloat touchY;
    int tX;
    int tY;
    BOOL touching;
    CGFloat gridlen;
    CGFloat offset;
    
    int movecount;
    NSMutableArray *jie;
}

@property CGPoint touch;
@property CGFloat touchX;
@property CGFloat touchY;
@property CGFloat gridlen;
@property CGFloat offset;
@property int movecount;

@end
