
#import "RNCoreImage.h"
@import UIKit;
@import Accelerate;

@implementation RNCoreImage

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(processBlurredImage:(NSString*)uri blurRadius:(CGFloat)blurRadius callback:(RCTResponseSenderBlock)callback)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *image = [UIImage imageWithContentsOfFile:[uri stringByReplacingOccurrencesOfString:@"file://" withString:@""]];
        UIImage *downSizedImage = [self scaleImage:image toSize:CGSizeMake(image.size.width * 0.5f, image.size.height * 0.5f)];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *inputImage = [CIImage imageWithCGImage:downSizedImage.CGImage];
        
        CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
        [clampFilter setValue:inputImage forKey:kCIInputImageKey];
        CIImage *result = [clampFilter valueForKey:kCIOutputImageKey];
        
        CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [blurFilter setValue:result forKey:kCIInputImageKey];
        [blurFilter setValue:[NSNumber numberWithFloat:blurRadius] forKey:@"inputRadius"];
        result = [blurFilter valueForKey:kCIOutputImageKey];
        
        /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
         *  up exactly to the bounds of our original image */
        CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
        
        UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:0.5f orientation:downSizedImage.imageOrientation];
        
        CGImageRelease(cgImage);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filename = [NSString stringWithFormat:@"blurred_%li.png", (long)[[NSNumber numberWithFloat:blurRadius] integerValue]];
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
        
        // Save image.
        [UIImagePNGRepresentation(newImage) writeToFile:filePath atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(@[[NSNull null], filePath]);
        });
    });
}

RCT_EXPORT_METHOD(processGreyscaleImage:(NSString*)uri callback:(RCTResponseSenderBlock)callback)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *image = [UIImage imageWithContentsOfFile:[uri stringByReplacingOccurrencesOfString:@"file://" withString:@""]];
        
        CIImage *beginImage = [CIImage imageWithCGImage:image.CGImage];
        
        CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
        CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", [NSNumber numberWithFloat:0.0], nil].outputImage;
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
        //UIImage *newImage = [UIImage imageWithCGImage:cgiimage];
        UIImage *newImage = [UIImage imageWithCGImage:cgiimage scale:image.scale orientation:image.imageOrientation];
        CGImageRelease(cgiimage);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"greyscale.png"];
        
        // Save image.
        [UIImagePNGRepresentation(newImage) writeToFile:filePath atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(@[[NSNull null], filePath]);
        });
    });
}

RCT_EXPORT_METHOD(processBlurredGreyscaleImage:(NSString*)uri callback:(RCTResponseSenderBlock)callback)
{
    [self processGreyscaleImage:uri callback:^(NSArray *response) {
        [self processBlurredImage:response[1] blurRadius:50.0f callback:^(NSArray *response) {
            callback(response);
        }];
    }];
}

- (UIImage *)scaleImage:(UIImage *)originalImage toSize:(CGSize)size
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    if (originalImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -size.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), originalImage.CGImage);
    } else {
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), originalImage.CGImage);
    }
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(context);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UIImage *image = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    
    return image;
}

@end
  