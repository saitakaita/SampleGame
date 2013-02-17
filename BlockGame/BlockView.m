//
//  BlockView.m
//  BlockGame
//
//  Created by tomohiko on 2013/02/17.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "BlockView.h"

@implementation BlockView

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        int screenW = MIN(rect.size.width,rect.size.height);
        int screenH = MAX(rect.size.width,rect.size.height);
        _g = [[Graphics alloc] init];
        _gScale = screenW/360.0f;
        _gY = ((screenH/_gScale) - 640)/2;
        
        [self setTransform:CGAffineTransformMakeScale(_gScale,_gScale)];
        
        _screen = 0;
        _init = S_TITLE;
        _image = [[NSMutableArray array] return];
        for (int i=0; i<16; i++) {
            [_image addObject:[UIImage imageNamed:
                               [NSString stringWithFormat:@"pic%d.png", i]]];
        }
        _score = 0;
        
        _ballVX = 0;
        _ballY  = 0;
        _ballVX = 0;
        _ballVY = 0;
        
        _barX   = 180;
        _barY   = 515;
        
        [self onTick:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.05f
                                        target:self selector:@selector(onTick:)
                                        userInfo:nil repeats:YES];
    }
    return self;
}

- (void)dealloc {
    if (_init>=0) {
        if (_init==S_TITLE) {
            for (int i=0; i<8; i++) {
                _block[0][i]=5;
                _block[1][i]=5;
                _block[2][i]=4;;
                _block[3][i]=3;
                _block[4][i]=3;
                _block[5][i]=2;
                _block[6][i]=2;
                _block[7][i]=1;
                _block[8][i]=1;
                _block[9][i]=0;
                _block[10][i]=0;
                _block[11][i]=0;
            }
            //ここまで完了
        }
    }
}


@end








































































