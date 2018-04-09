//
//  Neo4jManager.hpp
//  Pensiv
//
//  Created by Myloi Mellanc on 2018. 4. 4..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//

#ifndef Neo4jManager_hpp
#define Neo4jManager_hpp


#include <neo4j-client.h>
#include <errno.h>


class Neo4jManager
{
public:
    static Neo4jManager* getInstance();
    
    void initNeo4j();
    bool connectClient();
    
    bool createSearchPathResult(const char* str1, const char* str2);
    
    const char* fetchNextResult();
    
    ~Neo4jManager();
    
private:
    Neo4jManager();
    
private:
    static Neo4jManager* _pInstance;
    
    neo4j_connection_t* _connection;
    
    neo4j_result_stream_t* _results;
};



#endif /* Neo4jManager_hpp */
