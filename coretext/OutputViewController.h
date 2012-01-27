#import <UIKit/UIKit.h>

@class ColumnView;

@interface OutputViewController : UIViewController

- (id)initWithText:(NSString *)text;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet ColumnView *columnView;

@end
