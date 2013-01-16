//
//  ScoreRecord.h
//  minesweeper
//
//  Created by Adrien Guffens on 1/16/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ScoreRecord : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * size;

@end
