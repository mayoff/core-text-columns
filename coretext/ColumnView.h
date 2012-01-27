#import <UIKit/UIKit.h>

@interface ColumnView : UIView

@property (copy, nonatomic) NSString *text;
@property (nonatomic) CGSize columnSize;
@property (nonatomic) CGSize columnPadding;

@end
