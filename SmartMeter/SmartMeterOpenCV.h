//
//  SmartMeterOpenCV.h
//  SmartMeter
//
//  Created by Richard Yip on 5/1/17.
//  Copyright © 2017 Richard Yip. All rights reserved.
//

#ifndef SmartMeterOpenCV_h
#define SmartMeterOpenCV_h
#import <UIKit/UIKit.h>

@interface SmartMeterOpenCV : NSObject

- (void) grayImage:(UIImage*) src;
- (UIImage*) grayImage;
- (float) detectSkew;
- (void) rotate:(float) rotationDegrees;


- (UIImage*) processImage:(UIImage*) src;
- (NSString*) OCRImage:(UIImage*)src;

@end


#endif /* SmartMeterOpenCV_h */
