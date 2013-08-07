//
//  SLGViewController.h
//  SLGUITextViewExtrasDemo
//
//  Created by Steven Grace on 8/7/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLGUITextViewExtrasDemoController : UIViewController

@property(nonatomic,readwrite,assign)IBOutlet UITextView* textView;
@property(nonatomic,readwrite,assign)IBOutlet UISegmentedControl* granularityControl;

@end
