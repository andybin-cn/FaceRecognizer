//
//  UIImage+OpenCV.h
//  FaceRecognizer
//
//  Created by binea on 2018/11/26.
//  Copyright © 2018 Binea. All rights reserved.
//

#ifdef __cplusplus
#undef NO
#undef YES
#import <opencv2/opencv.hpp>
#endif
#import <UIKit/UIKit.h>


@interface UIImage (OpenCV)

+ (UIImage *)imageFromCVMat:(cv::Mat)mat;

- (cv::Mat)cvMatRepresentationColor;
- (cv::Mat)cvMatRepresentationGray;

@end
