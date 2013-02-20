#import <UIKit/UIKit.h>

@interface Graphics : NSObject {
    CGContextRef _context;
    UIFont* _font;
}

- (void)setContext:(CGContextRef)context;
- (void)releaseContext;

- (void)setColor_r:(float)r g:(float)g b:(float)b a:(float)a;
- (void)setColor_r:(float)r g:(float)g b:(float)b;
- (void)setFont:(UIFont*)font;
- (void)setLineWith:(float)lineWidth;
- (int)stringWidth:(NSString*)str;
- (void)setTranslate_x:(float)x y:(float)y;
- (void)setScale_w:(float)w h:(float)h;

- (void)drawLine_x0:(float)x9 y0:(float)y0 x1:(float)x1 y1:(float)y1;
- (void)drawRect_x:(float)x y:(float)y w:(float)w h:(float)h;
- (void)fillRect_x:(float)x y:(float)y w:(float)w h:(float)h;
- (void)drawImage:(UIImage*)image x:(float)x y:(float)y;
- (void)drawImage:(UIImage*)image x:(float)x y:(float)y w:(float)w h:(float)h;
- (void)drawImage:(UIImage*)image x:(float)x y:(float)y
               sx:(float)sx sy:(float)sy sw:(float)sw sh:(float)sh;
- (void)drawString:(NSString*)string x:(float)x y:(float)y;

@end
