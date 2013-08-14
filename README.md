UITextViewExtras
================

Mostly just digging around the UITextInputProtocol and UITextInputTokenizer.

From iOS 6 UITextView supports NSAttributedString (with some limitations).  NSAttributedString deals primarily with NSRange. These methods primarily concerned with finding the coordinates of ranges, UITextRange  and NSRange conversion and simple hit testing. 

At this point this code assumes left to right writing direction. As noted in the header.

I've used theses methods in a couple my own apps...


http://appstore.com/firetype

http://appstore.com/dragpad
