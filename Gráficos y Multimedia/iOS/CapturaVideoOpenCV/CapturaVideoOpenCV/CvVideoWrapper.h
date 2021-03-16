//
//  CvVideoWrapper.h
//  CapturaVideoOpenCV
//
//  Created by Master Móviles on 17/11/16.
//  Copyright © 2016 Master Móviles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Need this ifdef, so the C++ header won't confuse Swift
#ifdef __cplusplus
    #import <opencv2/opencv.hpp>
    #import "opencv2/highgui/ios.h"
    #import <opencv2/highgui/cap_ios.h>
#endif

// This is a forward declaration; we cannot include *-Swift.h in a header.
@class ViewController;

@interface CvVideoWrapper : NSObject

    @property (nonatomic) float blurValue;
    @property (nonatomic) float canny1Value;
    @property (nonatomic) float canny2Value;

    -(id)initWithController:(ViewController*)c andImageView:(UIImageView*)iv;

@end
