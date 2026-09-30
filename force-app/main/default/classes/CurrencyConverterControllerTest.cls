@isTest
private class CurrencyConverterControllerTest {

    // Mock implementation for successful HTTP Callout
    private class CurrencyCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"Realtime Currency Exchange Rate": {"1. From_Currency Code": "USD", "2. From_Currency Name": "United States Dollar", "3. To_Currency Code": "INR", "4. To_Currency Name": "Indian Rupee", "5. Exchange Rate": "83.50", "6. Last Refreshed": "2026-09-29 10:00:00"}}');
            return res;
        }
    }

    @isTest
    static void testGetExchangeRateSuccess() {
        // Set the mock callout class
        Test.setMock(HttpCalloutMock.class, new CurrencyCalloutMock());

        Test.startTest();
        Map<String, String> result = CurrencyConverterController.getExchangeRate('USD', 'INR');
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(null, result, 'The result map should not be null.');
        System.assertEquals('USD', result.get('From_Currency_Code'), 'From Currency Code should match USD.');
        System.assertEquals('INR', result.get('To_Currency_Code'), 'To Currency Code should match INR.');
        System.assertEquals('83.50', result.get('Exchange_Rate'), 'Exchange rate should match mocked value.');
    }
}