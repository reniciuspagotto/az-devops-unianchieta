FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY "src/" .
RUN dotnet restore "AzUniAnchieta.App/AzUniAnchieta.App.csproj"
COPY . .
WORKDIR "/src/AzUniAnchieta.App"
RUN dotnet build "AzUniAnchieta.App.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AzUniAnchieta.App.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AzUniAnchieta.App.dll"]