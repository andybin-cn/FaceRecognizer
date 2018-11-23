//
//  FaceDetecter.h
//  FaceRecognizer
//
//  Created by andy.bin on 2018/11/22.
//  Copyright © 2018 Binea. All rights reserved.
//

#ifdef __cplusplus
#undef NO
#undef YES
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#endif

#import <Foundation/Foundation.h>
#import "FaceDetectFeature.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaceDetecter : NSObject

- (instancetype)initWithScale:(CGFloat)scale;
-(NSArray<FaceDetectFeature*>*)detecterFrameWithMat:(cv::Mat&)frame;
-(NSArray<FaceDetectFeature*>*)detecterFrameWithImage:(UIImage*)image;

@end

NS_ASSUME_NONNULL_END
