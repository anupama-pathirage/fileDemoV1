import ballerinax/azure_storage_service.blobs as blobs;
import ballerina/http;

type Address record {
    string streetaddress;
    string city;
    string state;
    string postalcode;
};

type Personal record {
    string firstname;
    string lastname;
    string gender;
    int birthyear;
    Address address;
};

type Employee record {
    string empid;
    Personal personal;
};

configurable string accountName = ?;
configurable string accessKeyOrSAS = ?;
configurable string containerName = ?;

final blobs:BlobClient blobClient = check createStorageClient();
service /portal on new http:Listener(9090) {

    resource function post employees/[string file](@http:Payload Employee[] employees) returns json|error {
        return blobClient->putBlob(containerName, file,"BlockBlob", employees.toJsonString().toBytes());
    }
}

function createStorageClient() returns blobs:BlobClient|error => 
    check new ({accessKeyOrSAS, authorizationMethod: "accessKey", accountName});
