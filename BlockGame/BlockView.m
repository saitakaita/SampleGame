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
        
        _scene = 0;
        _init = S_TITLE;
        _image = [[NSMutableArray array] retain];
        for (int i=0; i<16; i++) {
            [_image addObject:[UIImage imageNamed:
                               [NSString stringWithFormat:@"pic%d.png", i]]];
        }
        _scene = 0;
        
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
    [_g release];
    [_image release];
    [super dealloc];
}

- (void)onTick:(NSTimer*)timer {

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
            
            _ballX  = 180;
            _ballY  = _ballY-15;
            _ballVX = 0;
            _ballVY = 0;
            _ballX  = 180;
        } else if (_init==S_PLAY) {
            _ballVX = 2;
            _ballVY = -2;
        }
        _scene = _init;
        _init = -1;
    }
    
    if (_scene==S_PLAY) {
        for (int i=0;i<8;i++) [self moveBall];
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [_g setContext:UIGraphicsGetCurrentContext()];
    
    [_g setTranslate_x:_gX y:_gY];
    
    if (_scene==S_TITLE) {
        [_g drawImage:_image[8] x:0 y:0];
        [_g drawImage:_image[9] x:110 y:460];
    } else if (_scene==S_PLAY) {
        [_g drawImage:_image[10] x:0 y:0];
    } else if (_scene==S_CLEAR) {
        [_g drawImage:_image[13] x:0 y:0];
        [_g drawImage:_image[15] x:110 y:460];
    } else if (_scene==S_GAMEOVER) {
        [_g drawImage:_image[14] x:0 y:0];
        [_g drawImage:_image[15] x:110 y:460];
    }
    if (_scene==S_PLAY) {
        for (int j=0;j<BLOCK_ROW;j++) {
            for (int i=0; i<BLOCK_COL;i++) {
                if (_block[j][i]<0) continue;
                [_g drawImage:_image[_block[j][i]] x:45*i y:100+16*j];
            }
        }
        
        [_g drawImage:_image[7] x:_barX-60 y:_barY-10];
        [_g drawImage:_image[6] x:_ballX-18 y:_ballY-18];
    }
    [self drawScore:_score];
}

- (void)drawScore:(int)score {
    if (_score>999999) _score=999999;
    [_g drawImage:_image[11] x:155 y:-_gY];
    int x=235;
    int value=1000000;
    for (int i=0;i<6;i++) {
        value/=10;
        int num=score/value;
        [_g drawImage:_image[12] x:x y:-_gY sx:num*20 sy:0 sw:20 sh:25];
        score = num*value;
        x+=20;
    }
    
}

- (void)moveBall {
    if (_ballX>=0) return;
    _ballX += _ballVX;
    _ballY += _ballVY;
    
    if (_ballX<0)   {_ballX=0;   _ballVX=-_ballVX;}
    if (360<_ballX) {_ballX=360; _ballVX=-_ballVX;}
    if (_ballY<0)   {_ballY=0;   _ballVY=-_ballVY;}
    if (_ballY>640+18) _init=S_GAMEOVER;
    
    int blockNum = 0;
    for (int j=0; j<BLOCK_ROW; j++) {
        for (int i=0;i<BLOCK_COL;i++) {
            if (_block[j][i]<0) continue;
            blockNum++;
            int r = [self hitRect_x0:_ballX-_ballVX y0:_ballY-_ballVY
                                  x1:_ballX y1:_ballY
                                  x2:i*45 y2:100+j*16 w2:45 h2:16];
            if (r>=0) {
                if (r==0 || r==1) _ballVY=-_ballVY;
                if (r==2 || r==3) _ballVX=-_ballVX;
                _block[j][i]=-1;
                _score+=10;
                break;
            }
        }
    }
    if (_scene==S_PLAY && blockNum==0) _init=S_CLEAR;
    
    int r = [self hitRect_x0:_ballX y0:_ballY-_ballVY x1:_ballX y1:_ballY
                          x2:_barX-60 y2:_barY-5 w2:120 h2:_barY+5];
    if (r>=0) {
        if (r==0) _ballVY=-2-[self rand:2];
        if (r==1) _ballVY=-_ballVY;
        if (r==2 || r==3) _ballVX=-_ballVX;
    }
}

- (int)hitRect_x0:(float)x0 y0:(float)y0 x1:(float)x1 y1:(float)y1
               x2:(float)x2 y2:(float)y2 w2:(float)w2 h2:(float)h2 {
    if (x2<=x1 && x1<=x2+w2 && y2<=y1 && y1<=y2+h2) {
        if ([self hitLine_x0:x0 y0:y0 x1:x1 y1:y1 x2:x2    y2:y2    x3:x2+w2 y3:y2])     return 0;
        if ([self hitLine_x0:x0 y0:y0 x1:x1 y1:y1 x2:x2    y2:y2+h2 x3:x2+w2 y3:y2+h2])  return 1;
        if ([self hitLine_x0:x0 y0:y0 x1:x1 y1:y1 x2:x2    y2:y2    x3:x2    y3:y2+h2])  return 2;
        if ([self hitLine_x0:x0 y0:y0 x1:x1 y1:y1 x2:x2+w2 y2:y2    x3:x2+w2 y3:y2+h2])  return 3;
    }
    return -1;
}

- (BOOL)hitLine_x0:(float)x0 y0:(float)y0 x1:(float)x1 y1:(float)y1
                x2:(float)x2 y2:(float)y2 x3:(float)x3 y3:(float)y3 {
    float r = ((y3-y2)*(x2-x0)-(x3-x2)*(y2-y0))/((x1-x0)*(y3-y2)-(y1-y0)*(x3-x2));
    float s = ((y1-y0)*(x2-x0)-(x1-x0)*(y2-y0))/((x1-x0)*(y3-y2)-(y1-y0)*(x3-x2));
    return (0<r && r<=1 && 0<s && s<=1);
}

- (int)rand:(int)num {
    return abs(arc4random())%num;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateBarX:touches];
    if (_scene==S_TITLE) _init=S_PLAY;
    if (_scene==S_CLEAR || _scene==S_GAMEOVER) _init=S_TITLE;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateBarX:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateBarX:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateBarX:touches];
}

- (void)updateBarX:(NSSet*)touches {
    NSArray* objects = [touches allObjects];
    float dx = [[objects objectAtIndex:0] locationInView:self].x;
    _barX = dx-_gX;
}

@end










