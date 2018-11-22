//
//  CVCamera.m
//  FaceRecognizer
//
//  Created by andy.bin on 2018/11/22.
//  Copyright © 2018 Binea. All rights reserved.
//

#import "CVCamera.h"
#import "FaceDetecter.h"

using namespace cv;

@interface CVCamera () {
    
}
@property (nonatomic, strong) FaceDetecter* faceDetecter;

@end

@implementation CVCamera

- (instancetype)initWithCameraView:(UIImageView *)view scale:(CGFloat)scale {
    self = [super init];
    if (self) {
        self.videoCamera = [[CvVideoCamera alloc] initWithParentView:view];
        self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
        self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
        self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        self.videoCamera.defaultFPS = 30;
        self.videoCamera.grayscaleMode = NO;
        self.videoCamera.delegate = self;
        self.faceDetecter = [[FaceDetecter alloc] initWithScale:scale];
    }
    
    return self;
}

- (void)startCapture {
    [self.videoCamera start];
}

- (void)stopCapture; {
    [self.videoCamera stop];
}

- (void)processImage:(cv::Mat&)image {
    // Do some OpenCV stuff with the image
    NSArray* result = [self.faceDetecter detecterFrameWithMat:image];
    NSLog(@"processImage result:%@", result);
}

@end
