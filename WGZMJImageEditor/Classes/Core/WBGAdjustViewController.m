//
//  WBGAdjustViewController.m
//  CocoaLumberjack
//
//  Created by 微购科技 on 2018/11/15.
//

#import "WBGAdjustViewController.h"
#import "GPUImage.h"

#define lr_space 5
#define minValue 0.0
#define maxValue 100.0

@interface WBGAdjustViewController ()
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *restBtn;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, strong) GPUImagePicture *picture;
@property (nonatomic, strong) NSMutableArray *filterArray;
@property (nonatomic, strong) GPUImageView *myGpuImageView;

@end

@implementation WBGAdjustViewController {
    float _value2;
    float _value3;
    float _value4;
    float _value5;
    float _value6;
    float _value7;
    float _value8;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupArray];
    [self setDefaultValue];
    [self setupUI];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    CGRect rect = CGRectZero;
    CGFloat scale = self.backImage.size.width/self.backImage.size.height;
    if (orientation ==  UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        rect = CGRectMake(0, 0, self.view.frame.size.height*scale, self.view.frame.size.height);
    }else{
        rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/scale);
    }
    self.imageView.frame = rect;
    self.imageView.center = self.view.center;
    self.sliderView.frame = CGRectMake(0,  [UIScreen mainScreen].bounds.size.height-149, self.view.frame.size.width, 50);
    self.slider.frame = CGRectMake(lr_space*2+50, 0, self.view.frame.size.width-50-lr_space*2-50, 50);
    self.restBtn.frame = CGRectMake(lr_space, 7, 50, 36);
    self.rightLabel.frame = CGRectMake(self.view.frame.size.width-45, 0, 40, 50);
    [self.toolView removeFromSuperview];
    [self setupToolView];
    self.scrollView.frame = CGRectMake(0, CGRectGetMinY(self.toolView.frame) - 50, [UIScreen mainScreen].bounds.size.width, 50);
}

- (void)setupArray{
    self.titleArray = @[@"亮度",@"对比度",@"饱和度",@"曝光度",@"色温",@"高光",@"阴影"];
    self.btnArray = [[NSMutableArray alloc]init];
    self.filterArray = [[NSMutableArray alloc]init];
    self.image = self.backImage;
    self.picture = [[GPUImagePicture alloc] initWithImage:self.backImage smoothlyScaleOutput:YES];

}

- (void)setDefaultValue{
    _value2 = _value4 = _value5 = 50.0;
    _value3 =25.0;
    _value6 = 100/3;
    _value7 = 100;
    _value8 = 0;
}

- (void)changeSliderValue:(float)value{
    if (self.filterArray.count) {
        [self.filterArray removeAllObjects];
    }
    //-1~1   100   0    0.02
    GPUImageBrightnessFilter *filter1 = [[GPUImageBrightnessFilter alloc]init];
    //0~4  100  1  0.04
    GPUImageContrastFilter *filter2 = [[GPUImageContrastFilter alloc]init];
    //0~2  100  1  0.02
    GPUImageSaturationFilter *filter3 = [[GPUImageSaturationFilter alloc]init];
    //-10~10  100  0  0.2
    GPUImageExposureFilter *filter4 = [[GPUImageExposureFilter alloc]init];
    //4000~7000 100 5000 30
    GPUImageWhiteBalanceFilter *filter5 = [[GPUImageWhiteBalanceFilter alloc]init];
    //1~0 100 1 0.01
    GPUImageHighlightShadowFilter *filter6 = [[GPUImageHighlightShadowFilter alloc]init];
    //0~1 100 0 0.01
    GPUImageHighlightShadowFilter *filter7 = [[GPUImageHighlightShadowFilter alloc]init];
    switch (self.adjustType) {
        case WBGAdjustTypeBrightness:{
           
            if (self.statusType == WBGStatusTypeChanging) {
                _value2 = value;
            }else if (self.statusType == WBGStatusTypeStopped){
                self.slider.value = _value2;
            }else{
                _value2 = 50.0;
                self.slider.value = _value2;
            }
        
            self.rightLabel.text = [NSString stringWithFormat:@"%ld",(NSInteger)_value2];
        }
            break;
        case WBGAdjustTypeContrast:{
           
            if (self.statusType == WBGStatusTypeChanging) {
                _value3 = value;
            }else if (self.statusType == WBGStatusTypeStopped){
                self.slider.value = _value3;
            }else{
                _value3 = 25.0;
                self.slider.value = _value3;
            }
           
            self.rightLabel.text = [NSString stringWithFormat:@"%ld",(NSInteger)_value3];
        }
            break;
        case WBGAdjustTypeSaturation:{
            
            if (self.statusType == WBGStatusTypeChanging) {
                _value4 = value;
            }else if(self.statusType == WBGStatusTypeStopped){
                self.slider.value = _value4;
            }else{
               _value4 = 50.0;
               self.slider.value = _value4;
            }

            self.rightLabel.text = [NSString stringWithFormat:@"%ld",(NSInteger)_value4];
        }
            break;
        case WBGAdjustTypeVisibility:{
            
            if (self.statusType == WBGStatusTypeChanging) {
                _value5 = value;
            }else if (self.statusType == WBGStatusTypeStopped){
               self.slider.value = _value5;
            }else{
                _value5 = 50.0;
                self.slider.value = _value5;
            }

            self.rightLabel.text = [NSString stringWithFormat:@"%ld",(NSInteger)_value5];
        }
            break;
        case WBGAdjustTypeColorTemperature:{
           
            if (self.statusType == WBGStatusTypeChanging) {
                _value6 = value;
            }else if (self.statusType == WBGStatusTypeStopped){
               self.slider.value = _value6;
            }else{
                _value6 = 100/3;
                self.slider.value = _value6;
            }
          
            self.rightLabel.text = [NSString stringWithFormat:@"%ld",(NSInteger)_value6];
        }
            break;
        case WBGAdjustTypeHighlights:{

            if (self.statusType == WBGStatusTypeChanging) {
                _value7 = value;
            }else if (self.statusType == WBGStatusTypeStopped){
                self.slider.value = _value7;
            }else{
                _value7 = 100.0;
                self.slider.value = _value7;
            }
            
            self.rightLabel.text = [NSString stringWithFormat:@"%ld",(NSInteger)_value7];
        }
            break;
        case WBGAdjustTypeshadow:{
          
            if (self.statusType == WBGStatusTypeChanging) {
                _value8 = value;
            }else if (self.statusType == WBGStatusTypeStopped){
                self.slider.value = _value8;
            }else{
                _value8 = 0.0;
                self.slider.value = _value8;
            }
    
            self.rightLabel.text = [NSString stringWithFormat:@"%ld",(NSInteger)_value8];
        }
            break;
        default:
            break;
    }
    
    filter1.brightness = (-1+0.02*(NSInteger)_value2);
    [self.filterArray addObject:filter1];
    filter2.contrast = (0.04*(NSInteger)_value3);
    [self.filterArray addObject:filter2];
    filter3.saturation = (0.02*(NSInteger)_value4);
    [self.filterArray addObject:filter3];
    filter4.exposure = (-10+0.2*(NSInteger)_value5);
    [self.filterArray addObject:filter4];
    filter5.temperature = (4000+30*(NSInteger)_value6);
    [self.filterArray addObject:filter5];
    filter6.highlights = (0.01*(NSInteger)_value7);
    [self.filterArray addObject:filter6];
    filter7.shadows = (0.01*(NSInteger)_value8);
    [self.filterArray addObject:filter7];
    
    if (self.filterArray.count) {
        self.myGpuImageView.frame = self.imageView.bounds;
        [self.imageView addSubview:self.myGpuImageView];
        GPUImageFilterPipeline *filterPipline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:self.filterArray input:self.picture output:self.myGpuImageView];
        //处理图片
        [self.picture processImage];
        [[self.filterArray lastObject] useNextFrameForImageCapture];
        //拿到处理后的图片
        self.image = [filterPipline currentFilteredFrame];

    }
}




- (void)setSliderType{
    switch (self.currentTag) {
        case 11:
            self.adjustType = WBGAdjustTypeBrightness;
            break;
        case 12:
            self.adjustType = WBGAdjustTypeContrast;
            break;
        case 13:
            self.adjustType = WBGAdjustTypeSaturation;
            break;
        case 14:
            self.adjustType = WBGAdjustTypeVisibility;
            break;
        case 15:
            self.adjustType = WBGAdjustTypeColorTemperature;
            break;
        case 16:
            self.adjustType = WBGAdjustTypeHighlights;
            break;
        case 17:
            self.adjustType = WBGAdjustTypeshadow;
            break;
        default:
            break;
    }
    
}

- (void)setupUI{

    self.view.backgroundColor = [UIColor blackColor];
    
    
    CGFloat scale = self.backImage.size.width/self.backImage.size.height;
    self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/scale);
    self.imageView.center = self.view.center;
    self.imageView.image = self.backImage;
    [self.view addSubview:self.imageView];
    //sliderView
    self.sliderView.hidden = YES;
    [self.view addSubview:self.sliderView];
    //重置
    [self.restBtn addTarget:self action:@selector(restBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sliderView addSubview:self.restBtn];
    //滑块
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sliderView addSubview:self.slider];
    //数值
    [self.sliderView addSubview:self.rightLabel];
    
    
    CGFloat btnW = 60;
    CGFloat btnH = 50;
    CGFloat c_space = 10;
    [self.titleArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(lr_space+idx*(btnW+c_space), 0, btnW, btnH);
        [btn setTitle:self.titleArray[idx] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0 green:0.780 blue:0.071 alpha:1] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 11+idx;
        [self.scrollView addSubview:btn];
        [self.btnArray addObject:btn];
    }];
    self.scrollView.contentSize = CGSizeMake(lr_space*2+self.titleArray.count*btnW+(self.titleArray.count-1)*c_space, btnH);
    [self.view addSubview:self.scrollView];
    
}

- (void)setupToolView{
    CGFloat WIDTH = self.view.frame.size.width;
    CGFloat HEIGHT = self.view.frame.size.height;
    CGFloat btnW = 60;
    UIView *toolView = [[UIView alloc] init];
    toolView.frame = CGRectMake(0, HEIGHT - 49, WIDTH, 49);
    toolView.backgroundColor = [UIColor colorWithRed:0.161 green:0.184 blue:0.200 alpha:1];
    [self.view addSubview:toolView];
    _toolView = toolView;
    
    CGFloat TbtnW = 50;
    CGFloat TbtnH = 49;
    CGFloat Tlr_space = 5;
    CGFloat Tc_space = ([UIScreen mainScreen].bounds.size.width-TbtnW*2-Tlr_space*2);
    NSArray *arr = @[@"返回",@"完成"];
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(Tlr_space+i*(Tc_space+btnW-Tlr_space), 0, TbtnW, TbtnH);
        btn.tag = 100 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (i == 1) {
            [btn setTitleColor:[UIColor colorWithRed:0 green:0.780 blue:0.071 alpha:1] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:btn];
    }
}

- (void)restBtnClick:(UIButton *)restBtn{
    self.statusType = WBGStatusTypeRest;
    [self changeSliderValue:0];
}

- (void)titleBtnClick:(UIButton *)currentBtn{
    self.currentTag = currentBtn.tag;
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn.tag == currentBtn.tag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }];
    if (self.sliderView.hidden) {
         self.sliderView.hidden = NO;
        self.statusType = WBGStatusTypeRest;
    }else{
        self.statusType = WBGStatusTypeStopped;
    }
    [self setSliderType];
    [self changeSliderValue:0];
}


- (void)buttonAction:(UIButton *)btn {
    switch (btn.tag) {
        case 100:{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 101:{
            if (self.adjustViewControllerHandler) {
                self.adjustViewControllerHandler(self.image);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}


-(void)sliderValueChanged:(UISlider *)slider
{
    self.statusType = WBGStatusTypeChanging;
    [self setSliderType];
    [self changeSliderValue:slider.value];
    
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

- (GPUImageView *)myGpuImageView{
 
    if (!_myGpuImageView) {
        _myGpuImageView = [[GPUImageView alloc]init];
    }
    return _myGpuImageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-99, [UIScreen mainScreen].bounds.size.width, 50)];
        _scrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
    }
    return _scrollView;
}

- (UIView *)sliderView{
    if (!_sliderView) {
        _sliderView = [[UIView alloc]initWithFrame:CGRectMake(0,  [UIScreen mainScreen].bounds.size.height-149, self.view.frame.size.width, 50)];
    }
    return _sliderView;
}

- (UISlider *)slider{
    if (!_slider) {
        _slider = [[UISlider alloc]initWithFrame:CGRectMake(lr_space*2+50, 0, self.view.frame.size.width-50-lr_space*2-50, 50)];
        _slider.minimumValue = minValue;
        _slider.maximumValue = maxValue;
    }
    return _slider;
    
}

- (UIButton *)restBtn{
    if (!_restBtn) {
        _restBtn = [[UIButton alloc]initWithFrame:CGRectMake(lr_space, 7, 50, 36)];
        [_restBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_restBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_restBtn setBackgroundColor:[UIColor clearColor]];
        _restBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _restBtn.layer.cornerRadius = 5;
        _restBtn.layer.masksToBounds = YES;
    }
    return _restBtn;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.frame = CGRectMake(self.view.frame.size.width-45, 0, 40, 50);
        _rightLabel.textColor = [UIColor whiteColor];
        _rightLabel.font = [UIFont systemFontOfSize:11];
        _rightLabel.text = @"100";
    }
    return _rightLabel;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
