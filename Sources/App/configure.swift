import Fluent
import FluentPostgresDriver
import Vapor


// configures your application
public func configure(_ app: Application) throws {

    // Always capture stack traces, regardless of log level.
    StackTrace.isCaptureEnabled = true

    // https://docs.vapor.codes/4.0/passwords/#bcrypt
    app.passwords.use(.bcrypt)

    try cfgHttpServer(app)
    try cfgMiddleware(app)
    try cfgDatabase(app)

    try EmailController.configure(app)

    // register routes
    try routes(app)
}

private func cfgHttpServer(_ app: Application) throws {
    let envName = app.environment.name

    guard let hostname = Environment.process.HOST_NAME else {
        throw EnvError.dotEnvDev(reason: "Please configurate `HOST_NAME=XXX` in file('.env.\(envName)') !")
    }

    guard let port = Environment.process.HOST_PORT else {
        throw EnvError.dotEnvDev(reason: "Please configurate `HOST_PORT=XXX` in file('.env.\(envName)') !")
    }

    app.http.server.configuration.hostname = hostname
    app.http.server.configuration.port = Int(port) ?? 8080

    // Enable TLS.
    // -----------
    // Disable HTTP/1 support.
    /*
    app.http.server.configuration.supportVersions = [.two]
    try app.http.server.configuration.tlsConfiguration = .forServer(
            certificateChain: [
                .certificate(.init(
                        file: "/path/to/cert.pem",
                        format: .pem
                ))
            ],
            privateKey: .file("/path/to/key.pem")
    )
    */
}

private func cfgMiddleware(_ app: Application) throws { // Clear any existing middleware.
    app.middleware = .init()

    app.middleware.use(CORSMiddleware(configuration: CORSMiddleware.Configuration(
            allowedOrigin: .all,
            allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
            allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )))

    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.sessions.use(.fluent)
    app.middleware.use(app.sessions.middleware)

    app.middleware.use(ErrorMiddleware.default(environment: app.environment))
}

private func cfgDatabase(_ app: Application) throws {
    let envName = app.environment.name

    guard let dbHostName = Environment.process.DATABASE_HOST else {
        throw EnvError.dotEnvDev(reason: "Please configurate `DATABASE_HOST=XXX` in file('.env.\(envName)') !")
    }

    guard let dbName = Environment.process.DATABASE_NAME else {
        throw EnvError.dotEnvDev(reason: "Please configurate `DATABASE_NAME=XXX` in file('.env.\(envName)') !")
    }

    guard let dbUserName = Environment.process.DATABASE_USERNAME else {
        throw EnvError.dotEnvProd(reason: "Please `export DATABASE_USERNAME=XXX` in the terminal !")
    }

    guard let dbPassword = Environment.process.DATABASE_PASSWORD else {
        throw EnvError.dotEnvProd(reason: "Please `export DATABASE_PASSWORD=XXX` in the terminal !")
    }

    app.databases.use(
            .postgres(
                    hostname: dbHostName,
                    username: dbUserName,
                    password: dbPassword,
                    database: dbName
            ),
            as: .psql)

    app.migrations.add(SessionRecord.migration)
    app.migrations.add(CreateTodo())
    app.migrations.add(CreateGalaxy())
    app.migrations.add(CreateStar())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateUserToken())
}
