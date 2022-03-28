$headers = @{
    'Api-version' = '2.0'
    'Content-type' = 'Application/json'
    'Ocp-Apim-Subscription-Key' = '<Insert subscription key here>'
}

$body = ConvertFrom-Json '
{
    "buildYourJsonObjectHere": ""
}'

Invoke-RestMethod -Uri "https://gw.qa.partner.api.volvocars.biz/softproduct/vehicle/soft-products" -Method POST -Headers $headers -Body $body