UITextViewExtras
================

These are some category methods I use in my  Gesture powered rich text editor (Fire Type). 

http://appstore.com/firetype


Mostly just digging around the UITextInputProtocol and UITextInputTokenizer.

From iOS 6 UITextView supports NSAttributedString (with some limitations).  NSAttributed deals primarily with NSRange. These methods primarily concerned with finding the coordinates of ranges, UITextRange  and NSRange conversion and simple hit testing. 

At this point this code assumes left to right writing direction. As noted in the header.
