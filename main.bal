import ballerina/http;
import ballerina/log;
import ballerina/xmldata;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /integrationAPI on httpDefaultListener {
    resource function post xmlToJson(@http:Payload xml xmlPayload, @http:Header string? Authorization) returns json|http:InternalServerError {
        // Log the Authorization header if present
        if Authorization is string {
            log:printInfo("Received Authorization header", authorization = Authorization);
        } else {
            log:printInfo("No Authorization header found in the request");
        }
        
        // Convert XML to JSON using xmldata module
        json|error jsonResult = xmldata:toJson(xmlPayload);
        
        if jsonResult is error {
            log:printError("Failed to convert XML to JSON", 'error = jsonResult);
            return <http:InternalServerError>{
                body: {
                    "error": "Failed to convert XML to JSON",
                    "message": jsonResult.message()
                }
            };
        }
        
        log:printInfo("Successfully converted XML to JSON");
        return jsonResult;
    }

}
