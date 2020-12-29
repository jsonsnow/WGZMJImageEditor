//
//  WBGImageEditorViewController.m
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/27.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import "WBGImageEditorViewController.h"
#import "WBGImageToolBase.h"
#import "ColorfullButton.h"
#import "WBGDrawTool.h"
#import "WBGTextTool.h"
#import "TOCropViewController.h"
#import "UIImage+CropRotate.h"
#import "WBGTextToolView.h"
#import "UIView+YYAdd.h"
#import "WBGImageEditor.h"
#import "WBGMoreKeyboard.h"
#import "WBGMosicaViewController.h"
#import "YYCategories.h"
#import "WBGfilterItem.h"
#import "WBGfilterTool.h"
#import "WBGAdjustViewController.h"



NSString * const kColorPanNotificaiton = @"kColorPanNotificaiton";
#pragma mark - WBGImageEditorViewController

@interface WBGImageEditorViewController () <UINavigationBarDelegate, UIScrollViewDelegate, TOCropViewControllerDelegate, WBGMoreKeyboardDelegate, WBGKeyboardDelegate> {
    
    __weak IBOutlet NSLayoutConstraint *topBarTop;
    __weak IBOutlet NSLayoutConstraint *bottomBarBottom;
}
@property (nonatomic, strong, nullable) WBGImageToolBase *currentTool;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UIView *topBar;

@property (strong, nonatomic) IBOutlet UIView *topBannerView;
@property (strong, nonatomic) IBOutlet UIView *bottomBannerView;
@property (strong, nonatomic) IBOutlet UIView *leftBannerView;
@property (strong, nonatomic) IBOutlet UIView *rightBannerView;

@property (weak,   nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *drawingView;
@property (weak,   nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet WBGColorPan *colorPan;
@property (weak, nonatomic) IBOutlet UIButton *fileterButton;
@property (weak, nonatomic) IBOutlet UIButton *adjustButton;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *panButton;
@property (weak, nonatomic) IBOutlet UIButton *textButton;
@property (weak, nonatomic) IBOutlet UIButton *clipButton;
@property (weak, nonatomic) IBOutlet UIButton *paperButton;

@property (nonatomic, strong) UIScrollView *filterMenu;
@property (nonatomic, strong) WBGfilterItem *selectFilterItem;

@property (nonatomic, strong) WBGDrawTool *drawTool;
@property (nonatomic, strong) WBGTextTool *textTool;

@property (nonatomic, copy  ) UIImage   *originImage;

@property (nonatomic, assign) CGFloat clipInitScale;
@property (nonatomic, assign) BOOL barsHiddenStatus;
@property (nonatomic, strong) WBGMoreKeyboard *keyboard;

@end

@implementation WBGImageEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id)init
{
    self = [self initWithNibName:@"WBGImageEditorViewController" bundle:[NSBundle bundleForClass:self.class]];
    if (self){
        
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    return [self initWithImage:image delegate:nil dataSource:nil];
}

- (id)initWithImage:(UIImage*)image delegate:(id<WBGImageEditorDelegate>)delegate dataSource:(id<WBGImageEditorDataSource>)dataSource;
{
    self = [self init];
    if (self){
        _originImage = image;
        self.delegate = delegate;
        self.dataSource = dataSource;
    }
    return self;
}

- (id)initWithDelegate:(id<WBGImageEditorDelegate>)delegate
{
    self = [self init];
    if (self){
        
        self.delegate = delegate;
    }
    return self;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.colorPan.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-99, [UIScreen mainScreen].bounds.size.width, 50);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //  HideBusyIndicatorForView(self.view);
        [self refreshImageView];
    });
    
    //获取自定制组件 - fecth custom config
    [self configCustomComponent];
     self.filterMenu.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-119, [UIScreen mainScreen].bounds.size.width, 70);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.undoButton.hidden = YES;
    
//    self.colorPan.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 100, self.colorPan.bounds.size.width, self.colorPan.bounds.size.height);
    self.colorPan.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-99, [UIScreen mainScreen].bounds.size.width, 50);
    self.colorPan.dataSource = self.dataSource;
    [self.view addSubview:_colorPan];
    [self.view addSubview:self.filterMenu];
    self.filterMenu.hidden = YES;
    [self initImageScrollView];
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        if ([self.dataSource respondsToSelector:@selector(imageEditorCompoment)] && [self.dataSource imageEditorCompoment] & WBGImageEditorDrawComponent) {
            [self.panButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    });
    
    self.panButton.hidden = YES;
    self.textButton.hidden = YES;
    self.clipButton.hidden = YES;
    self.paperButton.hidden = YES;
    self.colorPan.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //ShowBusyIndicatorForView(self.view);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      //  HideBusyIndicatorForView(self.view);
        [self refreshImageView];
    });
    
    //获取自定制组件 - fecth custom config
    [self configCustomComponent];
}

- (void)configCustomComponent {
    NSMutableArray *valibleCompoment = NSMutableArray.new;
    WBGImageEditorComponent curComponent = [self.dataSource respondsToSelector:@selector(imageEditorCompoment)] ? [self.dataSource imageEditorCompoment] : 0;
    if (curComponent == 0) { curComponent = WBGImageEditorWholeComponent; }
    if (curComponent & WBGImageEditorDrawComponent) { self.panButton.hidden = NO; [valibleCompoment addObject:self.panButton]; }
    if (curComponent & WBGImageEditorTextComponent) { self.textButton.hidden = NO; [valibleCompoment addObject:self.textButton]; }
    if (curComponent & WBGImageEditorClipComponent) { self.clipButton.hidden = NO; [valibleCompoment addObject:self.clipButton]; }
    if (curComponent & WBGImageEditorPaperComponent) { self.paperButton.hidden = NO; [valibleCompoment addObject:self.paperButton]; }
    if (curComponent & WBGImageEditorColorPanComponent) { self.colorPan.hidden = NO; }
    if (!self.panButton.selected && self.currentMode != EditorNonMode) {
        self.colorPan.hidden = YES;
    }
//    [valibleCompoment enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGRect originFrame = button.frame;
//        originFrame.origin.x = idx == 0 ?(idx + 1) * 30.f : (idx + 1) * 30.f + originFrame.size.width * idx;
//        button.frame = originFrame;
//    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.drawingView) {
        self.drawingView = [[UIImageView alloc] initWithFrame:self.imageView.superview.frame];
        self.drawingView.contentMode = UIViewContentModeCenter;
        self.drawingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        [self.imageView.superview addSubview:self.drawingView];
        self.drawingView.userInteractionEnabled = YES;
    } else {
        //self.drawingView.frame = self.imageView.superview.frame;
    }
    
    
    self.topBannerView.frame = CGRectMake(0, 0, self.imageView.width, CGRectGetMinY(self.imageView.frame));
    self.bottomBannerView.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.imageView.width, self.drawingView.height - CGRectGetMaxY(self.imageView.frame));
    self.leftBannerView.frame = CGRectMake(0, 0, CGRectGetMinX(self.imageView.frame), self.drawingView.height);
    self.rightBannerView.frame= CGRectMake(CGRectGetMaxX(self.imageView.frame), 0, self.drawingView.width - CGRectGetMaxX(self.imageView.frame), self.drawingView.height);
}

- (UIView *)topBannerView {
    if (!_topBannerView) {
        _topBannerView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = self.scrollView.backgroundColor;
            [self.imageView.superview addSubview:view];
            view;
        });
    }
    
    return _topBannerView;
}

- (UIView *)bottomBannerView {
    if (!_bottomBannerView) {
        _bottomBannerView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = self.scrollView.backgroundColor;
            [self.imageView.superview addSubview:view];
            view;
        });
    }
    return _bottomBannerView;
}

- (UIView *)leftBannerView {
    if (!_leftBannerView) {
        _leftBannerView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = self.scrollView.backgroundColor;
//            [self.imageView.superview addSubview:view];
            view;
        });
    }
    
    return _leftBannerView;
}

- (UIView *)rightBannerView {
    if (!_rightBannerView) {
        _rightBannerView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = self.scrollView.backgroundColor;
//            [self.imageView.superview addSubview:view];
            view;
        });
    }
    
    return _rightBannerView;
}

#pragma mark - 初始化 &getter
- (WBGDrawTool *)drawTool {
    if (_drawTool == nil) {
        _drawTool = [[WBGDrawTool alloc] initWithImageEditor:self];
        
        __weak typeof(self)weakSelf = self;
        _drawTool.drawToolStatus = ^(BOOL canPrev) {
            if (canPrev) {
                weakSelf.undoButton.hidden = NO;
            } else {
                weakSelf.undoButton.hidden = YES;
            }
        };
        _drawTool.drawingCallback = ^(BOOL isDrawing) {
            [weakSelf hiddenTopAndBottomBar:isDrawing animation:YES];
        };
        _drawTool.drawingDidTap = ^(void) {
            [weakSelf hiddenTopAndBottomBar:!weakSelf.barsHiddenStatus animation:YES];
        };
        _drawTool.pathWidth = [self.dataSource respondsToSelector:@selector(imageEditorDrawPathWidth)] ? [self.dataSource imageEditorDrawPathWidth].floatValue : 5.0f;
    }
    
    return _drawTool;
}

- (WBGTextTool *)textTool {
    if (_textTool == nil) {
        _textTool = [[WBGTextTool alloc] initWithImageEditor:self];
        __weak typeof(self)weakSelf = self;
        _textTool.dissmissTextTool = ^(NSString *currentText) {
            [weakSelf hiddenColorPan:NO animation:NO];
            weakSelf.currentMode = EditorNonMode;
            weakSelf.currentTool = nil;
        };
    }
    
    return _textTool;
}

- (void)initImageScrollView {
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.backgroundColor = [UIColor blackColor];

}

- (void)refreshImageView {
    if (self.imageView.image == nil) {
        self.imageView.image = self.originImage;
    }
    
    [self resetImageViewFrame];
    [self resetZoomScaleWithAnimated:NO];
    [self viewDidLayoutSubviews];
}

- (void)resetImageViewFrame {
//    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
//    if(size.width > 0 && size.height > 0 ) {
//        CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
//        CGFloat W = ratio * size.width * _scrollView.zoomScale;
//        CGFloat H = ratio * size.height * _scrollView.zoomScale;
//        
//        _imageView.frame = CGRectMake(MAX(0, (_scrollView.width-W)/2), MAX(0, (_scrollView.height-H)/2), W, H);
//    }
    CGFloat scale = _imageView.image.size.width/_imageView.image.size.height;
    self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/scale);
    self.imageView.center = self.view.center;
}

- (void)resetZoomScaleWithAnimated:(BOOL)animated
{
    CGFloat Rw = _scrollView.frame.size.width / _imageView.frame.size.width;
    CGFloat Rh = _scrollView.frame.size.height / _imageView.frame.size.height;
    
    //CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat scale = 1;
    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 3);
    
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
    [self scrollViewDidZoom:_scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark- ScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView.superview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{ }

#pragma mark - Property
- (void)setCurrentTool:(WBGImageToolBase *)currentTool {
    if(_currentTool != currentTool) {
        [_currentTool cleanup];
        _currentTool = currentTool;
        [_currentTool setup];
        
    }
    
    [self swapToolBarWithEditting];
}

#pragma mark- ImageTool setting
+ (NSString*)defaultIconImagePath {
    return nil;
}

+ (CGFloat)defaultDockedNumber {
    return 0;
}

+ (NSString *)defaultTitle {
    return @"";
}

+ (BOOL)isAvailable {
    return YES;
}

+ (NSArray *)subtools {
    return [NSArray new];
}

+ (NSDictionary*)optionalInfo {
    return nil;
}


#pragma mark - Actions

- (IBAction)adjustAction:(UIButton *)sender {
    self.currentMode = EditoradjustMode;
    
    WBGAdjustViewController *wvc = [[WBGAdjustViewController alloc]init];
    wvc.backImage = self.originImage;
   __weak typeof(self)weakSelf = self;
    wvc.adjustViewControllerHandler = ^(UIImage *image) {
        weakSelf.imageView.image = image;
    };
    [self presentViewController:wvc animated:YES completion:nil];
    
}

- (IBAction)fileterAction:(UIButton *)sender {
    self.currentMode = EditorFilterMode;
    self.filterMenu.hidden = NO;
    CGFloat W = 60;
    CGFloat H = 70;
    CGFloat x = 0;
    CGSize  imgSize = self.originImage.size;
    CGFloat maxW = MIN(imgSize.width, imgSize.height);
    UIImage *iconImage = [self scaleImage:self.originImage toSize:CGSizeMake(W * imgSize.width/maxW, W * imgSize.height/maxW)];
    
    for (int i = GTFilterTypeOriginal; i <= GTFilterTypeColorInvert; i++) {
        WBGfilterItem *item = [[WBGfilterItem alloc] initWithFrame:CGRectMake(x, 0, W, H) Image:iconImage filterType:i target:self action:@selector(tapFilter:)];
        [_filterMenu addSubview:item];
        
        if (!self.selectFilterItem) {
            self.selectFilterItem = item;
        }
        x += W;
    }
    self.filterMenu.contentSize = CGSizeMake(MAX(x, _filterMenu.frame.size.width+1), 0);
    self.colorPan.hidden = YES;
    [self setCurrentTool:nil];
}

#pragma mark - 滤镜
- (void)tapFilter:(UITapGestureRecognizer *)sender
{
    WBGfilterItem *item = (WBGfilterItem *)sender.view;
    if (self.selectFilterItem == item) return;
    
    self.selectFilterItem = item;
    
    //加滤镜
    self.imageView.image = [WBGfilterTool filterImage:self.originImage filterType:item.filterType];
}

- (void)setSelectFilterItem:(WBGfilterItem *)selectFilterItem
{
    if (selectFilterItem != _selectFilterItem) {
        _selectFilterItem.backgroundColor = [UIColor clearColor];
        _selectFilterItem = selectFilterItem;
        _selectFilterItem.backgroundColor = [UIColor colorWithWhite:1 alpha:.15];
    }
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    return [self scaledlmageWithData:data withSize:size scale:1.0 orientation:image.imageOrientation];
}

- (UIImage *)scaledlmageWithData:(NSData *)data withSize:(CGSize)size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation {
    CGFloat maxPixelSize = MAX(size.width, size.height);
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
    NSDictionary *options = @{(__bridge id)kCGImageSourceCreateThumbnailFromImageAlways:(__bridge id)kCFBooleanTrue,
                              (__bridge id)kCGImageSourceThumbnailMaxPixelSize:[NSNumber numberWithFloat:maxPixelSize]};
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(sourceRef, 0, (__bridge CFDictionaryRef)options);
    UIImage *resultlmage = [UIImage imageWithCGImage:imageRef scale:scale orientation:orientation];
    CGImageRelease(imageRef);
    CFRelease(sourceRef);
    return resultlmage;
}

///发送
- (IBAction)sendAction:(UIButton *)sender {

    [self buildClipImageShowHud:YES clipedCallback:^(UIImage *clipedImage) {
        
        if (self.imageEditorDidFinishEdittingHandler) {
            if (self.needChangeOriention) {
                [self orientationToPortrait:UIDeviceOrientationPortrait];
            }
            self.imageEditorDidFinishEdittingHandler(self,clipedImage);
        }
        
        if ([self.delegate respondsToSelector:@selector(imageEditor:didFinishEdittingWithImage:)]) {
            if (self.needChangeOriention) {
                [self orientationToPortrait:UIDeviceOrientationPortrait];
            }
            [self.delegate imageEditor:self didFinishEdittingWithImage:clipedImage];
        }
        
    }];
    
}

///涂鸦模式
- (IBAction)panAction:(UIButton *)sender {
    if (_currentMode == EditorDrawMode) {
        return;
    }
    //先设置状态，然后在干别的
    self.currentMode = EditorDrawMode;
    
    self.currentTool = self.drawTool;
    self.filterMenu.hidden = YES;
    self.colorPan.hidden = NO;
}

///裁剪模式
- (IBAction)clipAction:(UIButton *)sender {
    
    [self buildClipImageShowHud:NO clipedCallback:^(UIImage *clipedImage) {
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:clipedImage];
        cropController.delegate = self;
        __weak typeof(self)weakSelf = self;
        CGRect viewFrame = [self.view convertRect:self.imageView.frame toView:self.navigationController.view];
        [cropController presentAnimatedFromParentViewController:self
                                                      fromImage:clipedImage
                                                       fromView:nil
                                                      fromFrame:viewFrame
                                                          angle:0
                                                   toImageFrame:CGRectZero
                                                          setup:^{
                                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                  [weakSelf refreshImageView];
                                                                  weakSelf.colorPan.hidden = YES;
                                                                  weakSelf.filterMenu.hidden = YES;
                                                                  weakSelf.currentMode = EditorClipMode;
                                                                  [weakSelf setCurrentTool:nil];
                                                              });
                                                              
                                                          }
                                                     completion:^{
                                                     }];
    }];
    
}

//文字模式
- (IBAction)textAction:(UIButton *)sender {
    if ([self.colorPan.currentColor isEqual:[UIColor clearColor]]) {
        if (@available(iOS 8.0, *)) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请先选择画笔颜色" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionLeft = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:actionLeft];
            [self presentViewController:alert animated:YES completion:^{
            }];
        }
        return;
    }
    if (_currentMode == EditorTextMode) {
        return;
    }
    //先设置状态，然后在干别的
    self.currentMode = EditorTextMode;
    
    self.currentTool = self.textTool;
    self.filterMenu.hidden = YES;
}

//贴图模式
- (IBAction)paperAction:(UIButton *)sender {
    if (_currentMode == EditorTextMode) {
        return;
    }
    self.currentMode = EditorPaperMode;
    
    __weak typeof(self)weakSelf = self;
    [self buildClipImageShowHud:NO clipedCallback:^(UIImage *clipedImage) {
        typeof (self) strongSelf = weakSelf;
        CGRect viewFrame = [strongSelf.view convertRect:strongSelf.imageView.frame toView:strongSelf.navigationController.view];
        
        WBGMosicaViewController *vc = [[WBGMosicaViewController alloc] initWithImage:clipedImage frame:viewFrame];
        __weak typeof(self)weakSelf = strongSelf;
        
        vc.mosicaCallback = ^(UIImage *mosicaImage) {
            typeof (self) strongSelf = weakSelf;
            self.imageView.image = mosicaImage;
            CGRect bounds = strongSelf.drawingView.bounds;
            bounds.size = CGSizeMake(bounds.size.width/strongSelf.clipInitScale, bounds.size.height/self.clipInitScale);
            
            [strongSelf refreshImageView];
            [strongSelf viewDidLayoutSubviews];
            
            strongSelf.navigationItem.rightBarButtonItem.enabled = YES;
            
            //生成图片后，清空画布内容
            [strongSelf.drawTool.allLineMutableArray removeAllObjects];
            [strongSelf.drawTool drawLine];
            [strongSelf.drawingView removeAllSubviews];
            strongSelf.undoButton.hidden = YES;
        };
        
        [weakSelf presentViewController:vc animated:YES completion:^{
            typeof (self) strongSelf = weakSelf;
           strongSelf.filterMenu.hidden = YES;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [strongSelf refreshImageView];
//                strongSelf.colorPan.hidden = YES;
//
//                strongSelf.currentMode = EditorClipMode;
//                [strongSelf setCurrentTool:nil];
//            });
        }];
    }];
    
//    NSArray<WBGMoreKeyboardItem *> *sources = nil;
//    if (self.dataSource) {
//        sources = [self.dataSource imageItemsEditor:self];
//    }
//    //贴图模块
//    [self.keyboard setChatMoreKeyboardData:sources];
//    [self.keyboard showInView:self.view withAnimation:YES];
}

- (IBAction)backAction:(UIButton *)sender {
    if (self.needChangeOriention) {
        [self orientationToPortrait:UIDeviceOrientationPortrait];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)undoAction:(UIButton *)sender {
    if (self.currentMode == EditorDrawMode) {
        WBGDrawTool *tool = (WBGDrawTool *)self.currentTool;
        [tool backToLastDraw];
    }
}


- (void)editTextAgain {
    //WBGTextTool 钩子调用
    
    if (_currentMode == EditorTextMode) {
        return;
    }
    //先设置状态，然后在干别的
    self.currentMode = EditorTextMode;
    
    if(_currentTool != self.textTool) {
        [_currentTool cleanup];
        _currentTool = self.textTool;
        [_currentTool setup];

    }
    self.filterMenu.hidden = YES;
    [self hiddenColorPan:YES animation:NO];
}

- (void)resetCurrentTool {
    self.currentMode = EditorNonMode;
    self.currentTool = nil;
}

- (WBGMoreKeyboard *)keyboard {
    if (!_keyboard) {
        WBGMoreKeyboard *keyboard = [WBGMoreKeyboard keyboard];
        [keyboard setKeyboardDelegate:self];
        [keyboard setDelegate:self];
        _keyboard = keyboard;
    }
    return _keyboard;
}

#pragma mark - WBGMoreKeyboardDelegate
- (void) moreKeyboard:(id)keyboard didSelectedFunctionItem:(WBGMoreKeyboardItem *)funcItem {
    WBGMoreKeyboard *kb = (WBGMoreKeyboard *)keyboard;
    [kb dismissWithAnimation:YES];
    
    
    WBGTextToolView *view = [[WBGTextToolView alloc] initWithTool:self.textTool text:@"" font:nil orImage:funcItem.image];
    view.borderColor = [UIColor whiteColor];
    view.image = funcItem.image;
    view.center = [self.imageView.superview convertPoint:self.imageView.center toView:self.drawingView];
    view.userInteractionEnabled = YES;
    [self.drawingView addSubview:view];
    [WBGTextToolView setActiveTextView:view];
    
}

#pragma mark - WBGKeyboardDelegate

#pragma mark - Cropper Delegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController
{
    self.imageView.image = image;
    __unused CGFloat drawingWidth = self.drawingView.bounds.size.width;
    CGRect bounds = cropViewController.cropView.foregroundImageView.bounds;
    bounds.size = CGSizeMake(bounds.size.width/self.clipInitScale, bounds.size.height/self.clipInitScale);
    
    [self refreshImageView];
    [self viewDidLayoutSubviews];


    self.navigationItem.rightBarButtonItem.enabled = YES;
    __weak typeof(self)weakSelf = self;
    if (cropViewController.croppingStyle != TOCropViewCroppingStyleCircular) {

        [cropViewController dismissAnimatedFromParentViewController:self
                                                   withCroppedImage:image
                                                             toView:self.imageView
                                                            toFrame:CGRectZero
                                                              setup:^{
                                                                  [weakSelf refreshImageView];
                                                                  [weakSelf viewDidLayoutSubviews];
                                                                  weakSelf.colorPan.hidden = NO;
                                                              }
                                                         completion:^{
                                                             weakSelf.colorPan.hidden = NO;
                                                         }];
    }
    else {
        
        [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    //生成图片后，清空画布内容
    [self.drawTool.allLineMutableArray removeAllObjects];
    [self.drawTool drawLine];
    [_drawingView removeAllSubviews];
    self.undoButton.hidden = YES;
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    
    __weak typeof(self)weakSelf = self;
    [cropViewController dismissAnimatedFromParentViewController:self
                                               withCroppedImage:self.imageView.image
                                                         toView:self.imageView
                                                        toFrame:CGRectZero
                                                          setup:^{
                                                              [weakSelf refreshImageView];
                                                              [weakSelf viewDidLayoutSubviews];
                                                              weakSelf.colorPan.hidden = NO;
                                                          }
                                                     completion:^{
                                                         [UIView animateWithDuration:.3f animations:^{
                                                             weakSelf.colorPan.hidden = NO;
                                                         }];
                                                         
                                                     }];
}

#pragma mark -
- (void)swapToolBarWithEditting {
    switch (_currentMode) {
        case EditorDrawMode:
        {
            self.panButton.selected = YES;
            if (self.drawTool.allLineMutableArray.count > 0) {
                self.undoButton.hidden  = NO;
            }
        }
            break;
        case EditorTextMode:
            
        case EditorClipMode:
        case EditorNonMode:
            self.panButton.selected = NO;
            self.colorPan.hidden =  NO;
            break;
        case EditorFilterMode:
        {
            self.panButton.selected = NO;
            self.colorPan.hidden =  YES;
            self.undoButton.hidden  = YES;
        }
            break;
        default:
            break;
    }
}

- (void)hiddenTopAndBottomBar:(BOOL)isHide animation:(BOOL)animation {
    if (self.keyboard.isShow) {
        [self.keyboard dismissWithAnimation:YES];
        return;
    }
    if (isHide) {
        self.colorPan.hidden = YES;
        self.filterMenu.hidden = YES;
    }else{
        if (self.panButton.selected) {
            self.colorPan.hidden = NO;
            self.filterMenu.hidden = YES;
        }
    }

    [UIView animateWithDuration:animation ? .25f : 0.f delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:isHide ? UIViewAnimationOptionCurveEaseOut : UIViewAnimationOptionCurveEaseIn animations:^{
        if (isHide) {
            self->bottomBarBottom.constant = -49.f;
            self->topBarTop.constant = -64.f;
        } else {
            self->bottomBarBottom.constant = 0;
            self->topBarTop.constant = 0;
        }
        self->_barsHiddenStatus = isHide;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenColorPan:(BOOL)yesOrNot animation:(BOOL)animation {
    [UIView animateWithDuration:animation ? .25f : 0.f delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:yesOrNot ? UIViewAnimationOptionCurveEaseOut : UIViewAnimationOptionCurveEaseIn animations:^{
        self.colorPan.hidden = yesOrNot;
    } completion:^(BOOL finished) {
    
    }];
}

+ (UIImage *)createViewImage:(UIView *)shareView {
    UIGraphicsBeginImageContextWithOptions(shareView.bounds.size, NO, [UIScreen mainScreen].scale);
    [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    shareView.layer.affineTransform = shareView.transform;
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)buildClipImageShowHud:(BOOL)showHud clipedCallback:(void(^)(UIImage *clipedImage))clipedCallback {
    if (showHud) {
        //ShowBusyTextIndicatorForView(self.view, @"生成图片中...", nil);
    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIImage *textImg;
    WBGTextToolView *textLabel;
    
    CGFloat WS = self.imageView.width/ self.drawingView.width;
    CGFloat HS = self.imageView.height/ self.drawingView.height;
    for (UIView *subV in _drawingView.subviews) {
        if ([subV isKindOfClass:[WBGTextToolView class]]) {
            textLabel = (WBGTextToolView *)subV;
            //进入正常状态
            [WBGTextToolView setInactiveTextView:textLabel];
            //生成图片
            __unused UIView *tes = textLabel.archerBGView;
            textImg = [self.class screenshot:textLabel.archerBGView orientation:UIDeviceOrientationPortrait usePresentationLayer:YES];
        }
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.imageView.image.size.width, self.imageView.image.size.height),
                                           NO,
                                           self.imageView.image.scale);
    
    [self.imageView.image drawAtPoint:CGPointZero];
    CGFloat viewToimgW = self.imageView.width/self.imageView.image.size.width;
    CGFloat viewToimgH = self.imageView.height/self.imageView.image.size.height;
    __unused CGFloat drawX = self.imageView.left/viewToimgW;
    CGFloat drawY = self.imageView.top/viewToimgH;
    [_drawingView.image drawInRect:CGRectMake(0, -drawY, self.imageView.image.size.width/WS, self.imageView.image.size.height/HS)];
    
    if (textImg) {
        CGFloat rotation = textLabel.archerBGView.layer.transformRotationZ;
        textImg = [textImg imageRotatedByRadians:rotation];
        
        CGFloat selfRw = self.imageView.bounds.size.width / self.imageView.image.size.width;
        CGFloat selfRh = self.imageView.bounds.size.height / self.imageView.image.size.height;
        
        CGFloat sw = textImg.size.width / selfRw;
        CGFloat sh = textImg.size.height / selfRh;
        
        [textImg drawInRect:CGRectMake(textLabel.left/selfRw, (textLabel.top/selfRh) - drawY, sw, sh)];
    }
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *image = [UIImage imageWithCGImage:tmp.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    clipedCallback(image);
}

+ (UIImage *)screenshot:(UIView *)view orientation:(UIDeviceOrientation)orientation usePresentationLayer:(BOOL)usePresentationLayer
{
    __block CGSize targetSize = CGSizeZero;
   
    CGSize size = view.bounds.size;
    targetSize = CGSizeMake(size.width * view.layer.transformScaleX, size.height *  view.layer.transformScaleY);

    
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
   
    [view drawViewHierarchyInRect:CGRectMake(0, 0, targetSize.width, targetSize.height) afterScreenUpdates:NO];

    CGContextRestoreGState(ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIScrollView *)filterMenu{
    if (!_filterMenu) {
        _filterMenu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-119, [UIScreen mainScreen].bounds.size.width, 70)];
        _filterMenu.backgroundColor = self.colorPan.backgroundColor;
        _filterMenu.showsHorizontalScrollIndicator = NO;
        _filterMenu.clipsToBounds = NO;
    }
    return _filterMenu;
}


// 防止更改设备的横竖屏不起作用
-(void)orientationToPortrait:(UIDeviceOrientation)orientation{
    
    SEL seletor = NSSelectorFromString(@"setOrientation:");
    
    NSInvocation *invocatino = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:seletor]];
    [invocatino setSelector:seletor];
    [invocatino setTarget:[UIDevice currentDevice]];
    int val = orientation;
    [invocatino setArgument:&val atIndex:2];
    [invocatino invoke];
    
}

@end

#pragma mark - Class WBGWColorPan
@interface WBGColorPan ()
@property (nonatomic, strong) UIColor *currentColor;
@property (strong, nonatomic) IBOutletCollection(ColorfullButton) NSArray *colorButtons;

@property (weak, nonatomic) IBOutlet ColorfullButton *redButton;
@property (weak, nonatomic) IBOutlet ColorfullButton *orangeButton;
@property (weak, nonatomic) IBOutlet ColorfullButton *yellowButton;
@property (weak, nonatomic) IBOutlet ColorfullButton *greenButton;
@property (weak, nonatomic) IBOutlet ColorfullButton *blueButton;
@property (weak, nonatomic) IBOutlet ColorfullButton *pinkButton;
@property (weak, nonatomic) IBOutlet ColorfullButton *whiteButton;

@end

@implementation WBGColorPan
- (instancetype)init
{
    self = [super init];
    if (self) {
        //[self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSelectColor:)]];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //[self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSelectColor:)]];
    }
    return self;
}

- (UIColor *)currentColor {
    if (_currentColor == nil) {
        _currentColor = ([self.dataSource respondsToSelector:@selector(imageEditorDefaultColor)] && [self.dataSource imageEditorDefaultColor]) ? [self.dataSource imageEditorDefaultColor] : UIColor.redColor;
    }
    return _currentColor;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)panSelectColor:(UIPanGestureRecognizer *)recognizer {
    
    NSLog(@"recon = %@", NSStringFromCGPoint([recognizer translationInView:self]));
}

- (IBAction)buttonAction:(UIButton *)sender {
    ColorfullButton *theBtns = (ColorfullButton *)sender;
    
    for (ColorfullButton *button in _colorButtons) {
        if (button == theBtns) {
            button.isUse = YES;
            self.currentColor = theBtns.color;
            [[NSNotificationCenter defaultCenter] postNotificationName:kColorPanNotificaiton object:self.currentColor];
        } else {
            button.isUse = NO;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSLog(@"point: %@", NSStringFromCGPoint([touch locationInView:self]));
    NSLog(@"view=%@", touch.view);
    CGPoint touchPoint = [touch locationInView:self];
    for (ColorfullButton *button in _colorButtons) {
        CGRect rect = [button convertRect:button.bounds toView:self];
        if (CGRectContainsPoint(rect, touchPoint) && button.isUse == NO) {
            [self buttonAction:button];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    //NSLog(@"move->point: %@", NSStringFromCGPoint([touch locationInView:self]));
    CGPoint touchPoint = [touch locationInView:self];
    
    for (ColorfullButton *button in _colorButtons) {
        CGRect rect = [button convertRect:button.bounds toView:self];
        if (CGRectContainsPoint(rect, touchPoint) && button.isUse == NO) {
            [self buttonAction:button];
        }
    }
}




@end
