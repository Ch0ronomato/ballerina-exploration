import ballerina/http;
import ballerina/log;

// Create an endpoint with port 8000 for the reddit commit service
listener http:Listener redditCommentServiceEP = new(8080);

// Define the load balance client endpoint to call the backend services.
http:LoadBalanceClient redditCommentBackends = new({
    targets: [
        // Create an array of HTTP Clients that needs to be Load balanced across
        { url: "http://localhost:5000/comment" },
        { url: "http://localhost:5001/comment" },
        { url: "http://localhost:5002/comment" },
        { url: "http://localhost:5003/comment" }
    ]
});

@http:ServiceConfig {
    basePath: "/"
}
service RedditComment on redditCommentServiceEP {
    @http:ResourceConfig {
        path: "/comment"
    }
    resource function redditCommentService(http:Caller caller, http:Request req) {
        // Initialize the request and response messages for the remote call
        http:Request outRequest = new;
        http:Response outResponse = new;

        // Call the comment backend with load balancer
        var backendResponse = redditCommentBackends->get("");
	log:printInfo("Fetched from services");
        if (backendResponse is http:Response) {
	    log:printInfo("Valid response from comment backend");
            //Forward the response received from the back end to the client
            var result = caller->respond(backendResponse);
            handleError(result);
        } else {
	    log:printInfo("Invalid response from comment backend");
            //Send the response back to the client if back end fails
            var payload = backendResponse.detail().message;
            if (payload is error) {
                outResponse.setPayload("Recursive error occurred while reading backend error");
                handleError(payload);
            } else {
                outResponse.setPayload(string.convert(payload));
            }
            var result = caller->respond(outResponse);
            handleError(result);
        }
    }
}

function handleError(error? result) {
    if (result is error) {
        log:printError(result.reason(), err = result);
    }
}
