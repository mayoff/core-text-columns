#import "ColumnView.h"

@implementation ColumnView {
    CFMutableArrayRef _columnFrames;
    CGRect _boundingBox;
}

@synthesize text = _text;
@synthesize columnSize = _columnSize;
@synthesize columnPadding = _columnPadding;

- (void)destroyColumns {
    if (_columnFrames) {
        CFRelease(_columnFrames);
        _columnFrames = NULL;
    }
}

- (void)dealloc {
    [self destroyColumns];
}

- (CGRect)borderRectForColumnIndex:(NSUInteger)columnIndex {
    return (CGRect){ CGPointMake(columnIndex * _columnSize.width, 0), _columnSize };
}

- (CGRect)contentRectForColumnIndex:(NSUInteger)columnIndex {
    return CGRectInset([self borderRectForColumnIndex:columnIndex], _columnPadding.width, _columnPadding.height);
}

- (void)layoutColumns {
    [self destroyColumns];
    
    CFAttributedStringRef trib = CFAttributedStringCreate(NULL, (__bridge CFStringRef)_text, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(trib);
    CFRelease(trib);
    
    _boundingBox = CGRectNull;
    _columnFrames = CFArrayCreateMutable(NULL, 0, &kCFTypeArrayCallBacks);
    NSUInteger columnIndex = 0;
    NSUInteger startIndex = 0;
    NSUInteger endIndex = _text.length;
    while (startIndex < endIndex) {
        _boundingBox = CGRectUnion(_boundingBox, [self borderRectForColumnIndex:columnIndex]);
        CGPathRef path = CGPathCreateWithRect([self contentRectForColumnIndex:columnIndex], NULL);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path, NULL);
        CGPathRelease(path);
        CFArrayAppendValue(_columnFrames, frame);
        ++columnIndex;
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        CFRelease(frame);
        if (frameRange.length == 0) {
            NSLog(@"error: column size is too small to fit character at index %u", startIndex);
            break;
        }
        startIndex += frameRange.length;
    }
    
    CFRelease(framesetter);
}

- (void)layoutColumnsIfNeeded {
    if (!_columnFrames)
        [self layoutColumns];
}

- (void)setText:(NSString *)text {
    _text = text ? [NSString stringWithString:text] : @"";
    [self destroyColumns];
}

- (void)setColumnSize:(CGSize)columnSize {
    _columnSize = columnSize;
    [self destroyColumns];
}

- (void)setColumnPadding:(CGSize)columnPadding {
    _columnPadding = columnPadding;
    [self destroyColumns];
}

- (CGSize)sizeThatFits:(CGSize)size {
    [self layoutColumnsIfNeeded];
    return _boundingBox.size;
}

- (void)drawRect:(CGRect)dirtyRect {
    NSLog(@"drawRect:%@", NSStringFromCGRect(dirtyRect));
    [self layoutColumnsIfNeeded];
    CGContextRef gc = UIGraphicsGetCurrentContext();
    CGContextSaveGState(gc); {
        // Flip the Y-axis of the context because that's what CoreText assumes.
        CGContextTranslateCTM(gc, 0, self.bounds.size.height);
        CGContextScaleCTM(gc, 1, -1);
        for (NSUInteger i = 0, l = CFArrayGetCount(_columnFrames); i < l; ++i) {
            CTFrameRef frame = CFArrayGetValueAtIndex(_columnFrames, i);
            CGPathRef path = CTFrameGetPath(frame);
            CGRect frameRect = CGPathGetBoundingBox(path);
            if (!CGRectIntersectsRect(frameRect, dirtyRect))
                continue;
            
            CTFrameDraw(frame, gc);
        }
    } CGContextRestoreGState(gc);
}

@end
