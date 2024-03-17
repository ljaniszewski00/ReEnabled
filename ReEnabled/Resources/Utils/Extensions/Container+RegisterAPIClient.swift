import Swinject

extension Container {

    func registerAPIClient<RequestInputType: Encodable,
                           RequestResponseType: Decodable>(_ request: RequestInputType.Type,
                                                           _ response: RequestResponseType.Type) {
        register(AnyAPIClient<RequestInputType, RequestResponseType>.self) { resolver in
            let client = APIClient<RequestInputType, RequestResponseType>()

            return AnyAPIClient(client)
        }
    }
}
