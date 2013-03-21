//
//  UITextView+Extras.h
//  RichText
//
//  Created by Steven Grace on 2/7/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//
//  UITextView catagories assume 
//  :UITextStorageDirectionForward
//  :UITextWritingDirectionLeftToRight
//
//

#import <UIKit/UIKit.h>


@interface UITextView (Extras)

// the selection color used by UIKit for text selection
+(UIColor*)defaultSelectionColor;

// NSRange and UITextRange conversion
-(UITextRange*)textRangeForRange:(NSRange)range;
-(NSRange)rangeForTextRange:(UITextRange*)textRange;
// returns an array of text UITextSelectionRects for an given range
-(NSArray*)textSelectionRectsForRange:(NSRange)range;

// the following methods return paths (via CGPath Mutation Methods) assembled from UITextSelectionRects
-(CGPathRef)selectionPathWithGranularity:(UITextGranularity)granularity atPoint:(CGPoint)pt;
-(CGPathRef)selectionPathWithGranularity:(UITextGranularity)granularity atIndex:(NSUInteger)idx;
-(CGPathRef)pathForRange:(NSRange)range;

// caret rects
-(CGRect)caretRectForStringIndex:(NSUInteger)idx;
-(CGRect)caretRectClosestToPoint:(CGPoint)pt;

// returns the stirng index
-(NSUInteger)closestCharacterPositionToPoint:(CGPoint)pt;

// hit testing using the array of UITextSelectionRects
-(BOOL)pointInside:(CGPoint)point inRange:(NSRange)range;

// returns a substring with passed granularity or nil if not found at the point
-(NSString*)substringWithGranularity:(UITextGranularity)granularity atPoint:(CGPoint)pt;

// returns the range in the string at a given point or zero length range if not found
-(NSRange)rangeWithGranularity:(UITextGranularity)granularity atPoint:(CGPoint)pt;

// returns the range bound by a given CGRect
// cauculated using the caret positions and CGrectGetMax x/y functions
-(NSRange)rangeOfSubstringRangeBoundByRect:(CGRect)rect;

// returns the substring range for a given granularity
// from a given index 'searching' direction
-(NSRange)nextRangeWithGranularity:(UITextGranularity)granularity
                         fromIndex:(NSUInteger)idx
                       inDirection:(UITextStorageDirection)direction;

@end
