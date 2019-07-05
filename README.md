# Load balancer

1. Build docker containers: `cd reddit_getter && docker build --tag reddit_comment . && for i in {5000..5003}; do docker run -d -p $i:5000 -e BACKEND_ID=$i -e REDDIT_CLIENT_ID="your id" -e REDDIT_CLIENT_SECRET="your secret" reddit_comment; done`
2. Run ballerina: `ballerina run lb.bal`
3. Got to `localhost:8080/comment`

You can see the logs alternate in the docker containers rotation (ballerina uses round-robin by default)
