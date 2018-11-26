//
//  CVFaceRecognizer.h
//  FaceRecognizer
//
//  Created by binea on 2018/11/26.
//  Copyright © 2018 Binea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CVFaceRecognizer : NSObject

+ (CVFaceRecognizer *)faceRecognizerWithFile:(NSString *)path;

- (BOOL)serializeFaceRecognizerParamatersToFile:(NSString *)path;

- (NSString *)predict:(UIImage*)img confidence:(double *)confidence;

- (void)updateWithFace:(UIImage *)img name:(NSString *)name;

- (NSArray *)labels;

@end

NS_ASSUME_NONNULL_END
