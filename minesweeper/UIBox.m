//
//  UIBox.m
//  demineur
//
//  Created by Adrien Guffens on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/CALayer.h>
#import "UIBox.h"
#import "BoxAnnotation.h"
#import "GraphicTools.h"

#import "MinesweeperAppDelegate.h"

#import "Global.h"
//#import "OptionManager.h"

#define FONT_SIZE 16.0f
#define BLOCK_NUMBER 3

@implementation UIBox

- (id)initWithFrame:(CGRect)frame boxAnnotation:(BoxAnnotation *)boxAnnotation andDelegate:(id<BoxProtocol>)delegate {
	
	self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		if (!boxAnnotation)
			return self;
		
		self.annotation = boxAnnotation;
		self.delegate = delegate;
		
		self.backgroundColor = [UIColor clearColor];
		self.multipleTouchEnabled = NO;
		
		self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
		self.textLabel.minimumFontSize = FONT_SIZE;
		self.textLabel.numberOfLines = 0;
		self.textLabel.font = [UIFont systemFontOfSize:(CGFloat)FONT_SIZE];
		self.textLabel.textColor = [UIColor blackColor];
		self.textLabel.textAlignment = UITextAlignmentCenter;
		
		[self.textLabel.layer setMasksToBounds:YES];
		
		[self addSubview:self.textLabel];
		
		[GraphicTools addBorderToView:self withBorderRaduis:4.0f];
		
		[self setupRecognizer];
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
	//	if (backgroundImage)
		[self setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
		
}

- (void)setupRecognizer {
	
	UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self addGestureRecognizer:gestureRecognizer];
	
	//TODO: change swipe by long touch [OK]
	//INFO: old way to put a bomb
	/*
	 UIPanGestureRecognizer* panSwipeRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanSwipe:)];
	 panSwipeRecognizer.minimumNumberOfTouches = 1;
	 panSwipeRecognizer.maximumNumberOfTouches = 1;
	 
	 [self addGestureRecognizer:panSwipeRecognizer];
	 */
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)guestureRecognizer
{
    if (guestureRecognizer.state == UIGestureRecognizerStateBegan) {
		/*
		if (self.annotation.selected == YES)
			return;

		if (isMooving == YES) {
			//if ([AppDelegate getAppData].OptionManager.IsMooving == YES) {
			self.center = self.initialCenter;
			self.layer.opacity = 1;
			
			return;
		}
		self.layer.opacity = 0;
		*/
	}
	if (guestureRecognizer.state == UIGestureRecognizerStateEnded) {
		//self.annotation.type = flag;
		self.annotation.flagged = YES;
		self.annotation.selected = YES;
		[self updateBox];
	}
	
}


- (void)updateBox {
	self.textLabel.text = self.annotation.value;
	self.annotation.selected = YES;
#warning set background image incomplete
	
	UIColor *color = nil;
	switch (self.annotation.type) {
			//TODO: for each case set an image already loaded in memory
		case bomb:
			if (self.annotation.flagged == YES)
				[self setBackgroundImage:flagImage];//TODO: flag image
			else
				[self setBackgroundImage:bombImage];
			break;
		case noBomb:
			if (self.annotation.flagged == YES)
				[self setBackgroundImage:flagImage];//TODO: flag image
			else
				[self setBackgroundImage:emptyImage];
			break;
		case empty:
			if (self.annotation.flagged == YES)
				[self setBackgroundImage:flagImage];//TODO: flag image
			else
				[self setBackgroundImage:emptyAutoImage];
			break;
		default:
			break;
	}
	//self.backgroundColor = color;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([self.delegate respondsToSelector:@selector(didSelectBox:)]) {
		//TODO: number count bomb towards the selected box
		
		BOOL result = (BOOL)[self.delegate performSelector:@selector(didSelectBox:) withObject:self.annotation];
		
		NSLog(@"bombNumber: %@ %@", (result == YES ? @"No Bomb !" : @"Bomb !"), self.annotation);
	}
}

- (void)handlePanSwipe:(UIPanGestureRecognizer*)recognizer {
	
	if (self.annotation.selected == YES)
		return;
	
	
	static DirectionType direction;
	static float distance;
	//static CGPoint initialCenter;
    
	CGPoint t = [recognizer translationInView:recognizer.view];
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
	
	if (recognizer.state == UIGestureRecognizerStateBegan)
    {
		[self bringSubviewToFront:self];
		if (ABS(t.x) < ABS(t.y)) {
			direction = horizontal;
			distance = t.x;
		} else {
			direction = vertical;
			distance = t.y;
		}
		self.InitialCenter = self.center;
	}
	
	
	//
	//	usleep(1000);
	if (isMooving == YES) {
		//if ([AppDelegate getAppData].OptionManager.IsMooving == YES) {
		self.center = self.initialCenter;
		self.layer.opacity = 1;
		
		return;
	}
	//
	
	
	if (direction == horizontal) {
		self.center = CGPointMake(self.center.x, self.center.y + t.y);
		distance += t.y;
	} else {
		self.center = CGPointMake(self.center.x  + t.x, self.center.y);
		distance += t.x;
	}
	
	float value = (ABS(distance) / (BLOCK_NUMBER * (direction == NO ? self.annotation.width : self.annotation.height)));
	
	self.layer.opacity = 1 - value;
	
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
		if (value >= 1)
			self.layer.opacity = 0;
		else {
			self.center = self.initialCenter;
			self.layer.opacity = 1;
		}
    }
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
