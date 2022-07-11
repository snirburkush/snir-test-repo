
FROM gcr.io/apiiro/base/dotnet-sdk:3.1-alpine AS buildtime

RUN dotnet dev-certs https --clean && \
    dotnet dev-certs https -ep /https/maven.pfx -p "maven"

COPY MavenContentService/MavenContentService.csproj /MavenContentService/
RUN dotnet restore /MavenContentService/MavenContentService.csproj

COPY MavenContentService /MavenContentService
RUN cd /MavenContentService && dotnet publish -c Release -o out

FROM gcr.io/apiiro/base/dotnet-runtime:3.1-alpine AS runtime
WORKDIR /MavenContentService
COPY --from=buildtime /MavenContentService/out .
COPY --from=buildtime /https /https

ENV ASPNETCORE_Kestrel__Certificates__Default__Password="maven"
ENV ASPNETCORE_Kestrel__Certificates__Default__Path=/https/maven.pfx
ENV ASPNETCORE_URLS="https://+;http://+"
ENV ASPNETCORE_HTTPS_PORT=443

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["dotnet", "./MavenContentService.dll"]
