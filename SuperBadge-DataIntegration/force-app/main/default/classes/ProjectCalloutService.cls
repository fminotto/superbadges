public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod
	public static void postOpportunityToPMS(List<Id> ids){
        system.enqueueJob(new QueueablePMSCall(ids));
    }

    public class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
        List<Id> ids;
        String body;
        public QueueablePMSCall(List<Id> ids){
            this.ids = ids;
        }

        public void execute(System.QueueableContext context) {  
            List<AggregateResult> opportunitys = [SELECT Id opportunityId, Name opportunityName, Account.Name accountName, CloseDate closeDate, AVG(Amount) amount FROM Opportunity WHERE Id in :this.ids GROUP BY Id, Name, Account.Name, CloseDate];
            this.body = JSON.serialize(opportunitys);
            this.body = this.body.replace('"attributes":{"type":"AggregateResult"},','');
            ServiceTokens__c serviceToken = ServiceTokens__c.getvalues('ProjectServiceToken');
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:ProjectService');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('token', 'serviceToken');
            request.setBody(this.body);
            HttpResponse response = http.send(request);
            // If the request is successful, parse the JSON response.
            if (response.getStatusCode() == 200) {
                // Deserializes the JSON string into collections of primitive data types.
                System.debug(response);
            }       
        }
    }
}