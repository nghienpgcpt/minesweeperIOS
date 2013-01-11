//
//  UIBoxContainer.m
//  demineur
//
//  Created by Adrien Guffens on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIBoxContainer.h"

#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 460


@implementation UIBoxContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		//self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		//self.backgroundColor = [UIColor clearColor];
		//[self initScrollView];
		//[self setupRecognizer];
    }
    return self;
}

- (void)dealloc {
	
}

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)initScrollView {
	self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
	//	NSLog(@"%@", self.bounds);
	//INFO: config scroll view
	self.scrollView.delegate = self;
	self.scrollView.minimumZoomScale = 0.5;
	self.scrollView.maximumZoomScale = 2;
	self.scrollView.scrollEnabled = YES;
	self.scrollView.multipleTouchEnabled = YES;
	self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	//[ScrollView.layer setMasksToBounds:YES];
	//ScrollView.clipsToBounds = YES;
	//[self setupRecognizer];
	[self.scrollView setBackgroundColor:[UIColor orangeColor]];
	[self addSubview:self.scrollView];
}

- (void)addSubviewToScrollView:(UIView *)view {
	[self.scrollView addSubview:view];
	//[self addSubview:view];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self;
}

- (void)setupRecognizer {
    UIPanGestureRecognizer* panSwipeRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanSwipe:)];
    panSwipeRecognizer.minimumNumberOfTouches = 2;
	
    [self addGestureRecognizer:panSwipeRecognizer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

