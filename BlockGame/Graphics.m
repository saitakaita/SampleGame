#import "Graphics.h"

@implementation Graphics

- (id)init {
    if (self=[super init]) {
        _context=NULL;
        _font=[UIFont boldSystemFontOfSize:12];
    }
    return self;
}

- (void)dealloc {
    [self releaseContext];
    [super dealloc];
}

- (void)setContext:(CGContextRef)context {
    [self releaseContext];
    
    _context = context;
    CGContextRetain(_context);
}

- (void)releaseContext {
    if (_context != NULL) {
        CGContextRelease(_context);
        _context = NULL;
        
    }
}

- (void)setColor_r:(float)r g:(float)g b:(float)b {
    CGContextSetRGBFillColor(_context, r, g, b, 1);
    CGContextSetRGBStrokeColor(_context, r, g, b, 1);
}

- (void)setColor_r:(float)r g:(float)g b:(float)b a:(float)a {
    CGContextSetRGBFillColor(_context, r, g, b, a);
    CGContextSetRGBStrokeColor(_context, r, g, b, a);
}

- (void)setFont:(UIFont *)font {
    _font = font;
}

- (void)setLineWith:(float)lineWidth {
    CGContextSetLineWidth(_context,lineWidth);
}

- (int)stringWidth:(NSString *)str {
    return [str sizeWithFont:_font].width;
}

- (void)setTranslate_x:(float)x y:(float)y {
    CGContextTranslateCTM(_context, x ,y);
}

- (void)setScale_w:(float)w h:(float)h {
    CGContextScaleCTM(_context, w, h);
}

- (void)drawLine_x0:(float)x0 y0:(float)y0 x1:(float)x1 y1:(float)y1 {
    CGContextSetLineCap(_context, kCGLineCapRound);
    CGContextMoveToPoint(_context, x0, y0);
    CGContextAddLineToPoint(_context, x1, y1);
    CGContextStrokePath(_context);
}
- (void)drawRect_x:(float)x y:(float)y w:(float)w h:(float)h {
    CGContextMoveToPoint(_context, x, y);
    CGContextAddLineToPoint(_context, x+w, y);
    CGContextAddLineToPoint(_context, x+w, y+h);
    CGContextAddLineToPoint(_context, x, y+h);
    CGContextAddLineToPoint(_context, x, y);
    CGContextAddLineToPoint(_context, x+w, y);
    CGContextStrokePath(_context);
}

- (void)fillRect_x:(float)x y:(float)y w:(float)w h:(float)h {
    CGContextFillEllipseInRect(_context, CGRectMake(x, y, w, h));
}

- (void)drawImage:(UIImage *)image x:(float)x y:(float)y {
    if (image==nil) return;
    [image drawAtPoint:(CGPointMake(x,y))];
}
- (void)drawImage:(UIImage *)image x:(float)x y:(float)y w:(float)w h:(float)h {
    if (image==nil) return;
    [image drawInRect:(CGRectMake(x, y, w, h))];
}

- (void)drawImage:(UIImage*)image x:(float)x y:(float)y
               sx:(float)sx sy:(float)sy sw:(float)sw sh:(float)sh {
    if (image==nil) return;
    CGContextSaveGState(_context);
    CGContextClipToRect(_context, CGRectMake(x, y, sw, sh));
    [image drawInRect:(CGRectMake(x-sx, y-sy, image.size.width, image.size.height))];
}
- (void)drawString:(NSString *)string x:(float)x y:(float)y {
    [string drawAtPoint:CGPointMake(x, y) withFont:_font];
}


@end









































