//
//  ScoreRecordDataController.h
//  minesweeper
//
//  Created by Adrien Guffens on 1/16/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreRecord.h"

@interface ScoreRecordDataController : NSObject

- (unsigned)countOfList;
- (ScoreRecord *)objectInListAtIndex:(unsigned)theIndex;
- (void)addScoreRecord:(ScoreRecord *)scoreRecord;
- (void)insertScoreRecord:(ScoreRecord *)scoreRecord atIndex:(NSUInteger)index;
- (void)removeScoreRecordAtIndex:(NSUInteger)theIndex;

@end
