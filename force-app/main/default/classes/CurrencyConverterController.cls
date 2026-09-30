public with sharing class CurrencyConverterController {
    @AuraEnabled
    public static Map<String, String> getExchangeRate(String fromCurrency, String toCurrency) {
        String apiKey = 'R6GU6XRPRITLGTLS';
        String url = 'https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=' + fromCurrency + '&to_currency=' + toCurrency + '&apikey=' + apiKey;
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        Map<String, String> resultMap = new Map<String, String>();
        
        if (response.getStatusCode() == 200) {
            Map<String, Object> rawJson = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            
            if (rawJson.containsKey('Error Message')) {
                throw new AuraHandledException((String)rawJson.get('Error Message'));
            }
            
            Map<String, Object> rateData = (Map<String, Object>) rawJson.get('Realtime Currency Exchange Rate');
            if (rateData != null) {
                resultMap.put('From_Currency_Code', (String)rateData.get('1. From_Currency Code'));
                resultMap.put('From_Currency_Name', (String)rateData.get('2. From_Currency Name'));
                resultMap.put('To_Currency_Code', (String)rateData.get('3. To_Currency Code'));
                resultMap.put('To_Currency_Name', (String)rateData.get('4. To_Currency Name'));
                resultMap.put('Exchange_Rate', (String)rateData.get('5. Exchange Rate'));
                resultMap.put('Last_Refreshed', (String)rateData.get('6. Last Refreshed'));
            }
        } else {
            throw new AuraHandledException('Error fetching data: ' + response.getStatus());
        }
        
        return resultMap;
    }
}