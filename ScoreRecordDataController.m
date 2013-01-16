//
//  ScoreRecordDataController.m
//  minesweeper
//
//  Created by Adrien Guffens on 1/16/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "ScoreRecordDataController.h"

@interface ScoreRecordDataController ()

@property (nonatomic, copy) NSMutableArray *masterScoreRecordList;

@end

@implementation ScoreRecordDataController


- (id)init {
    if (self = [super init]) {
		
        _masterScoreRecordList = [[NSMutableArray alloc] init];
		
        return self;
    }
    return nil;
}

- (unsigned)countOfList {
    return [self.masterScoreRecordList count];
}

- (ScoreRecord *)objectInListAtIndex:(unsigned)theIndex
{
    return self.masterScoreRecordList[theIndex];
}

- (void)addScoreRecord:(ScoreRecord *)scoreRecord
{
    [self.masterScoreRecordList addObject:scoreRecord];
}

- (void)insertScoreRecord:(ScoreRecord *)scoreRecord atIndex:(NSUInteger)index
{
    [self.masterScoreRecordList insertObject:scoreRecord atIndex:index];
}

- (void)removeScoreRecordAtIndex:(NSUInteger)theIndex
{
    [self.masterScoreRecordList removeObjectAtIndex:theIndex];
}
 

@end