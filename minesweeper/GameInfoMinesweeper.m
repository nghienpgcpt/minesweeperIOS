//
//  GameInfoMinesweeper.m
//  minesweeper
//
//  Created by Adrien Guffens on 1/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "GameInfoMinesweeper.h"

@interface GameInfoMinesweeper ()

@property (nonatomic, assign)BOOL isPause;

@end

@implementation GameInfoMinesweeper

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib {
	[super awakeFromNib];

	[self.pauseButton addTarget:self action:@selector(handlePause:)
							forControlEvents:UIControlEventTouchUpInside];
	[self.stopButton addTarget:self action:@selector(handleStop:)
						   forControlEvents:UIControlEventTouchUpInside];
	
	self.isPause = NO;
}

#pragma mark - handle

- (void)handlePause:(id)sender {
	if (self.isPause == NO) {
		if ([self.delegate respondsToSelector:@selector(handlePause)])
			//dispatch_async(dispatch_get_main_queue(), ^{
				[self.delegate handlePause];
		//});
			self.isPause = YES;
	}
	else {
		if ([self.delegate respondsToSelector:@selector(handleStart)])
			//dispatch_async(dispatch_get_main_queue(), ^{
				[self.delegate handleStart];
				//});
		
		self.isPause = NO;
	}
	
}

- (void)handleStop:(id)sender {
	if ([self.delegate respondsToSelector:@selector(handleStop)])
		//dispatch_async(dispatch_get_main_queue(), ^{
			[self.delegate handleStop];
	//});
}

#pragma mark - logic

- (void)updateTimer {
	static int secondsElapsed;
	
	secondsElapsed += 1;
	int forHours = secondsElapsed / 3600;
	int remainder = secondsElapsed % 3600;
	int forMinutes = remainder / 60;
	int forSeconds = remainder % 60;
	
	//dispatch_async(dispatch_get_main_queue(), ^{
		if (forHours > 0)
			self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", forHours, forMinutes, forSeconds];
		else
			self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", forMinutes, forSeconds];
	//});
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
