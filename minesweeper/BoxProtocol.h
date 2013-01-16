//
//  BoxProtocol.h
//  demineur
//
//  Created by Adrien Guffens on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BoxAnnotation;
@class UIBox;

@protocol BoxProtocol <NSObject>
- (BOOL)didSelectBox:(BoxAnnotation *)boxAnnotation;
- (void)didPushFlag:(UIBox *)box;

@end
