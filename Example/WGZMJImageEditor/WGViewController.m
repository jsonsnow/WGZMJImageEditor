//
//  WGViewController.m
//  WGZMJImageEditor
//
//  Created by jsonsnow on 12/22/2020.
//  Copyright (c) 2020 jsonsnow. All rights reserved.
//

#import "WGViewController.h"
//#import <Mediator/wgi>
//#import <Mediator/w>/
#import <WGImageEditModuleService.h>

@interface WGViewController ()

@end

@implementation WGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1608280290155_0" ofType:@"jpg"]];
        UIImage *image = [UIImage imageWithData:data];
        UIViewController *ctr = [Bifrost handleURL:kRouteImageEdit complexParams:@{kRouteImageEditParamImage:image} completion:^(id  _Nullable result) {
            NSLog(@"comple");
        }];
        ctr.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:ctr animated:YES completion:nil];
//           WBGImageEditor *editor = [[WBGImageEditor alloc] initWithImage:[UIImage imageWithData:data] delegate:self dataSource:self];
//           editor.imageEditorDidFinishEdittingHandler = ^(WBGImageEditor *editor, UIImage *image) {
//               [editor dismissViewControllerAnimated:YES completion:nil];
//           };
//           [self presentViewController:editor animated:YES completion:nil];
    });
   
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
