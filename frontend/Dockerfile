# ── Stage 1: Build Flutter Web ──────────────────────────────────────────────
# Using a pre-built Flutter image avoids cloning the full ~1 GB Flutter repo.
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy pubspec first so Flutter can cache pub-get separately from source changes
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy the rest of the source
COPY . .

# Build for web, injecting the backend URL at compile time
ARG BACKEND_URL=http://localhost:8080
RUN flutter build web --dart-define=BACKEND_URL=${BACKEND_URL}

# ── Stage 2: Serve with Nginx ────────────────────────────────────────────────
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
