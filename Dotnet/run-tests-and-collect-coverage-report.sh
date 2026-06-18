dotnet test \
  --filter "Category!=Integration" \
  /p:CollectCoverage=true \
  /p:CoverletOutputFormat=lcov \
  /p:CoverletOutput=../lcov.info