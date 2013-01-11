//
//  GameInfoMinesweeper.h
//  minesweeper
//
//  Created by Adrien Guffens on 1/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameInfoProtocol.h"

@interface GameInfoMinesweeper : UIView

@property (nonatomic, strong) IBOutlet UIButton *stopButton;
@property (nonatomic, strong) IBOutlet UIButton *pauseButton;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UIProgressView *mineProgressView; //INFO: for the remaining mine
@property (nonatomic, strong) IBOutlet UIProgressView *boxProgressView;//INFO: for the remaining box

@property (nonatomic, strong) id<GameInfoProtocol> delegate;

- (void)updateTimer;

@end
