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
- (bool) runQuery: (NSString*) query;
- (bool) fetchNext;
- (NSString*) fetchString;
- (int) fetchCount;
- (void) disconnect;
@end


#endif /* Neo4jWrapper_h */
