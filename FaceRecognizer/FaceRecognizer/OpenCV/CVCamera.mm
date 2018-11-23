//
//  CVCamera.m
//  FaceRecognizer
//
//  Created by andy.bin on 2018/11/22.
//  Copyright © 2018 Binea. All rights reserved.
//
#ifdef __cplusplus
#import <opencv2/videoio/cap_ios.h>
#endif
#import "FaceDetecter.h"
#import "CVCamera.h"

using namespace cv;

@interface CVCamera () <CvVideoCameraDelegate> {
    int _processCount;
}
@property (nonatomic, strong) FaceDetecter* faceDetecter;
@property (nonatomic, strong) CvVideoCamera* videoCamera;
@property (nonatomic, strong) CAShapeLayer* faceLayer;
@property (nonatomic, strong) UIView* faceMaskView;
@end

@implementation CVCamera

- (instancetype)initWithCameraView:(UIView *)view scale:(CGFloat)scale {
    self = [super init];
    if (self) {
        self.videoCamera = [[CvVideoCamera alloc] initWithParentView:view];
        self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
        self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
        self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        self.videoCamera.defaultFPS = 30;
        self.videoCamera.grayscaleMode = false;
        self.videoCamera.delegate = self;
        self.faceDetecter = [[FaceDetecter alloc] initWithScale:scale];
        
//        self.faceMaskView = [[UIView alloc] initWithFrame:view.bounds];
//        self.faceMaskView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
//        [view addSubview:self.faceMaskView];
    }
    
    return self;
}

- (void)startCapture {
    [self.videoCamera start];
    [self.faceLayer removeFromSuperlayer];
    self.faceLayer = [[CAShapeLayer alloc] init];
    self.faceLayer.frame = self.videoCamera.parentView.bounds;
    self.faceLayer.strokeColor = [UIColor redColor].CGColor;
    self.faceLayer.lineWidth = 1;
    self.faceLayer.fillColor = [UIColor clearColor].CGColor;
    [self.videoCamera.parentView.layer addSublayer:self.faceLayer];
}

- (void)stopCapture {
    [self.videoCamera stop];
}

- (void)processImage:(cv::Mat&)image {
    // Do some OpenCV stuff with the image
    if(_processCount % 5 == 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray* result = [self.faceDetecter detecterFrameWithMat:image];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showFaceFrames:result];
            });
        });
        _processCount = 0;
    }
    _processCount++;
}

-(void) showFaceFrames:(NSArray<FaceDetectFeature*>*)result {
    UIBezierPath *facesFramePath = [[UIBezierPath alloc] init];
    CGFloat scale = self.videoCamera.parentView.frame.size.width / 480;
//    CGFloat heightScale = self.videoCamera.parentView.frame.size.width / 480;
    for (FaceDetectFeature *faceFrame in result) {
        CGRect imageRect = CGRectMake(faceFrame.faceFrame.origin.x * scale , faceFrame.faceFrame.origin.y * scale, faceFrame.faceFrame.size.width * scale, faceFrame.faceFrame.size.height * scale);
        NSLog(@"showFaceFrames result:%@", NSStringFromCGRect(faceFrame.faceFrame));
        NSLog(@"showFaceFrames result scale:%@", NSStringFromCGRect(imageRect));
        UIBezierPath *facePath = [UIBezierPath bezierPathWithRect:imageRect];
        
        [facesFramePath appendPath:facePath];
        if(!CGRectIsNull(faceFrame.leftEyeFrame)) {
            [facesFramePath appendPath: [UIBezierPath bezierPathWithRect:faceFrame.leftEyeFrame]];
        }
        if(!CGRectIsNull(faceFrame.rightEyeFrame)) {
            [facesFramePath appendPath: [UIBezierPath bezierPathWithRect:faceFrame.rightEyeFrame]];
        }
    }
    self.faceLayer.path = facesFramePath.CGPath;
}

@end
