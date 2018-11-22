//
//  FaceDetecter.h
//  FaceRecognizer
//
//  Created by andy.bin on 2018/11/22.
//  Copyright © 2018 Binea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceDetectFeature.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaceDetecter : NSObject

-(NSArray<FaceDetectFeature*>*)detecterFrameWithMat:(cv::Mat&)frame;
-(NSArray<FaceDetectFeature*>*)detecterFrameWithImage:(UIImage*)image;

@end

NS_ASSUME_NONNULL_END
