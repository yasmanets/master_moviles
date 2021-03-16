//
//  CvVideoWrapper.m
//  CapturaVideoOpenCV
//
//  Created by Master Móviles on 17/11/16.
//  Copyright © 2016 Master Móviles. All rights reserved.
//

#import "CvVideoWrapper.h"

using namespace cv;


// Class extension to adopt the delegate protocol
@interface CvVideoWrapper () <CvVideoCameraDelegate>
{

}
@end

@implementation CvVideoWrapper
{
    ViewController * viewController;
    UIImageView * imageView;
    CvVideoCamera * videoCamera;
}

-(id) initWithController:(ViewController*)c andImageView:(UIImageView*)iv
{
    viewController = c;
    imageView = iv;

    self.blurValue = 1.0f;
    self.canny1Value = 50.0f;
    self.canny2Value = 100.0f;

    [self checkCameraPermissionAndInit];

    return self;
}

-(void) checkCameraPermissionAndInit
{
    NSString *mediaType = AVMediaTypeVideo;

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        [self initVideoCamera];
    }
    else if(authStatus == AVAuthorizationStatusDenied) {
        NSLog(@"Camera authorization denied!");
    }
    else if(authStatus == AVAuthorizationStatusRestricted) {
        NSLog(@"Camera authorization not allowed for user!");
    }
    else if(authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted) {
                NSLog(@"Granted access to camera");
                [self initVideoCamera];
            }
            else {
              NSLog(@"Not granted access to camera");
            }
        }];
    }
    else {
        NSLog(@"Camera unknown authorization status");
    }
}

-(void) initVideoCamera
{
    videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
    // ... set up the camera

    videoCamera.delegate = self;
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    //videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    //videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    //videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.rotateVideo = !videoCamera.rotateVideo;

    [videoCamera start];
}

-(void) processImage:(cv::Mat&)image
{

    // TODO - Procesa en tiempo real la detección de bordes usando el método de Canny
    // (realizar un suavizado de  la imagen previo a llamar al método Canny)
    // Utiliza los sliders para modificar los valores del suevizado y del filtro Canny
    cv::cvtColor(image, image, CV_RGBA2GRAY);
    cv::GaussianBlur(image, image, cv::Size(5,5), self.blurValue);
    
    cv::Mat edges;
    cv::Canny(image, edges, self.canny1Value, self.canny2Value);
    
    image.setTo(cv::Scalar::all(255));
    image.setTo(cv::Scalar(0, 128, 255, 255), edges);
}
@end
