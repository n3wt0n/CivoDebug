#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src/
COPY ["CoderDave.csproj", "CoderDave/"]
RUN dotnet restore "CoderDave/CoderDave.csproj"


WORKDIR "/src/CoderDave"
COPY . .

RUN dotnet build "CoderDave.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CoderDave.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CoderDave.dll"]
