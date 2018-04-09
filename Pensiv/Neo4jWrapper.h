//
//  Neo4jWrapper.h
//  Pensiv
//
//  Created by Myloi Mellanc on 2018. 4. 4..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//

#ifndef Neo4jWrapper_h
#define Neo4jWrapper_h

#import <Foundation/Foundation.h>

@interface Neo4jWrapper : NSObject
- (void) initWrapper;
- (bool) connect;
- (bool) createSearchPathResult:(NSString*)str1 another: (NSString*)str2;
- (NSString*) fetchNextResult;
@end


#endif /* Neo4jWrapper_h */
