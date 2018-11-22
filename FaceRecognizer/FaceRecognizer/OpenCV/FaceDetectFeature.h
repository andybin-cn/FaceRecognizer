//
//  FaceDetectFeature.h
//  FaceRecognizer
//
//  Created by andy.bin on 2018/11/22.
//  Copyright © 2018 Binea. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FaceDetectFeature : NSObject
@property(assign) CGRect faceFrame;
@property(assign) CGRect leftEyeFrame;
@property(assign) CGRect rightEyeFrame;
@property(assign) CGRect noseFrame;
@property(assign) CGRect mouthFrame;
@end

NS_ASSUME_NONNULL_END
