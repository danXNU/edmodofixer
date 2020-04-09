#line 1 "Tweak.x"



































@interface EDMGenericWebViewController: UIViewController
@property (strong) UIActivityIndicatorView * indicatorView;

-(void)presentShareController:(NSArray *)items barItem:(UIBarButtonItem * _Nullable)barItem;
@end


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class EDMGenericWebViewController; 
static void _logos_method$_ungrouped$EDMGenericWebViewController$downloadAction$(_LOGOS_SELF_TYPE_NORMAL EDMGenericWebViewController* _LOGOS_SELF_CONST, SEL, UIBarButtonItem *); static void _logos_method$_ungrouped$EDMGenericWebViewController$presentShareController$barItem$(_LOGOS_SELF_TYPE_NORMAL EDMGenericWebViewController* _LOGOS_SELF_CONST, SEL, NSArray *, UIBarButtonItem * _Nullable); static void (*_logos_orig$_ungrouped$EDMGenericWebViewController$loadView)(_LOGOS_SELF_TYPE_NORMAL EDMGenericWebViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$EDMGenericWebViewController$loadView(_LOGOS_SELF_TYPE_NORMAL EDMGenericWebViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$EDMGenericWebViewController$setConstraints(_LOGOS_SELF_TYPE_NORMAL EDMGenericWebViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$EDMGenericWebViewController$viewWillAppear$)(_LOGOS_SELF_TYPE_NORMAL EDMGenericWebViewController* _LOGOS_SELF_CONST, SEL, bool); static void _logos_method$_ungrouped$EDMGenericWebViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL EDMGenericWebViewController* _LOGOS_SELF_CONST, SEL, bool); static void (*_logos_meta_orig$_ungrouped$EDMGenericWebViewController$openAttachment$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); static void _logos_meta_method$_ungrouped$EDMGenericWebViewController$openAttachment$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id); 

#line 42 "Tweak.x"


__attribute__((used)) static UIActivityIndicatorView * _logos_method$_ungrouped$EDMGenericWebViewController$indicatorView(EDMGenericWebViewController * __unused self, SEL __unused _cmd) { return (UIActivityIndicatorView *)objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$EDMGenericWebViewController$indicatorView); }; __attribute__((used)) static void _logos_method$_ungrouped$EDMGenericWebViewController$setIndicatorView(EDMGenericWebViewController * __unused self, SEL __unused _cmd, UIActivityIndicatorView * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$EDMGenericWebViewController$indicatorView, rawValue, OBJC_ASSOCIATION_RETAIN); }

 
static void _logos_method$_ungrouped$EDMGenericWebViewController$downloadAction$(_LOGOS_SELF_TYPE_NORMAL EDMGenericWebViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIBarButtonItem * sender) {
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


static void _logos_method$_ungrouped$EDMGenericWebViewController$presentShareController$barItem$(_LOGOS_SELF_TYPE_NORMAL EDMGenericWebViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSArray * items, UIBarButtonItem * _Nullable barItem) {
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    if (barItem) {
        shareController.popoverPresentationController.barButtonItem = barItem;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:shareController animated:YES completion:nil];
    });
}


static void _logos_method$_ungrouped$EDMGenericWebViewController$loadView(_LOGOS_SELF_TYPE_NORMAL EDMGenericWebViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$EDMGenericWebViewController$loadView(self, _cmd);

    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.hidesWhenStopped = YES;
    self.indicatorView.frame = CGRectMake(0,0, 30, 30);
    self.indicatorView.color = [UIColor orangeColor];
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview: self.indicatorView];

    [self performSelector:@selector(setConstraints)];
}


static void _logos_method$_ungrouped$EDMGenericWebViewController$setConstraints(_LOGOS_SELF_TYPE_NORMAL EDMGenericWebViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    [[self.indicatorView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    [[self.indicatorView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
    [[self.indicatorView.heightAnchor constraintEqualToConstant:20] setActive:YES];
    [[self.indicatorView.widthAnchor constraintEqualToConstant:20] setActive:YES];
}

static void _logos_method$_ungrouped$EDMGenericWebViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL EDMGenericWebViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, bool arg2) {
    _logos_orig$_ungrouped$EDMGenericWebViewController$viewWillAppear$(self, _cmd, arg2);

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Download" style: UIBarButtonItemStylePlain target:self action:@selector(downloadAction:)];
    NSArray *currentItems = [self.navigationItem rightBarButtonItems];
    NSArray *newItems = [currentItems arrayByAddingObject: item];
    
    [self.navigationItem setRightBarButtonItems: newItems animated:YES];
}

static void _logos_meta_method$_ungrouped$EDMGenericWebViewController$openAttachment$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg2) {
    NSLog(@"EdmodoFixer: arg2 class = %@", [arg2 class]);
    NSLog(@"EdmodoFixer: %@", [arg2 performSelector:@selector(_methodDescription)]);
    NSLog(@"EdmofoFixer: file size: %ld", (long)[arg2 performSelector:@selector(size)]);
    NSLog(@"EdmofoFixer: file url: %@", [arg2 performSelector:@selector(downloadURL)]);
    NSLog(@"EdmofoFixer: attachment type: %@", [arg2 performSelector:@selector(attachmentType)]);
    NSLog(@"EdmofoFixer: attachment name: %@", [arg2 performSelector:@selector(name)]);
    _logos_meta_orig$_ungrouped$EDMGenericWebViewController$openAttachment$(self, _cmd, arg2);
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$EDMGenericWebViewController = objc_getClass("EDMGenericWebViewController"); Class _logos_metaclass$_ungrouped$EDMGenericWebViewController = object_getClass(_logos_class$_ungrouped$EDMGenericWebViewController); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIBarButtonItem *), strlen(@encode(UIBarButtonItem *))); i += strlen(@encode(UIBarButtonItem *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$EDMGenericWebViewController, @selector(downloadAction:), (IMP)&_logos_method$_ungrouped$EDMGenericWebViewController$downloadAction$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSArray *), strlen(@encode(NSArray *))); i += strlen(@encode(NSArray *)); memcpy(_typeEncoding + i, @encode(UIBarButtonItem * _Nullable), strlen(@encode(UIBarButtonItem * _Nullable))); i += strlen(@encode(UIBarButtonItem * _Nullable)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$EDMGenericWebViewController, @selector(presentShareController:barItem:), (IMP)&_logos_method$_ungrouped$EDMGenericWebViewController$presentShareController$barItem$, _typeEncoding); }MSHookMessageEx(_logos_class$_ungrouped$EDMGenericWebViewController, @selector(loadView), (IMP)&_logos_method$_ungrouped$EDMGenericWebViewController$loadView, (IMP*)&_logos_orig$_ungrouped$EDMGenericWebViewController$loadView);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$EDMGenericWebViewController, @selector(setConstraints), (IMP)&_logos_method$_ungrouped$EDMGenericWebViewController$setConstraints, _typeEncoding); }MSHookMessageEx(_logos_class$_ungrouped$EDMGenericWebViewController, @selector(viewWillAppear:), (IMP)&_logos_method$_ungrouped$EDMGenericWebViewController$viewWillAppear$, (IMP*)&_logos_orig$_ungrouped$EDMGenericWebViewController$viewWillAppear$);MSHookMessageEx(_logos_metaclass$_ungrouped$EDMGenericWebViewController, @selector(openAttachment:), (IMP)&_logos_meta_method$_ungrouped$EDMGenericWebViewController$openAttachment$, (IMP*)&_logos_meta_orig$_ungrouped$EDMGenericWebViewController$openAttachment$);{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(UIActivityIndicatorView *)); class_addMethod(_logos_class$_ungrouped$EDMGenericWebViewController, @selector(indicatorView), (IMP)&_logos_method$_ungrouped$EDMGenericWebViewController$indicatorView, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(UIActivityIndicatorView *)); class_addMethod(_logos_class$_ungrouped$EDMGenericWebViewController, @selector(setIndicatorView:), (IMP)&_logos_method$_ungrouped$EDMGenericWebViewController$setIndicatorView, _typeEncoding); } } }
#line 146 "Tweak.x"
