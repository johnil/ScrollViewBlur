//
//  ViewController.h
//  ScrollViewBlur
//
//  Created by Johnil on 13-2-11.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate> {
    UIView *screenShot;
    UIScrollView *scrollView;
    UIImageView *blur;
}

@end
