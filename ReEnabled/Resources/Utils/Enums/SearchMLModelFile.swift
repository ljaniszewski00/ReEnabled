enum SearchMLModelFile {
    case gpt2
}

extension SearchMLModelFile {
    
    var fileName: String {
        switch self {
        case .gpt2:
            "distilgpt2-64-6"
        }
    }
}
