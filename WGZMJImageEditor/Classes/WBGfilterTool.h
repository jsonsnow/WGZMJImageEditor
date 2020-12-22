//
//  WBGfilterTool.h
//  CocoaLumberjack
//
//  Created by 微购科技 on 2018/11/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WBGfilterItem.h"
#import "GPUImage.h"

@interface WBGfilterTool : NSObject

+ (UIImage *)filterImage:(UIImage *)image filterType:(GTFilterType)filterType;

@end


