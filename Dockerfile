FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

COPY SampleWebApiAspNetCore.sln .
COPY SampleWebApiAspNetCore/*.csproj ./SampleWebApiAspNetCore/

RUN dotnet restore

COPY SampleWebApiAspNetCore/. ./SampleWebApiAspNetCore/

WORKDIR /src/SampleWebApiAspNetCore
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 80

ENTRYPOINT ["dotnet", "SampleWebApiAspNetCore.dll"]