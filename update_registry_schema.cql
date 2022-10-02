use tmg_registry;

//echo "Creating table cm_nodes..."

ALTER TABLE clusters ADD is_cluster_ready boolean;

UPDATE clusters SET is_cluster_ready=true WHERE id IN (DataCenters);

CREATE TABLE IF NOT EXISTS cm_nodes (
    id uuid,
    name varchar,
    cluster_id uuid,
    zone_id uuid,
    created timestamp,
    host_ip varchar,
    agent_port int,
    port int,
    status varchar,
    resource_bindings map<text,frozen<list<text>>>,
    client_bindings map<text,frozen<list<text>>>, 
    updated timestamp,
    PRIMARY KEY (id, cluster_id, zone_id));

CREATE INDEX IF NOT EXISTS cm_cluster_id ON cm_nodes (cluster_id);

CREATE INDEX IF NOT EXISTS cm_zone_id ON cm_nodes (zone_id);

CREATE INDEX IF NOT EXISTS cm_updated ON cm_nodes (updated);

CREATE INDEX IF NOT EXISTS cm_host_ip ON cm_nodes (host_ip);


//echo "Creating table cm_settings..."

CREATE TABLE IF NOT EXISTS cm_settings (
    id uuid,
    http_proxy text,
    sync_conf text,
    logservice_conf text,
    properties map<text,text>,
    updated timestamp,
    PRIMARY KEY (id));   

//echo "Creating table platformapi_nodes..."


CREATE TABLE IF NOT EXISTS tmg_registry.platformapi_nodes (
    id uuid,
    name varchar,
    cluster_id uuid,
    zone_id uuid,
    created timestamp,
    host_ip varchar,
    agent_port int,
    port int,
    status varchar,
    resource_bindings map<text,frozen<list<text>>>,
    client_bindings map<text,frozen<list<text>>>,    
    updated timestamp,
    PRIMARY KEY ( (id), cluster_id, zone_id) );

CREATE INDEX IF NOT EXISTS platformapi_cluster_id ON platformapi_nodes (cluster_id);

CREATE INDEX IF NOT EXISTS platformapi_zone_id ON platformapi_nodes (zone_id);

CREATE INDEX IF NOT EXISTS platformapi_updated ON platformapi_nodes (updated);

CREATE INDEX IF NOT EXISTS platformapi_host_ip ON platformapi_nodes (host_ip);


//echo "Creating table platformapi_settings..."

CREATE TABLE IF NOT EXISTS tmg_registry.platformapi_settings (
    id uuid,
    http_proxy text,
    sync_conf text,
    platformapi_conf text,
    properties map<text,text>,
    updated timestamp,
    PRIMARY KEY (id));
