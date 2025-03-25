protocol AppError: Error {
    var message: String { get }
}

enum NetworkError: AppError {
    case invalidResponse
    case networkFailure(Error)
    case decodingFailure(Error)
    case unknown

    var message: String {
        switch self {
        case .invalidResponse:
            return "Respuesta no válida del servidor."
        case .networkFailure(let error):
            return "Error de red: \(error.localizedDescription)"
        case .decodingFailure:
            return "Error al decodificar los datos."
        case .unknown:
            return "Ha ocurrido un error desconocido."
        }
    }
}
