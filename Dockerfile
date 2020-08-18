# ================================
# Build image
# ================================
FROM lihansey/swift:5.2.4-bionic as build
WORKDIR /build

# First just resolve dependencies.
# This creates a cached layer that can be reused
# as long as your Package.swift/Package.resolved
# files do not change.
COPY ./Package.* ./
RUN swift package resolve

# Copy entire repo into container
COPY . .

# Compile with optimizations
RUN swift build --enable-test-discovery -Xswiftc -g -c debug -Xlinker -latomic

# ================================
# Run image
# ================================
FROM swift:5.2.4-bionic-slim

# Create a vapor user and group with /app as its home directory
RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app vapor

# Switch to the new home directory
WORKDIR /app

# Copy build artifacts
COPY --from=build --chown=vapor:vapor /build/.build/debug /app
# Uncomment the next line if you need to load resources from the `Public` directory
COPY --from=build --chown=vapor:vapor /build/Public /app/Public

COPY --from=build --chown=vapor:vapor /build/.env /app
COPY --from=build --chown=vapor:vapor /build/.env.development.custom_name /app

# Ensure all further commands run as the vapor user
USER vapor:vapor

# Start the Vapor service when the image is run, default to listening on 8080 in production environment 
ENTRYPOINT ["./Run"]
# CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]
CMD ["serve", "--env", "development.custom_name"]
