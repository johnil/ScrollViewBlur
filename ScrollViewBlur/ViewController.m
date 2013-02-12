//
//  ViewController.m
//  ScrollViewBlur
//
//  Created by Johnil on 13-2-11.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+StackBlur.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

/*
    这里通过添加了一层视图来达到快速只截取屏幕底部像素的目的
    层级关系为 window - rootView - screenShotView - scrollView
    通过改变screenShotView的frame来进行截图,达到快速截屏,如果需要自定义其他区域,则需要截取全屏后再进行截取自定义区域
 */
- (UIImage *)blurScreenShot:(UIView *)temp{
    CGRect frame = temp.frame;
    CGPoint tempPoint = frame.origin;
    frame.origin = CGPointMake(0, (SCREEN_HEIGHT-49)*-1);
    temp.frame = frame;
    frame.origin = tempPoint;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320.0, 49.0), YES, 1);//这里通过设置scale为1来截取{320, 49}大小的图,而不是在retina下截取2x大小的图
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *screenShot1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    temp.frame = frame;
    return [screenShot1 stackBlur:3];//调用stackBlur进行模糊,因为图片本身已经很小,所以模糊半径可以设置的很小
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    screenShot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
    [self.view addSubview:screenShot];
    [screenShot release];
    scrollView = [[UIScrollView alloc] initWithFrame:screenShot.frame];
    scrollView.contentSize = CGSizeMake(0, 568*10);
    scrollView.delegate = self;
    [screenShot addSubview:scrollView];
    [scrollView release];
    
    for (int i=0; i<10; i++) {//添加测试图片
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.frame = CGRectMake(0, img.frame.size.height/2*i, img.frame.size.width/2, img.frame.size.height/2);
        [scrollView addSubview:img];
        [img release];
    }

    //添加模糊视图
    blur = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, 320.1, 49)];//解决在Retina下320宽度引起的颗粒感,可以改成320看效果对比
    [self.view addSubview:blur];
    [blur release];
    [self tick];
}

//也可以使用timer刷新的方法,满足不同需求
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self tick];
}

- (void)tick{
    blur.image = [self blurScreenShot:screenShot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
