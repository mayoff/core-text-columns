#import "OutputViewController.h"
#import "ColumnView.h"

@protocol RecursiveDescription <NSObject>
- (NSString *)recursiveDescription;
@end

@implementation OutputViewController {
    NSString *_text;
}

@synthesize scrollView = _scrollView;
@synthesize columnView = _columnView;

- (id)initWithText:(NSString *)text {
    if (!(self = [super initWithNibName:nil bundle:nil]))
        return nil;
        
    _text = [NSString stringWithString:text];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.columnView.text = _text;
    self.columnView.columnSize = self.view.bounds.size;
    self.columnView.columnPadding = CGSizeMake(10, 10);
    [self.columnView sizeToFit];
    self.scrollView.contentSize = self.columnView.frame.size;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidUnload {
    [self setColumnView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
