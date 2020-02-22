enum APIError: Error {
    case cannotDecodeData(codingKey: CodingKey?)
    case cannotEncodeRequest
    case noData
}
