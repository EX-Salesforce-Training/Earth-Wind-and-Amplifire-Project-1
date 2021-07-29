public class RestAPI {
    Public String norrisQuotes {get{
        return makeCallout();
    }set;}
    
    public Static String makeCallout(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.chucknorris.io/jokes/random');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200){
            Map<String,Object> resMap = (Map<String,Object>)
                JSON.deserializeUntyped(response.getBody());
            
            String facts = String.valueOf(resMap.get('value'));
            
            String chuckNorris = 'Chuck Norris quote of the day' +facts;
            return chuckNorris;
        }
        return null;
    }
    
    public void getQuote(){
       norrisQuotes = makeCallout();
    }
}