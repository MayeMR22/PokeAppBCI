protocol ServiceFactoryType {
    func createService<T: Decodable>(for endpoint: EndpointType) -> BaseService<T>
}

class ServiceFactory: ServiceFactoryType {
    func createService<T: Decodable>(for endpoint: EndpointType) -> BaseService<T> {
        return BaseService<T>(endpoint: endpoint)
    }
}
