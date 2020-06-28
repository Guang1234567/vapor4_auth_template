import Vapor

/// Usage:
///     ```
///         throw BusinessError.userNotLoggedIn.abort()
///     ```
///
/// Then will print below output in terminal:
///     ```
///         [ ERROR ] Abort.401: User is not logged in. [request-id: 38440B66-E235-4B84-A9F1-260E4EDA2BEC] (App/Controllers/EnvController.swift:35)
///     ```

enum BusinessError {

    case userNotLoggedIn

    case invalidEmail(String)
}

extension BusinessError {

    func abort(
            file: String = #file,
            function: String = #function,
            line: UInt = #line,
            column: UInt = #column,
            stackTrace: StackTrace? = .capture(skip: 1)
    ) -> Abort {
        switch self {
            case .userNotLoggedIn:
                return Abort(
                        .unauthorized,
                        reason: "User is not logged in.",
                        file: file,
                        function: function,
                        line: line,
                        column: column,
                        stackTrace: stackTrace
                )
            case .invalidEmail(let email):
                return Abort(
                        .badRequest,
                        reason: "Email address is not valid: \(email).",
                        file: file,
                        function: function,
                        line: line,
                        column: column,
                        stackTrace: stackTrace
                )
        }
    }
}
