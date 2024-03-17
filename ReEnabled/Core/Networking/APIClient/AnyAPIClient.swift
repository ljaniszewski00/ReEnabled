import Combine

class AnyAPIClient<RequestInputType: Encodable,
                   RequestResponseType: Decodable>: APIClientProtocol {

    required init<Client: APIClientProtocol>(_ client: Client)
    where Client.RequestInputType == RequestInputType,
    Client.RequestResponseType == RequestResponseType {
        _request = client.request
    }

    // MARK: - APIClientProtocol

    func request(_ endpoint: APIEndpoint,
                 requestInput: RequestInputType) -> AnyPublisher<RequestResponseType, Error> {
        _request(endpoint, requestInput)
    }

    private let _request: (APIEndpoint,
                           RequestInputType) -> AnyPublisher<RequestResponseType, Error>

}
