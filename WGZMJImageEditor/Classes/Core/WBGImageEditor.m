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

@interface WBGImageEditor ()<WBGImageEditorDataSource, WBGImageEditorDelegate>
@property (nonatomic, assign) BOOL autoDismiss;
@property (nonatomic, strong) UIColor *defalutColor;
@property (nonatomic, weak) WBGImageEditorViewController *edit;

@end

@implementation WBGImageEditor

+ (void)load {
    [Bifrost bindURL:kRouteImageEdit toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
        UIImage *image = parameters[kRouteImageEditParamImage];
        void(^callback)(id result) = parameters[kBifrostRouteCompletion];
        BOOL autoDismiss = [parameters[kRouteImageEditParamAutoDismiss] boolValue];
        UIColor *defaultColor = parameters[kRouteImageEditParamDefaultColor];
        WBGImageEditor *editWrap = [WBGImageEditor edit];
        [editWrap reset];
        WBGImageEditorViewController *ctr = [editWrap _buildEditorCtrByImage:image];
        editWrap.autoDismiss = autoDismiss;
        editWrap.defalutColor = defaultColor;
        ctr.imageEditorDidFinishEdittingHandler = ^(WBGImageEditorViewController *editor, UIImage *image) {
            if (autoDismiss) {
                [editor dismissViewControllerAnimated:YES completion:nil];
            }
            callback(image);
        };
        return ctr;
    }];
}

+ (instancetype)edit {
    static dispatch_once_t onceToken;
    static WBGImageEditor *editor = nil;
    dispatch_once(&onceToken, ^{
        editor = [[WBGImageEditor alloc] init];
    });
    return editor;
}
#pragma mark --life cycle

- (void)dealloc {
    NSLog(@"delloc");
}

#pragma mark --private method

- (WBGImageEditorViewController *)_buildEditorCtrByImage:(UIImage *)image {
    WBGImageEditorViewController *edit = [[WBGImageEditorViewController alloc] initWithImage:image delegate:self dataSource:self];
    return edit;
}

- (void)reset {
    self.autoDismiss = NO;
    self.defalutColor = [UIColor clearColor];
}

#pragma mark --WBGImageEditorDataSource

- (WBGImageEditorComponent)imageEditorCompoment {
    NSLog(@"cccc");
    return WBGImageEditorTextComponent;
}

- (NSArray<WBGMoreKeyboardItem *> *)imageItemsEditor:(WBGImageEditor *)editor {
    return @[];
}

- (UIColor *)imageEditorDefaultColor {
    if (self.defalutColor) {
        return self.defalutColor;
    }
    return [UIColor clearColor];
}

#pragma mark --WBGImageEditorDelegate

@end
