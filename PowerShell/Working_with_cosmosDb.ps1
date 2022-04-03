$primaryKey = ConvertTo-SecureString `
    -String "<Put db primary key here>" `
    -AsPlainText `
    -Force

$cosmosDbContext = New-CosmosDbContext -Account "erikwenzel" -Database "ToDoList" -Key $primaryKey


$documents = Get-CosmosDbDocument `
    -Context $cosmosDbContext `
    -CollectionId "Items" `
    -Query 'select * from c where c.partitionKey = "myPartitionKey"' `
    -MaxItemCount 99

foreach($document in $documents){
    Write-Host "Fetching document with id: $($document.id)" -ForegroundColor Blue;
    $sourceDocument = Get-CosmosDbDocument `
        -Context $cosmosDbContext `
        -CollectionId "Items" `
        -Id $document.id `
        -PartitionKey $document.partitionKey

    Write-Host "Building new body for document with id: $($document.id)" -ForegroundColor Blue;
    $newDocument = $sourceDocument | select-object -ExcludeProperty @('Etag', 'ResourceId', 'Timestamp', 'Uri', 'Attachments')
    $newDocument.content = "new content123"
    $newDocumentBody = $newDocument | ConvertTo-Json;

    Write-Host "Updating to new body of document with id: $($document.id)" -ForegroundColor Blue;
    Set-CosmosDbDocument `
        -Context $cosmosDbContext `
        -CollectionId "Items" `
        -Id $sourceDocument.id `
        -PartitionKey $sourceDocument.partitionKey `
        -DocumentBody $newDocumentBody `
        > $null
}