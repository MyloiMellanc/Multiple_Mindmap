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
    //self.neo4jManager->initNeo4j();
    Neo4jManager::getInstance()->initNeo4j();
}
- (bool) connect
{
    //return self.neo4jManager->connectClient();
    return Neo4jManager::getInstance()->connectClient();
}
- (bool) createSearchPathResult: (NSString*) str1 another: (NSString*)str2;
{
    //return self.neo4jManager->createSearchPathResult([str1 UTF8String], [str2 UTF8String]);
    return Neo4jManager::getInstance()->createSearchPathResult([str1 UTF8String], [str2 UTF8String]);
}
- (NSString*) fetchNextResult
{
    //const char* str = self.neo4jManager->fetchNextResult();
    const char* str = Neo4jManager::getInstance()->fetchNextResult();
    if (str != NULL)
    {
        return [[NSString alloc] initWithUTF8String:str];
    }
    
    
    return NULL;
}

@end





