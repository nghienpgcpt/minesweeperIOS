//
//  GraphicTools.m
//  demineur
//
//  Created by Adrien Guffens on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GraphicTools.h"

@implementation GraphicTools

#pragma mark - border

+ (void)addBorderToLayer:(CALayer *)layer withBorderRaduis:(float)radius {
	//layer.masksToBounds = YES;
	
	//[layer setCornerRadius:radius];//2
	[layer setBorderColor:[UIColor lightGrayColor].CGColor];
	[layer setBorderWidth:1.0f];
	//[layer setShadowColor:[UIColor blackColor].CGColor];
	//[layer setShadowOpacity:0.6f];
	//[layer setShadowRadius:radius];//(radius == 0.0f ? 1.0f : radius) * 2.0f];
	//[layer setShadowOffset:CGSizeMake(radius / 4, radius / 4)];
}

+ (void)addBorderToView:(UIView *)view withBorderRaduis:(float)radius {
	//view.clipsToBounds = YES;
	
	[GraphicTools addBorderToLayer:view.layer withBorderRaduis:radius];
}

+ (void)addBorderToView:(UIView *)view andSubviews:(BOOL)subviewEnable withBorderRaduis:(float)radius {
	[GraphicTools addBorderToLayer:view.layer withBorderRaduis:radius];
	
	if (subviewEnable) {
		for (UIView *subview in [view subviews]) {
			[GraphicTools addBorderToView:subview withBorderRaduis:radius];
		}
	}
}

@end
