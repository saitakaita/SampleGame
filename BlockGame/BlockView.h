#import <UIKit/UIKit.h>
#import "Graphics.h"

#define S_TITLE    0
#define S_PLAY     1
#define S_CLEAR    2
#define S_GAMEOVER 3

#define BLOCK_COL  8
#define BLOCK_ROW  12

@interface  BlockView : UIView {
    
    Graphics* _g;
    int       _gX;
    int       _gY;
    float     _gScale;
    
    int       _scene;
    int       _init;
    NSMutableArray* _image;
    int       _score;
    
    int _block[BLOCK_ROW][BLOCK_COL];
    
    int _ballX;
    int _ballY;
    int _ballVX;
    int _ballVY;
    
    int _barX;
    int _barY;
}

@end
