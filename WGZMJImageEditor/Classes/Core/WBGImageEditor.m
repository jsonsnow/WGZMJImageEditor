//
//  WBGImageEditor.m
//  Trader
//
//  Created by Jason on 2017/3/13.
//
//

#import "WBGImageEditor.h"
#import "WBGImageEditorViewController.h"
#import <Mediator/WGImageEditModuleService.h>

@interface WBGImageEditor ()

@end

@implementation WBGImageEditor

+ (void)load {
    [Bifrost bindURL:kRouteImageEdit toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
        UIImage *image = parameters[kRouteImageEditParamImage];
         void(^callback)(id result) = parameters[kBifrostRouteCompletion];
        WBGImageEditor *editor = [[WBGImageEditor alloc] initWithImage:image];
        editor.imageEditorDidFinishEdittingHandler = ^(WBGImageEditor *editor, UIImage *image) {
            [editor dismissViewControllerAnimated:YES completion:nil];
            callback(image);
        };
        return editor;
    }];
}

- (instancetype)init
{
    return [WBGImageEditorViewController new];
}

- (id)initWithImage:(UIImage*)image
{
    return [self initWithImage:image delegate:nil dataSource:nil];
}

- (id)initWithImage:(UIImage*)image delegate:(id<WBGImageEditorDelegate>)delegate dataSource:(id<WBGImageEditorDataSource>)dataSource;
{
    WBGImageEditorViewController *WBGVC = [[WBGImageEditorViewController alloc] initWithImage:image delegate:delegate dataSource:dataSource];
    WBGVC.needChangeOriention = self.needChangeOriention;
    return WBGVC;
}

- (id)initWithDelegate:(id<WBGImageEditorDelegate>)delegate
{
    return [[WBGImageEditorViewController alloc] initWithDelegate:delegate];
}

- (void)showInViewController:(UIViewController*)controller withImageView:(UIImageView*)imageView;
{
    
}

- (void)refreshToolSettings
{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
