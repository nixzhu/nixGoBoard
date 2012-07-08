//
//  GoBoard.h
//  nixGoBoard
//
//  Created by 宏旭 朱 on 12-7-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LINE_NUM 19
@interface GoBoard : UIView {
    int trueBoard[LINE_NUM][LINE_NUM];
    int shadowBoard[LINE_NUM][LINE_NUM];
    CGPoint touch;
    CGFloat touchX;
    CGFloat touchY;
    
    CGFloat gridlen;
    CGFloat offset;
    
    int movecount;
    NSMutableArray *jie;// = [NSMutableArray arrayWithCapacity:0];
}
//@property int** trueBoard;
@property CGPoint touch;
@property CGFloat touchX;
@property CGFloat touchY;
@property CGFloat gridlen;
@property CGFloat offset;
@property int movecount;
//@property NSMutableArray *jie;;
@end
