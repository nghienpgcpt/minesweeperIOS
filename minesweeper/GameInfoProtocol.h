//
//  GameInfoProtocol.h
//  minesweeper
//
//  Created by Adrien Guffens on 1/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameInfoProtocol <NSObject>

- (void)handlePause;
- (void)handleStart;
- (void)handleStop;

@end
