//
//  Neo4jWrapper.mm
//  Pensiv
//
//  Created by Myloi Mellanc on 2018. 4. 4..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//

#import "Neo4jWrapper.h"
#include "Neo4jManager.hpp"

@interface Neo4jWrapper()
//@property Neo4jManager* neo4jManager;
@end


@implementation Neo4jWrapper
- (void) initWrapper
{
    Neo4jManager::getInstance()->initNeo4j();
}

- (bool) connect
{
    return Neo4jManager::getInstance()->connectClient();
}

- (bool) runQuery: (NSString*) query
{
    return Neo4jManager::getInstance()->runQuery([query UTF8String]);
}

- (NSString*) fetchNextResult
{
    const char* str = Neo4jManager::getInstance()->fetchNextResult();
    if (str != NULL)
    {
        return [[NSString alloc] initWithUTF8String:str];
    }
    
    
    return NULL;
}

- (void) disconnect
{
    Neo4jManager::getInstance()->disconnect();
}

@end





