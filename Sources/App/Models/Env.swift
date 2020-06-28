import Vapor


enum EnvError: Error {

    case dotEnvDev(
            reason: String,
            file: String = #file,
            function: String = #function,
            line: UInt = #line,
            column: UInt = #column/*,
            stackTrace: StackTrace? = .capture(skip: 1)*/
    )

    case dotEnvProd(
            reason: String,
            file: String = #file,
            function: String = #function,
            line: UInt = #line,
            column: UInt = #column/*,
            stackTrace: StackTrace? = .capture(skip: 1)*/
    )

}


extension Environment {
    static var staging: Environment {
        .custom(name: "staging")
    }
}

extension Environment {
    static var dev_custom_name: Environment {
        .custom(name: "development.custom_name")
    }
}

extension Environment {
    static var prod_custom_name: Environment {
        .custom(name: "production.custom_name")
    }
}
