//
//  UITextView+Extras.m
//  RichText
//
//  Created by Steven Grace on 2/7/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import "UITextView+Extras.h"

#pragma mark - path creation (Internal)


@implementation UITextView (Extras)


#pragma mark - Class Methods
//
// returns the 'blue' selection colors used by UIKIT for selection
//
+(UIColor*)defaultSelectionColor{
    return [UIColor colorWithRed:0.788 green:0.867 blue:0.937 alpha:.75];
}
#pragma mark - Path Creation (Internal)
//
// Assembles a beizier path by adding each CGRect in selectionRects
//
-(UIBezierPath*)_bezierPathWithTextSelectionRects:(NSArray*)selectionRects{
    
    
    if([selectionRects count]==0)
        return nil;

    CGMutablePathRef mPath = CGPathCreateMutable();
    
    for(UITextSelectionRect* selectionRect in selectionRects){
        
        CGRect aRect = selectionRect.rect;
        CGPathAddRect(mPath,NULL,aRect);
    }
    
    CGPathCloseSubpath(mPath);
    
    UIBezierPath* bPath = [UIBezierPath bezierPathWithCGPath:mPath];
    CGPathRelease(mPath);
    return bPath;
    
}
#pragma mark - Selection Paths
//
// find the closest text position-> enclosing range and then calculate the enclosing path
//
-(UIBezierPath*)selectionPathWithGranularity:(UITextGranularity)granularity atPoint:(CGPoint)pt{
    
    UITextPosition* pos = [self closestPositionToPoint:pt];
    id<UITextInputTokenizer> tokenizer =self.tokenizer;
    UITextRange* textRange =
    [tokenizer rangeEnclosingPosition:pos
                      withGranularity:granularity
                          inDirection:UITextWritingDirectionLeftToRight];
    
    
    NSArray* rects = [self selectionRectsForRange:textRange];
    return [self _bezierPathWithTextSelectionRects:rects];
    
}
//
// find the position given an index from the beginngin of the doc and then calculate enclosing range
//
-(UIBezierPath*)selectionPathWithGranularity:(UITextGranularity)granularity atIndex:(NSUInteger)idx{
  
    UITextPosition* pos = [self positionFromPosition:self.beginningOfDocument
                                              offset:idx];
    
    
    // the passed index is <0 or greater than the length
    if(!pos)
        return nil;
    
    
    id<UITextInputTokenizer> tokenizer =self.tokenizer;
    UITextRange* textRange =
    [tokenizer rangeEnclosingPosition:pos
                      withGranularity:granularity
                          inDirection:UITextWritingDirectionLeftToRight];
    
    NSArray* rects = [self selectionRectsForRange:textRange];
    return [self _bezierPathWithTextSelectionRects:rects];
    
}
#pragma mark - Path for Range
//
// Grab the selection rects and assemble a paht
//
-(UIBezierPath*)pathForRange:(NSRange)range{
    
    NSArray* rects = [self textSelectionRectsForRange:range];
    return [self _bezierPathWithTextSelectionRects:rects];
}
//
// Calculate the path and its bounding rect
//
-(CGRect)boundingRectForRange:(NSRange)range{
    
    UIBezierPath* bPath = [self pathForRange:range];
    return CGPathGetBoundingBox(bPath.CGPath);
}
#pragma mark - Caret Rects
//
// Find position from the beginning of Doc calculate the caret rect
//
-(CGRect)caretRectForStringIndex:(NSUInteger)idx{
    
    UITextPosition* startPos = [self positionFromPosition:self.beginningOfDocument
                                              inDirection:UITextStorageDirectionForward
                                                   offset:idx];
    
    // the passed index is <0 or greater than the length
    if(!startPos)
        return CGRectNull;
    
    
    return [self caretRectForPosition:startPos];
    
}
//
// Find the position at point and returns its care rect
//
-(CGRect)caretRectClosestToPoint:(CGPoint)pt{
    
    UITextPosition* pos = [self closestPositionToPoint:pt];
    return [self caretRectForPosition:pos];
    
}
#pragma mark - Substrings
//
//  Find the position at the point and the range for that position it's substring range
//
-(NSString*)substringWithGranularity:(UITextGranularity)granularity atPoint:(CGPoint)pt{
    
    UITextPosition* pos = [self closestPositionToPoint:pt];
    id<UITextInputTokenizer> tokenizer =self.tokenizer;
    
    
    // may return nil if the given granularity is not found at this position
    UITextRange* textRange =
    [tokenizer rangeEnclosingPosition:pos
                      withGranularity:granularity
                          inDirection:UITextWritingDirectionLeftToRight];
    
    if(textRange)
        return [self textInRange:textRange];
    
    return nil;
    
}
//
// Find position and it's offset from the beginning of the document
//
-(NSUInteger)closestCharacterIndexToPoint:(CGPoint)pt{
    
    UITextPosition* pos = [self closestPositionToPoint:pt];
    NSUInteger idx = [self offsetFromPosition:self.beginningOfDocument
                                   toPosition:pos];
    
    
    return idx;
}
#pragma mark - Hit Testing
//
// Iterate through the selection rect for the passed range and text against rect containment
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
// convert range to positions -> text Range
//
-(UITextRange*)textRangeForRange:(NSRange)range{
    
    // TODO: test add checks for valid range within in document
    
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
// Calculate the location and length -> create NSRange
//
-(NSRange)rangeForTextRange:(UITextRange*)textRange{
    
    NSUInteger location =[self offsetFromPosition:self.beginningOfDocument
                                       toPosition:textRange.start];
    
    NSUInteger length = [self offsetFromPosition:textRange.start toPosition:textRange.end];
    return NSMakeRange(location,length);
}
//
// Convert the textRange (above) and calculate the selection rects
//
-(NSArray*)textSelectionRectsForRange:(NSRange)range{
    
    UITextRange* textRange = [self textRangeForRange:range];
    NSArray* rects = [self selectionRectsForRange:textRange];
    return rects;
}
//
// Calculate the positions using the origin of the passed rect
// and 'lower right corner of the rect -> create a NSRange from the result
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
// Calculate the position and enclosing textRange -> conver the UITextRange to NSRange
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
// Calculate the postion at the passed Index, positions and their textRange
// convert to an NSRange
//
-(NSRange)nextRangeWithGranularity:(UITextGranularity)granularity
                         fromIndex:(NSUInteger)idx
                       inDirection:(UITextStorageDirection)direction{
    
    UITextPosition* pos = [self positionFromPosition:self.beginningOfDocument
                                              offset:idx];
    
    // the passed index is <0 or greater than the length
    if(!pos)
        return NSMakeRange(0,0);
    
    
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
