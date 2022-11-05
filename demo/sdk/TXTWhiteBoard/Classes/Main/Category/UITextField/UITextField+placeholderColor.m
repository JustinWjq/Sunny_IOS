#import "UITextField+placeholderColor.h"
#import <objc/message.h>

 UIColor *_placeholderColor;

@implementation UITextField (placeholderColor)

- (void)setPlaceholder:(NSString *)placeholder color:(UIColor *)placeholderColor
{
    self.placeholder = placeholder;
    
    [self setPlaceholderColor:placeholderColor];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
     UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    
      placeholderLabel.textColor = placeholderColor;
 
     _placeholderColor = placeholderColor;
}

- (UIColor *)placeholderColor
{
    return _placeholderColor;
}

 @end
