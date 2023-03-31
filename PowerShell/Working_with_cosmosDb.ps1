# NOTE THAT THERE IS A DEPENDENCY TO THE MODULE CosmosDB
# https://www.powershellgallery.com/packages/CosmosDB/4.1.0
# https://github.com/PlagueHO/CosmosDB


#####################
# Connect to Cosmos #
#####################

$primaryKey = ConvertTo-SecureString `
    -String "<Put db primary key here>" `
    -AsPlainText `
    -Force

$cosmosDbContext = New-CosmosDbContext -Account "emea-servicedata-logic-qa" -Database "emea-servicedata-logic-qa-persistent" -Key $primaryKey

#######################
# Update a document #
#######################

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

#####################
# Delete a document #
#####################

Remove-CosmosDbDocument `
    -Context $cosmosDbContext `
    -CollectionId 'servicedata-v2-test' `
    -Id '6ES016896~1000701' `
    -PartitionKey 'YV1VW14K23F997480'

##############################
# Delete a list of documents #
##############################

$documents = @{
    "exampleId" = "examplePartitionKey";
    "exampleId2" = "examplePartitionKey";
}

foreach($document in $documents.GetEnumerator()){
    $id = $document.Name;
    $partitionKey = $document.Value;
    Write-Host "Updating document with id `"$id`" and partitionKey `"$partitionKey`"";

    Remove-CosmosDbDocument `
    -Context $cosmosDbContext `
    -CollectionId 'servicedata-v2-test' `
    -Id $id `
    -PartitionKey $partitionKey
}
