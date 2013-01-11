//
//  GraphicTools.h
//  demineur
//
//  Created by Adrien Guffens on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphicTools : NSObject

+ (void)addBorderToLayer:(CALayer *)layer withBorderRaduis:(float)radius;
+ (void)addBorderToView:(UIView *)view withBorderRaduis:(float)radius;
+ (void)addBorderToView:(UIView *)view andSubviews:(BOOL)subviewEnable withBorderRaduis:(float)radius;
@end
