//
//  Neo4jManager.cpp
//  Pensiv
//
//  Created by Myloi Mellanc on 2018. 4. 4..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//

#include "Neo4jManager.hpp"

Neo4jManager* Neo4jManager::_pInstance = nullptr;


Neo4jManager* Neo4jManager::getInstance()
{
    if (_pInstance == nullptr)
        _pInstance = new Neo4jManager();
    
    return _pInstance;
}

Neo4jManager::Neo4jManager()
{
    
}

Neo4jManager::~Neo4jManager()
{
    
}


void Neo4jManager::initNeo4j()
{
    neo4j_client_init();
}

bool Neo4jManager::connectClient()
{
    _connection = neo4j_connect("neo4j://neo4j:flrndnqk23@localhost:7687", NULL, NEO4J_INSECURE);
    if(_connection == NULL)
        return false;
    
    return true;
}

bool Neo4jManager::createSearchPathResult(const char* str1, const char* str2)
{
    _results = neo4j_run(_connection, " ", neo4j_null);
    
    if(_results == NULL)
        return false;
    
    return true;
}

const char* Neo4jManager::fetchNextResult()
{
    neo4j_result* result = neo4j_fetch_next(_results);
    if (result != NULL)
    {
        neo4j_value_t value = neo4j_result_field(result, 0);
        
        const char* str = neo4j_ustring_value(value);
        
        return str;
    }
    
    return NULL;
}

/*
 neo4j_client_init();
 
 neo4j_connection_t* connection = neo4j_connect("neo4j://neo4j:flrndnqk23@localhost:7687", NULL, NEO4J_INSECURE);
 
 if (connection == NULL)
 {
 neo4j_perror(stderr, errno, "Connection failed");
 return EXIT_FAILURE;
 }
 
 neo4j_result_stream_t *results =
 neo4j_run(connection, "MATCH (a)-[]-(b) WHERE a.Name = 'ㄱ' RETURN b.Name", neo4j_null);
 if (results == NULL)
 {
 neo4j_perror(stderr, errno, "Failed to run statement");
 return EXIT_FAILURE;
 }
 
 
 neo4j_result_t *result = neo4j_fetch_next(results);
 while(result != NULL)
 {
 neo4j_value_t value = neo4j_result_field(result, 0);
 char buf[128];
 printf("%s\n", neo4j_tostring(value, buf, sizeof(buf)));
 
 
 result = neo4j_fetch_next(results);
 }
 
 if (result == NULL)
 {
 neo4j_perror(stderr, errno, "Failed to fetch result");
 return EXIT_FAILURE;
 }
 





neo4j_close_results(results);
neo4j_close(connection);
neo4j_client_cleanup();
return EXIT_SUCCESS;*/
