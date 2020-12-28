//
//  WBGImageEditor.h
//  Trader
//
//  Created by Jason on 2017/3/13.
//
//

#import <UIKit/UIKit.h>

@protocol WBGImageEditorDelegate, WBGImageEditorTransitionDelegate, WBGImageEditorDataSource;
@class WBGMoreKeyboardItem;
@class WBGImageEditor;

typedef NS_OPTIONS(NSInteger, WBGImageEditorComponent) {
    WBGImageEditorDrawComponent = 1 << 0,
    WBGImageEditorTextComponent = 1 << 1,
    WBGImageEditorClipComponent = 1 << 2,
    WBGImageEditorPaperComponent = 1 << 3,
    WBGImageEditorColorPanComponent = 1 << 4,
    //all
    WBGImageEditorWholeComponent = WBGImageEditorDrawComponent
                                 | WBGImageEditorTextComponent
                                 | WBGImageEditorClipComponent
                                 | WBGImageEditorPaperComponent
                                 | WBGImageEditorColorPanComponent,
};

#pragma mark - Block

typedef void(^WBGImageEditorDidFinishEdittingHandler)(WBGImageEditor *editor, UIImage *image);

@interface WBGImageEditor : NSObject

@property (nonatomic, assign) BOOL needChangeOriention;
@property (nonatomic, weak) id<WBGImageEditorDelegate> delegate;
@property (nonatomic, weak) id<WBGImageEditorDataSource> dataSource;
@property (nonatomic, copy) WBGImageEditorDidFinishEdittingHandler imageEditorDidFinishEdittingHandler;

@end

#pragma mark - Protocol
@protocol WBGImageEditorDelegate <NSObject>
@optional
- (void)imageEditor:(WBGImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image;
- (void)imageEditorDidCancel:(WBGImageEditor *)editor;

@end

@protocol WBGImageEditorDataSource <NSObject>

@required
- (NSArray<WBGMoreKeyboardItem *> *)imageItemsEditor:(WBGImageEditor *)editor;
- (WBGImageEditorComponent)imageEditorCompoment;

@optional
- (UIColor *)imageEditorDefaultColor;
- (NSNumber *)imageEditorDrawPathWidth;
@end


@protocol WBGImageEditorTransitionDelegate <WBGImageEditorDelegate>
@optional
- (void)imageEditor:(WBGImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled;
- (void)imageEditor:(WBGImageEditor *)editor didDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled;

@end
