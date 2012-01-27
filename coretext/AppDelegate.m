#import "AppDelegate.h"
#import "OutputViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize textView = _textView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSBundle mainBundle] loadNibNamed:@"Window" owner:self options:nil];
    [self.window makeKeyAndVisible];
    return YES;
}

- (IBAction)showColumnView {
    OutputViewController *vc = [[OutputViewController alloc] initWithText:self.textView.text];
    [(UINavigationController *)self.window.rootViewController pushViewController:vc animated:YES];
}

@end
