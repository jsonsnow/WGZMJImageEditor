//
//  WBGAdjustViewController.h
//  CocoaLumberjack
//
//  Created by 微购科技 on 2018/11/15.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WBGStatusType) {
    WBGStatusTypeStopped,
    WBGStatusTypeChanging,
    WBGStatusTypeRest
};

typedef NS_ENUM(NSUInteger, WBGAdjustType) {
    WBGAdjustTypeBrightness,
    WBGAdjustTypeContrast,
    WBGAdjustTypeSaturation,
    WBGAdjustTypeVisibility,
    WBGAdjustTypeColorTemperature,
    WBGAdjustTypeHighlights,
    WBGAdjustTypeshadow,
};

typedef void(^WBGAdjustViewControllerHandler)(UIImage *image);

@interface WBGAdjustViewController : UIViewController

@property (nonatomic, strong) UIImage *backImage;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) WBGAdjustType adjustType;
@property (nonatomic, assign) WBGStatusType statusType;
@property (nonatomic, copy) WBGAdjustViewControllerHandler adjustViewControllerHandler;

@end

