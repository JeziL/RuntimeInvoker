//
//  ViewController.m
//  RuntimeInvoker
//
//  Created by cyan on 16/5/27.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "ViewController.h"
#import "RuntimeInvoker.h"

@implementation ViewController

- (CGRect)aRect {
    return CGRectMake(0, 0, 100, 100);
}

- (double)aDouble {
    return 42.42;
}

- (float)aFloat {
    return 42.42;
}

- (CGRect)justReturnCGRect: (CGRect)rect {
    return rect;
}

+ (UIEdgeInsets)aInsets {
    return UIEdgeInsetsMake(0, 0, 100, 100);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // return double or float.
    double d = [[self invoke:@"aDouble"] doubleValue];
    NSLog(@"Double: %.2f", d);
    
    float f = [[self invoke:@"aFloat"] floatValue];
    NSLog(@"Float: %.2f", f);
    
    // receive a struct (CGRect for example).
    CGRect r1 = CGRectMake(0.1, 0.2, 0.3, 0.4);
    CGRect r2 = [[self invoke:@"justReturnCGRect:" arguments:@[[NSValue valueWithCGRect:r1]]] CGRectValue];
    NSLog(@"CGRect received: %@", NSStringFromCGRect(r2));
    
    // public selector
    CGRect rect = [[self invoke:@"aRect"] CGRectValue];
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
    
    // public selector with argument
    [self.view invoke:@"setBackgroundColor:" arguments:@[ [UIColor whiteColor] ]];
    [self.view invoke:@"setAlpha:" arguments:@[ @(0.5) ]];
    [UIView animateWithDuration:3 animations:^{
        [self.view invoke:@"setAlpha:" arguments:@[ @(1.0) ]];
    }];
    
    // private selector
    int sizeClass = [[self invoke:@"_verticalSizeClass"] intValue];
    NSLog(@"sizeClass: %d", sizeClass);
    
    // private selector with argument
    [self invoke:@"_setShowingLinkPreview:" args:@(NO), nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self invoke:@"_setShowingLinkPreview:" args:@(YES), nil];
    });
    
    // class method selector
    UIEdgeInsets insets = [[self.class invoke:@"aInsets"] UIEdgeInsetsValue];
    NSLog(@"insets: %@", NSStringFromUIEdgeInsets(insets));
    
    // class method selector with argument
    UIColor *color = [UIColor invoke:@"colorWithRed:green:blue:alpha:"
                                args:@(0), @(0.5), @(1), nil];
    NSLog(@"color: %@", color);
}

@end
