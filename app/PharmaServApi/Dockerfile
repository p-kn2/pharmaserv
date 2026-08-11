# ==========================================
# Stage 1: Build & Publish (SDK Image)
# ==========================================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Dependency restore pehle karte hain taaki Docker layer caching optimize ho
COPY ["PharmaServApi.csproj", "./"]
RUN dotnet restore "PharmaServApi.csproj"

# Source code copy karke release build generate karo
COPY . .
RUN dotnet publish "PharmaServApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

# ==========================================
# Stage 2: Hardened Runtime (Alpine Base)
# ==========================================
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS final
WORKDIR /app

# Security Best Practice 1: Non-Root User
# Root user ki jagah dedicated application user banao (Least Privilege Principle)
RUN addgroup -g 1000 pharmagroup && \
    adduser -u 1000 -G pharmagroup -s /bin/sh -D pharmauser

# Build output stage 1 se copy karo
COPY --from=build /app/publish .

# Non-root user par switch karo
USER pharmauser

# Application port expose karo
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "PharmaServApi.dll"]