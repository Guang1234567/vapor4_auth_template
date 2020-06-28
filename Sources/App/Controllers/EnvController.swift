import Vapor

struct EnvController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let env = routes.grouped("env")
        env.get(use: index)

    }

    func index(req: Request) throws -> String {
        let envDetail: String =
                """

                https://docs.vapor.codes/4.0/environment/

                \(req.application.environment)

                Environment Variables:

                DATABASE_HOST = \(String(describing:Environment.process.DATABASE_HOST))
                DATABASE_NAME = \(String(describing:Environment.process.DATABASE_NAME))

                """

        let processEnv: Environment = req.application.environment
        //let processInfo: ProcessInfo = .processInfo
        //req.logger.info("Environment Variables:\n")
        //req.logger.info("\(processInfo.environment)")
        if processEnv.name.contains(Environment.production.name) {
            req.logger.notice("\(envDetail)")
        } else {
            req.logger.info("\(envDetail)")
        }

        return envDetail
    }

}
