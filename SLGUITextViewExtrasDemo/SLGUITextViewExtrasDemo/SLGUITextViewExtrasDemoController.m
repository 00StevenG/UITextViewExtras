//
//  SLGViewController.m
//  SLGUITextViewExtrasDemo
//
//  Created by Steven Grace on 8/7/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import "SLGUITextViewExtrasDemoController.h"
#import "UITextView+Extras.h"

@interface SLGUITextViewExtrasDemoController () <UITextViewDelegate>

@end

@implementation SLGUITextViewExtrasDemoController{
    
    UIView* _selectionView;
}
#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [UIView animateWithDuration:.35
                     animations:^{
                         _selectionView.frame = CGRectZero;
                     }];
}
#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    _textView.editable = NO;
    _textView.delegate = self;
   
    
    _textView.attributedText = [[NSAttributedString alloc]initWithString:@"Donec placerat. Nullam nibh dolor, blandit sed, fermentum id, imperdiet sit amet, neque. Nam mollis ultrices justo. Sed tempor. Sed vitae tellus. Etiam sem arcu, eleifend sit amet, gravida eget, porta at, wisi. Nam non lacus vitae ipsum viverra pretium. Phasellus massa. Fusce magna sem, gravida in, feugiat ac, molestie eget, wisi. Fusce consectetuer luctus ipsum. Vestibulum nunc. Suspendisse dignissim adipiscing libero. Integer leo. Sed pharetra ligula a dui. Quisque ipsum nibh, ullamcorper eget, pulvinar sed, posuere vitae, nulla. Sed varius nibh ut lacus. Curabitur fringilla. Nunc est ipsum, pretium quis, dapibus sed, varius non, lectus. Proin a quam. Praesent lacinia, eros quis aliquam porttitor, urna lacus volutpat urna, ut fermentum neque mi egestas dolor.\n Donec placerat. Nullam nibh dolor, blandit sed, fermentum id, imperdiet sit amet, neque. Nam mollis ultrices justo. Sed tempor. Sed vitae tellus. Etiam sem arcu, eleifend sit amet, gravida eget, porta at, wisi. Nam non lacus vitae ipsum viverra pretium. Phasellus massa. Fusce magna sem, gravida in, feugiat ac, molestie eget, wisi. Fusce consectetuer luctus ipsum. Vestibulum nunc. Suspendisse dignissim adipiscing libero. Integer leo. Sed pharetra ligula a dui. Quisque ipsum nibh, ullamcorper eget, pulvinar sed, posuere vitae, nulla. Sed varius nibh ut lacus. Curabitur fringilla. Nunc est ipsum, pretium quis, dapibus sed, varius non, lectus. Proin a quam. Praesent lacinia, eros quis aliquam porttitor, urna lacus volutpat urna, ut fermentum neque mi egestas dolor.\n Donec placerat. Nullam nibh dolor, blandit sed, fermentum id, imperdiet sit amet, neque. Nam mollis ultrices justo. Sed tempor. Sed vitae tellus. Etiam sem arcu, eleifend sit amet, gravida eget, porta at, wisi. Nam non lacus vitae ipsum viverra pretium. Phasellus massa. Fusce magna sem, gravida in, feugiat ac, molestie eget, wisi. Fusce consectetuer luctus ipsum. Vestibulum nunc. Suspendisse dignissim adipiscing libero. Integer leo. Sed pharetra ligula a dui. Quisque ipsum nibh, ullamcorper eget, pulvinar sed, posuere vitae, nulla. Sed varius nibh ut lacus. Curabitur fringilla. Nunc est ipsum, pretium quis, dapibus sed, varius non, lectus. Proin a quam. Praesent lacinia, eros quis aliquam porttitor, urna lacus volutpat urna, ut fermentum neque mi egestas dolor. \n Donec placerat. Nullam nibh dolor, blandit sed, fermentum id, imperdiet sit amet, neque. Nam mollis ultrices justo. Sed tempor. Sed vitae tellus. Etiam sem arcu, eleifend sit amet, gravida eget, porta at, wisi. Nam non lacus vitae ipsum viverra pretium. Phasellus massa. Fusce magna sem, gravida in, feugiat ac, molestie eget, wisi. Fusce consectetuer luctus ipsum. Vestibulum nunc. Suspendisse dignissim adipiscing libero. Integer leo. Sed pharetra ligula a dui. Quisque ipsum nibh, ullamcorper eget, pulvinar sed, posuere vitae, nulla. Sed varius nibh ut lacus. Curabitur fringilla. Nunc est ipsum, pretium quis, dapibus sed, varius non, lectus. Proin a quam. Praesent lacinia, eros quis aliquam porttitor, urna lacus volutpat urna, ut fermentum neque mi egestas dolor."];
    
    
    _selectionView = [[UIView alloc]initWithFrame:CGRectZero];
    _selectionView.layer.borderColor = [UIColor blueColor].CGColor;
    _selectionView.layer.borderWidth = 2;
    _selectionView.layer.cornerRadius = 3;
    
    [self.view addSubview:_selectionView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_handleTap:)];
    
    [self.view addGestureRecognizer:tap];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Gesture Handling

-(void)_handleTap:(UITapGestureRecognizer*)tap{
    
    if(tap.state == UIGestureRecognizerStateRecognized){
        
        CGPoint tappedPoint = [tap locationInView:_textView];
        
        NSUInteger idx = [_textView closestCharacterIndexToPoint:tappedPoint];
        
        UITextGranularity granularity =_granularityControl.selectedSegmentIndex;
        
    
        UIBezierPath* selectionPathInTextView = [_textView selectionPathWithGranularity:granularity atIndex:idx];
        
            [UIView animateWithDuration:.35
                             animations:^{

            CGRect newFrame =
            CGPathGetPathBoundingBox(selectionPathInTextView.CGPath);

             _selectionView.frame = [self.view convertRect:newFrame fromView:_textView];
                                 
                                
        }];
        
    }
    
}

@end
