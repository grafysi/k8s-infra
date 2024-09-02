docker run \
    --name neo4j-sv1 \
    --restart always \
    --network ipvlan_net \
    --env NEO4J_AUTH=neo4j/abcd1234 \
    --env NEO4J_ACCEPT_LICENSE_AGREEMENT=yes \
    --volume=$HOME/.grafysi/neo4j-volume/data:/data \
    --volume=$HOME/.grafysi/neo4j-volume/logs:/logs \
    --volume=$HOME/.grafysi/neo4j-volume/metrics:/metrics \
    neo4j:5.19.0-enterprise


docker run \
    --name neo4j-sv2 \
    --restart always \
    --network ipvlan_net \
    --env NEO4J_AUTH=neo4j/abcd1234 \
    --env NEO4J_ACCEPT_LICENSE_AGREEMENT=yes \
    --volume=$HOME/.grafysi/neo4j-volume/data:/data \
    --volume=$HOME/.grafysi/neo4j-volume/logs:/logs \
    --volume=$HOME/.grafysi/neo4j-volume/metrics:/metrics \
    neo4j:5.19.0-enterprise


# use ocfs filesystem

docker run \
    --name neo4j-oc1 \
    --restart always \
    --network ipvlan_net \
    --env NEO4J_AUTH=neo4j/abcd1234 \
    --env NEO4J_ACCEPT_LICENSE_AGREEMENT=yes \
    --volume=/mnt/pvstore/docker/neo4j/data:/data \
    --volume=/mnt/pvstore/docker/neo4j/logs:/logs \
    --volume=/mnt/pvstore/docker/neo4j/metrics:/metrics \
    neo4j:5.19.0-enterprise


docker run \
    --name neo4j-oc2 \
    --restart always \
    --network ipvlan_net \
    --env NEO4J_AUTH=neo4j/abcd1234 \
    --env NEO4J_ACCEPT_LICENSE_AGREEMENT=yes \
    --volume=/mnt/pvstore/docker/neo4j/data:/data \
    --volume=/mnt/pvstore/docker/neo4j/logs:/logs \
    --volume=/mnt/pvstore/docker/neo4j/metrics:/metrics \
    neo4j:5.19.0-enterprise