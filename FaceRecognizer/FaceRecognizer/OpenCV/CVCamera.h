//
//  CVCamera.h
//  FaceRecognizer
//
//  Created by andy.bin on 2018/11/22.
//  Copyright © 2018 Binea. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CVCamera : NSObject


- (instancetype)initWithCameraView:(UIView *)view scale:(CGFloat)scale;

- (void)startCapture;
- (void)stopCapture;
@end

NS_ASSUME_NONNULL_END
