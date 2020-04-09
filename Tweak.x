/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/

@interface EDMGenericWebViewController: UIViewController
@property (strong) UIActivityIndicatorView * indicatorView;
// @property (strong) NSObject *attachment;
-(void)presentShareController:(NSArray *)items barItem:(UIBarButtonItem * _Nullable)barItem;
@end

%hook EDMGenericWebViewController

%property (strong) UIActivityIndicatorView * indicatorView;

%new 
-(void)downloadAction:(UIBarButtonItem *)sender {
    NSLog(@"EdmodoFixer: Downloading from url: %@", [[self performSelector:@selector(attachment)] performSelector:@selector(downloadURL)]);
    [self.indicatorView startAnimating];

    NSString *attachmentName = [[self performSelector:@selector(attachment)] performSelector:@selector(name)];
    NSURL *url = [[self performSelector:@selector(attachment)] performSelector:@selector(downloadURL)];

    NSString *tmpDir = NSTemporaryDirectory();
       NSString *localURL = [tmpDir stringByAppendingPathComponent:attachmentName]; 
       NSURL *urlToShare = [NSURL fileURLWithPath:localURL];
       
       if ([[NSFileManager defaultManager] fileExistsAtPath:localURL]) {
           [self presentShareController:@[urlToShare] barItem:sender];
           [self.indicatorView stopAnimating];
       } else {
           NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
               if (data && data.length > 0) {
                   NSLog(@"EdmodoFixer: Attachment downloaded successfully");
                   
                   BOOL isCreated = [[NSFileManager defaultManager] createFileAtPath:localURL contents:data attributes:nil];
                   if (isCreated) {
                       NSLog(@"EdmodoFixer: File created succesfully");
                       
                       NSArray *items = @[urlToShare];
                       
                       [self presentShareController:items barItem:sender];
                       
                   } else {
                       NSLog(@"EdmodoFixer: Error creating file from downloaded data");
                   }
                   
               } else {
                   NSLog(@"EdmodoFixer: Data downloaded == null ");
               }
               dispatch_async(dispatch_get_main_queue(), ^{
                   [self.indicatorView stopAnimating];
               });
               
           }];
           
           [dataTask resume];
       }

}

%new
-(void)presentShareController:(NSArray *)items barItem:(UIBarButtonItem * _Nullable)barItem {
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    if (barItem) {
        shareController.popoverPresentationController.barButtonItem = barItem;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:shareController animated:YES completion:nil];
    });
}


-(void)loadView {
    %orig();

    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.hidesWhenStopped = YES;
    self.indicatorView.frame = CGRectMake(0,0, 30, 30);
    self.indicatorView.color = [UIColor orangeColor];
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview: self.indicatorView];

    [self performSelector:@selector(setConstraints)];
}

%new
-(void)setConstraints {
    [[self.indicatorView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    [[self.indicatorView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
    [[self.indicatorView.heightAnchor constraintEqualToConstant:20] setActive:YES];
    [[self.indicatorView.widthAnchor constraintEqualToConstant:20] setActive:YES];
}

-(void)viewWillAppear:(bool)arg2 {
    %orig(arg2);

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Download" style: UIBarButtonItemStylePlain target:self action:@selector(downloadAction:)];
    NSArray *currentItems = [self.navigationItem rightBarButtonItems];
    NSArray *newItems = [currentItems arrayByAddingObject: item];
    
    [self.navigationItem setRightBarButtonItems: newItems animated:YES];
}

+(void)openAttachment:(id)arg2 {
    NSLog(@"EdmodoFixer: arg2 class = %@", [arg2 class]);
    NSLog(@"EdmodoFixer: %@", [arg2 performSelector:@selector(_methodDescription)]);
    NSLog(@"EdmofoFixer: file size: %ld", (long)[arg2 performSelector:@selector(size)]);
    NSLog(@"EdmofoFixer: file url: %@", [arg2 performSelector:@selector(downloadURL)]);
    NSLog(@"EdmofoFixer: attachment type: %@", [arg2 performSelector:@selector(attachmentType)]);
    NSLog(@"EdmofoFixer: attachment name: %@", [arg2 performSelector:@selector(name)]);
    %orig(arg2);
}

%end