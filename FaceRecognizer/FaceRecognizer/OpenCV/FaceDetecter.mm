//
//  FaceDetecter.m
//  FaceRecognizer
//
//  Created by andy.bin on 2018/11/22.
//  Copyright © 2018 Binea. All rights reserved.
//
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#endif

#import "FaceDetecter.h"


using namespace cv;

@interface FaceDetecter () {
    
    CascadeClassifier _faceDetector;
    CascadeClassifier _eyeDetector;
    
    std::vector<cv::Rect> _faceRects;
    std::vector<cv::Mat> _faceImgs;
    
}
@end

@implementation FaceDetecter

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt2"
                                                                    ofType:@"xml"];
        
        const CFIndex CASCADE_NAME_LEN = 2048;
        char *CASCADE_NAME = (char *) malloc(CASCADE_NAME_LEN);
        CFStringGetFileSystemRepresentation( (CFStringRef)faceCascadePath, CASCADE_NAME, CASCADE_NAME_LEN);
        
        _faceDetector.load(CASCADE_NAME);
        
        free(CASCADE_NAME);
        
        
        
        NSString *eyesCascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_eye_tree_eyeglasses"
                                                                    ofType:@"xml"];

        CFStringGetFileSystemRepresentation( (CFStringRef)eyesCascadePath, CASCADE_NAME, CASCADE_NAME_LEN);

        _eyeDetector.load(CASCADE_NAME);
        free(CASCADE_NAME);
    }
    
    return self;
}

-(NSArray<FaceDetectFeature*>*)detecterFrameWithMat:(cv::Mat&)frame
{
    NSMutableArray<FaceDetectFeature*>* array = [NSMutableArray arrayWithCapacity:1];
    double scale = 1;
    int i = 0;
    double t = 0;
    
    const static Scalar colors[] =  { CV_RGB(0,0,255),
        CV_RGB(0,128,255),
        CV_RGB(0,255,255),
        CV_RGB(0,255,0),
        CV_RGB(255,128,0),
        CV_RGB(255,255,0),
        CV_RGB(255,0,0),
        CV_RGB(255,0,255)} ;
    Mat gray, smallImg( cvRound (frame.rows/scale), cvRound(frame.cols/scale), CV_8UC1 );
    
    cvtColor( frame, gray, COLOR_BGR2GRAY );
    resize( gray, smallImg, smallImg.size(), 0, 0, INTER_LINEAR );
    equalizeHist( smallImg, smallImg );
    
    
    
    t = (double)cvGetTickCount();
    double scalingFactor = 1.1;
    int minRects = 2;
    cv::Size minSize(30,30);
    std::vector<cv::Rect> faces;
    
    self->_faceDetector.detectMultiScale( smallImg, faces,
                                         scalingFactor, minRects, 0,
                                         minSize );
    
    t = (double)cvGetTickCount() - t;
    //    printf( "detection time = %g ms\n", t/((double)cvGetTickFrequency()*1000.) );
    std::vector<cv::Mat> faceImages;
    
    for (std::vector<cv::Rect>::const_iterator faceRect = faces.begin(); faceRect != faces.end(); faceRect++ )
    {
        FaceDetectFeature* faceFeature = [[FaceDetectFeature alloc] init];
        faceFeature.faceFrame = CGRectMake(faceRect->x, faceRect->y, faceRect->width, faceRect->height);
        
        cv::Mat smallImgROI = smallImg(*faceRect);
        cv::Point center;
        Scalar color = colors[i%8];
        std::vector<cv::Rect> nestedObjects;
        self->_eyeDetector.detectMultiScale( smallImgROI, nestedObjects,
                                            1.1, 2, 0,
                                            cv::Size(5, 5) );
        if(nestedObjects.size() != 2) {
            break;
        }
        CGRect eye1 = CGRectMake(nestedObjects[0].x, nestedObjects[0].y, nestedObjects[0].width, nestedObjects[0].height);
        CGRect eye2 = CGRectMake(nestedObjects[1].x, nestedObjects[1].y, nestedObjects[1].width, nestedObjects[1].height);
        if(eye1.origin.x < eye2.origin.x) {
            faceFeature.leftEyeFrame = eye1;
            faceFeature.rightEyeFrame = eye2;
        } else {
            faceFeature.leftEyeFrame = eye2;
            faceFeature.rightEyeFrame = eye1;
        }
        [array addObject:faceFeature];
    }
    return array;
}

-(NSArray<FaceDetectFeature*>*)detecterFrameWithImage:(UIImage*)image
{
    Mat frame;
    UIImageToMat(image, frame);
    return [self detecterFrameWithMat:frame];
}

@end