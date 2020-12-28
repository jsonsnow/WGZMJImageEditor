//
//  WBGImageEditorViewController.h
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/27.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGImageEditor.h"

typedef NS_ENUM(NSUInteger, EditorMode) {
    EditorNonMode,
    EditorDrawMode,
    EditorTextMode,
    EditorClipMode,
    EditorPaperMode,
    EditorFilterMode,
    EditoradjustMode
};

extern NSString * const kColorPanNotificaiton;

@interface WBGColorPan : UIView
@property (nonatomic, strong, readonly) UIColor *currentColor;
@property (nonatomic, weak) id<WBGImageEditorDataSource> dataSource;
@end

@interface WBGImageEditorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;

@property (weak,   nonatomic, readonly) IBOutlet UIImageView *imageView;
@property (strong, nonatomic, readonly) IBOutlet UIImageView *drawingView;
@property (weak,   nonatomic, readonly) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic, readonly) IBOutlet WBGColorPan *colorPan;

@property (nonatomic, assign) BOOL needChangeOriention;
@property (nonatomic, assign) EditorMode currentMode;
@property (nonatomic, copy) void(^imageEditorDidFinishEdittingHandler)(WBGImageEditorViewController *edit, UIImage *result);
@property (nonatomic, weak) id<WBGImageEditorDelegate> delegate;
@property (nonatomic, weak) id<WBGImageEditorDataSource> dataSource;

- (id)initWithImage:(UIImage*)image delegate:(id<WBGImageEditorDelegate>)delegate dataSource:(id<WBGImageEditorDataSource>)dataSource;
- (void)resetCurrentTool;

- (void)editTextAgain;
- (void)hiddenTopAndBottomBar:(BOOL)isHide animation:(BOOL)animation;
@end
