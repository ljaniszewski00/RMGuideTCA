func registerAPIClient<RequestInputType: Encodable,
                       RequestResponseType: Decodable>(
                        _ request: RequestInputType.Type,
                        _ response: RequestResponseType.Type
                       ) -> APIClient<RequestInputType, RequestResponseType> {
    APIClient<RequestInputType, RequestResponseType>()
}
