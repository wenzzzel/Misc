
az storage blob download-batch --destination ./ --account-name "<account-name>" --source "<blob-storage-name>" --account-key "<masked>" --pattern "2026/2/23/*"
grep -r "value-to-search-for" .
