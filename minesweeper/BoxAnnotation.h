//
//  BoxAnnotation.h
//  demineur
//
//  Created by Adrien Guffens on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum BoxAnnotationType {
	bomb,
	noBomb,
	empty
	//flag
} BoxAnnotationType;

@interface BoxAnnotation : NSObject

@property(nonatomic, assign)NSString *value;
@property(nonatomic, assign)NSInteger x;
@property(nonatomic, assign)NSInteger y;
@property(nonatomic, assign)float width;
@property(nonatomic, assign)float height;
@property(nonatomic, assign)BoxAnnotationType type;
@property(nonatomic, assign)BOOL selected;
@property(nonatomic, assign)BOOL flagged;

@end
