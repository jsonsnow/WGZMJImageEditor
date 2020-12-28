//
//  WGViewController.m
//  WGZMJImageEditor
//
//  Created by jsonsnow on 12/22/2020.
//  Copyright (c) 2020 jsonsnow. All rights reserved.
//

#import "WGViewController.h"
#import <Mediator/WGImageEditModuleService.h>

@interface TestObject : NSObject

@end

@implementation TestObject

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)send {
    
}

@end

@interface WGViewController ()
@property (nonatomic, copy) void(^testBlock)();

@end

@implementation WGViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1608280290155_0" ofType:@"jpg"]];
        UIImage *image = [UIImage imageWithData:data];
        UIViewController *ctr = [Bifrost handleURL:kRouteImageEdit complexParams:@{kRouteImageEditParamImage:image, kRouteImageEditParamDefaultColor: UIColor.blueColor} completion:^(id  _Nullable result) {
            NSLog(@"comple");
        }];
        ctr.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:ctr animated:YES completion:nil];
    });
    NSLog(@"start");
    self.testBlock = ^{
        TestObject *test = [[TestObject alloc] init];
        [test send];
    };
    self.testBlock();
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.testBlock = nil;
//    });
   
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
