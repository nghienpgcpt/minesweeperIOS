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
@property (nonatomic, assign)int discoveredBoxNumber;
@property (nonatomic, assign)int secondsElapsed;

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
	[self setup];
}

- (void)setup {
	self.isPause = NO;
	self.secondsElapsed = 0;
	self.discoveredBoxNumber = 0;
	self.discoveredFlagNumber = 0;
	[self updateProgress];
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
	
	self.secondsElapsed += 1;
	int forHours = self.secondsElapsed / 3600;
	int remainder = self.secondsElapsed % 3600;
	int forMinutes = remainder / 60;
	int forSeconds = remainder % 60;
	
	if (forHours > 0)
		self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", forHours, forMinutes, forSeconds];
	else
		self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", forMinutes, forSeconds];
}

- (void)updateProgress {
	
	self.boxProgressView.progress = self.discoveredBoxNumber / self.totalBoxNumber;

	self.flagProgressView.progress = self.discoveredFlagNumber / self.totalBombNumber;

	//INFO: did win
	if (self.totalBombNumber != 0 &&
		self.discoveredBoxNumber == self.totalBoxNumber &&
		self.discoveredFlagNumber == self.totalBombNumber) {
		if ([self.delegate respondsToSelector:@selector(didWinWithTimeInSeconds:)]) {
			[self.delegate didWinWithTimeInSeconds:self.secondsElapsed];
		}
	}
}

- (void)updateInfoWithBox:(UIBox *)box {

	if (box.annotation.flagged == YES) {
		[self updateProgress];
	}
	else {
		self.discoveredBoxNumber++;
		[self updateProgress];
		if (box.annotation.type == bomb) {
			if ([self.delegate respondsToSelector:@selector(didLostWithTimeInSeconds:)]) {
				[self.delegate didLostWithTimeInSeconds:self.secondsElapsed];
			}
		}
	}
}

- (void)setTotalBombNumber:(float)totalBombNumber {
	//TODO: update UI
	_totalBombNumber = totalBombNumber;
}

- (void)setTotalBoxNumber:(float)totalBoxNumber {
	//TODO: update UI
	_totalBoxNumber = totalBoxNumber;
}

- (void)setDiscoveredFlagNumber:(float)discoveredFlagNumber {
	if (discoveredFlagNumber != 0)
		_discoveredBoxNumber += (discoveredFlagNumber > _discoveredFlagNumber ? 1 : -1);
	_discoveredFlagNumber = discoveredFlagNumber;

}


@end
