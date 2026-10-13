# ============================
# ETAPA 1 - BUILD
# ============================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# Copiar primero los archivos de proyecto
COPY ["Dsw2025Tpi.Api/Dsw2025Tpi.Api.csproj", "Dsw2025Tpi.Api/"]
COPY ["Dsw2025Tpi.Application/Dsw2025Tpi.Application.csproj", "Dsw2025Tpi.Application/"]
COPY ["Dsw2025Tpi.Data/Dsw2025Tpi.Data.csproj", "Dsw2025Tpi.Data/"]
COPY ["Dsw2025Tpi.Domain/Dsw2025Tpi.Domain.csproj", "Dsw2025Tpi.Domain/"]

# Restaurar paquetes NuGet
RUN dotnet restore "Dsw2025Tpi.Api/Dsw2025Tpi.Api.csproj"

# Copiar el resto del código
COPY . .

# Publicar la API
RUN dotnet publish "Dsw2025Tpi.Api/Dsw2025Tpi.Api.csproj" \
    -c Release \
    -o /app/publish \
    --no-restore

# ============================
# ETAPA 2 - RUNTIME
# ============================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 8080

ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "Dsw2025Tpi.Api.dll"]