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
	
	self.pauseImage = [UIImage imageNamed:@"pause-icon.png"];
	self.playImage = [UIImage imageNamed:@"play-icon.png"];

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
			if ([self.delegate handlePause]) {
				self.isPause = YES;
				[self.pauseButton setImage: self.playImage forState:UIControlStateNormal];
			}

	}
	else {
		if ([self.delegate respondsToSelector:@selector(handleStart)])
			if ([self.delegate handleStart]) {
				self.isPause = NO;
				[self.pauseButton setImage:self.pauseImage forState:UIControlStateNormal];
			}
	}
	
}

- (void)handleStop:(id)sender {
	if ([self.delegate respondsToSelector:@selector(handleStop)])
		if ([self.delegate handleStop]) {
			//INFO: do more stuff if needed
		}
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

- (void)updateInfoWithBox:(UIBox *)box {
	switch (box.annotation.type) {
		case bomb:
			if (box.annotation.flagged == YES)
				//TODO: flag image
				//else
				//[self setBackgroundImage:bombImage];

			//INFO: lost
			break;
		case noBomb:
			//INFO: continue to play there is no bomb
			break;
		case empty:
			//INFO: auto discovered box
			break;
			//case flag:
			///			box.annotation.flagged
			//INFO: flagged
			break;
		default:
			break;
	}
}

- (void)setTotalBombNumber:(int)totalBombNumber {
	//TODO: update UI
	_totalBombNumber = totalBombNumber;
}

- (void)setTotalEmptyCaseNumber:(int)totalEmptyCaseNumber {
	//TODO: update UI
	_totalEmptyCaseNumber = totalEmptyCaseNumber;
}


@end
