//
//  UITextView+Extras.m
//  RichText
//
//  Created by Steven Grace on 2/7/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import "UITextView+Extras.h"
#import <objc/runtime.h>


#pragma mark - path creation (Internal)
//
// Creates path for a given array of UITextSelectionRects
//
CGPathRef _CGPathForSelectionRects(NSArray* rects){
    
    
    if([rects count]==0)
        return NULL;
    
    
    CGMutablePathRef mPath = CGPathCreateMutable();

    for(UITextSelectionRect* selectionRect in rects){
            
        CGRect aRect = selectionRect.rect;
        CGPathAddRect(mPath,NULL,aRect);
    }
    
    CGPathCloseSubpath(mPath);

    CGPathRef final =  CGPathCreateCopy(mPath);
    CGPathRelease(mPath);
    CFBridgingRetain(CFBridgingRelease(final));
    
    return final;
}

@implementation UITextView (Extras)

#pragma mark - Class Methods
//
// returns the 'blue' selection colors used by UIKIT for selection
//
+(UIColor*)defaultSelectionColor{
    return [UIColor colorWithRed:0.788 green:0.867 blue:0.937 alpha:.75];
}
#pragma mark - Selection Paths
//
//
//
-(CGPathRef)selectionPathWithGranularity:(UITextGranularity)granularity atPoint:(CGPoint)pt{
    
    UITextPosition* pos = [self closestPositionToPoint:pt];
    id<UITextInputTokenizer> tokenizer =self.tokenizer;
    UITextRange* textRange =
    [tokenizer rangeEnclosingPosition:pos
                      withGranularity:granularity
                          inDirection:UITextWritingDirectionLeftToRight];
    
    
    NSArray* rects = [self selectionRectsForRange:textRange];
    return _CGPathForSelectionRects(rects);
    
    
}
//
//
//
-(CGPathRef)selectionPathWithGranularity:(UITextGranularity)granularity atIndex:(NSUInteger)idx{
  
    UITextPosition* pos = [self positionFromPosition:self.beginningOfDocument
                                              offset:idx];
    
    id<UITextInputTokenizer> tokenizer =self.tokenizer;
    UITextRange* textRange =
    [tokenizer rangeEnclosingPosition:pos
                      withGranularity:granularity
                          inDirection:UITextWritingDirectionLeftToRight];
    
    NSArray* rects = [self selectionRectsForRange:textRange];
    return _CGPathForSelectionRects(rects);
    
}
#pragma mark - Path for Range
//
//
//
-(CGPathRef)pathForRange:(NSRange)range{
    
    NSArray* rects = [self textSelectionRectsForRange:range];
    return  _CGPathForSelectionRects(rects);
}
//
//
//
-(CGRect)caretRectForStringIndex:(NSUInteger)idx{
    
    UITextPosition* startPos = [self positionFromPosition:self.beginningOfDocument
                                              inDirection:UITextStorageDirectionForward
                                                   offset:idx];
    
    return [self caretRectForPosition:startPos];
    
}
//
//
//
-(CGRect)caretRectClosestToPoint:(CGPoint)pt{
    
    UITextPosition* pos = [self closestPositionToPoint:pt];
    return [self caretRectForPosition:pos];
    
}
#pragma mark - Substrings
//
//
//
-(NSString*)substringWithGranularity:(UITextGranularity)granularity atPoint:(CGPoint)pt{
    
    UITextPosition* pos = [self closestPositionToPoint:pt];
    id<UITextInputTokenizer> tokenizer =self.tokenizer;
    
    UITextRange* textRange =
    [tokenizer rangeEnclosingPosition:pos
                      withGranularity:granularity
                          inDirection:UITextWritingDirectionLeftToRight];
    
    if(textRange)
        return [self textInRange:textRange];
    
    return nil;
    
}
//
//
//
-(NSUInteger)closestCharacterPositionToPoint:(CGPoint)pt{
    
    UITextPosition* pos = [self closestPositionToPoint:pt];
    NSUInteger idx = [self offsetFromPosition:self.beginningOfDocument
                                   toPosition:pos];
    
    return idx;
}
#pragma mark - Hit Testing
//
//
//
-(BOOL)pointInside:(CGPoint)point inRange:(NSRange)range{
 
    NSArray* rects = [self textSelectionRectsForRange:range];
    for(UITextSelectionRect* selectionRect in rects){
        if(CGRectContainsPoint(selectionRect.rect,point)==YES)
            return YES;
    }
    return NO;
    
}
#pragma mark - NSRange and UITextRange Conversion
//
//
//
-(UITextRange*)textRangeForRange:(NSRange)range{
    
    
    UITextPosition* startPos = [self positionFromPosition:self.beginningOfDocument
                                              inDirection:UITextStorageDirectionForward
                                                   offset:range.location];
    
    UITextPosition* endPos = [self positionFromPosition:self.beginningOfDocument
                                            inDirection:UITextStorageDirectionForward
                                                 offset:(range.location+range.length)];
    
    UITextRange* textRange = [self textRangeFromPosition:startPos toPosition:endPos];
    return textRange;
}
//
//
//
-(NSRange)rangeForTextRange:(UITextRange*)textRange{
    
    NSUInteger location =[self offsetFromPosition:self.beginningOfDocument
                                       toPosition:textRange.start];
    
    NSUInteger length = [self offsetFromPosition:textRange.start toPosition:textRange.end];
    return NSMakeRange(location,length);
}
//
//
//
-(NSArray*)textSelectionRectsForRange:(NSRange)range{
    

    UITextRange* textRange = [self textRangeForRange:range];
    
    NSArray* rects = [self selectionRectsForRange:textRange];
    
    return rects;
    
}
//
//
//
-(NSRange)rangeOfSubstringRangeBoundByRect:(CGRect)rect{
    
    UITextPosition* start = [self closestPositionToPoint:rect.origin];
    UITextPosition* end =
    [self closestPositionToPoint:CGPointMake(CGRectGetMaxX(rect),CGRectGetMaxY(rect))];
    
    return NSMakeRange([self offsetFromPosition:self.beginningOfDocument toPosition:start],
                       [self offsetFromPosition:start toPosition:end]);
    
}
#pragma mark - Granularity
//
//
//
-(NSRange)rangeWithGranularity:(UITextGranularity)granularity atPoint:(CGPoint)pt{
    
    UITextPosition* pos = [self closestPositionToPoint:pt];
    id<UITextInputTokenizer> tokenizer =self.tokenizer;
    UITextRange* textRange =
    [tokenizer rangeEnclosingPosition:pos
                      withGranularity:granularity
                          inDirection:UITextWritingDirectionLeftToRight];
    
    if(textRange){
        return [self rangeForTextRange:textRange];
    }
    else{
        return NSMakeRange(0,0);
    }
}
//
// Private method to calculate the next UITextPosition from a given positiom
// and direction
//
-(UITextPosition*)_nextPositionWithGranularity:(UITextGranularity)granularity
                                  fromPosition:(UITextPosition*)pos
                                   inDirection:(UITextStorageDirection)direction{
    
    

    UITextPosition* nextPos = [self.tokenizer positionFromPosition:pos
                                                        toBoundary:granularity
                                                       inDirection:direction];
    
    BOOL result = [self.tokenizer isPosition:nextPos
                              withinTextUnit:granularity
                                 inDirection:direction];
    
    // loops through the tokenizer for the next position
    while (!result) {
        nextPos =
        [self.tokenizer positionFromPosition:nextPos
                                  toBoundary:granularity
                                 inDirection:direction];
        
        
        // is the position the granularity we want
        result = [self.tokenizer isPosition:nextPos
                             withinTextUnit:granularity
                                inDirection:direction];
        
        // TODO: confirm end and beginning of document behavior (ifinite loop)
    }
    return nextPos;
    
}
//
//
//
-(NSRange)nextRangeWithGranularity:(UITextGranularity)granularity
                         fromIndex:(NSUInteger)idx
                       inDirection:(UITextStorageDirection)direction{
    
    
    UITextPosition* pos = [self positionFromPosition:self.beginningOfDocument
                                              offset:idx];
    
    UITextPosition* fromPos = [self _nextPositionWithGranularity:granularity
                                                    fromPosition:pos
                                                     inDirection:direction];
        
    UITextPosition* toPos = [self.tokenizer positionFromPosition:fromPos
                                                    toBoundary:granularity
                                                   inDirection:direction];
    
    UITextRange* textRange = [self textRangeFromPosition:fromPos toPosition:toPos];
    
    return [self rangeForTextRange:textRange];
}



@end
