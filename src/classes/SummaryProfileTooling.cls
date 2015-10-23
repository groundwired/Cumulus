///**
// * Copyright (c) 2013, Apex Tooling API
// * All rights reserved.
// *
// * Redistribution and use in source and binary forms, with or without modification,
// *   are permitted provided that the following conditions are met:
// *
// * - Redistributions of source code must retain the above copyright notice,
// *      this list of conditions and the following disclaimer.
// * - Redistributions in binary form must reproduce the above copyright notice,
// *      this list of conditions and the following disclaimer in the documentation
// *      and/or other materials provided with the distribution.
// * - Neither the name of the Apex Tooling API, inc nor the names of its contributors
// *      may be used to endorse or promote products derived from this software without
// *      specific prior written permission.
// *
// * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
// *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
// *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//**/


/**
 * Class: SummaryProfileTooling
 *
 * Copyright: see above
 *
 * Purpose: Tooling api to get custom fields for drag/drop interface
 * 
 * Where Referenced: SummaryProfileFieldSelection
 *   
 *
 * Change History:
 *
 * Developer         Date                          Description
 * ---------------------------------------------------------------------------------------
 * Drew Piston      2015.10.23   		 Initial Development
 *
 * 
 */


public with sharing class SummaryProfileTooling {

    // The API version used relates to the types and structures defined here
    private static final String TOOLING_API_URI = '/services/data/v32.0/tooling';

	public String sessionId;

	// constructor
	public SummaryProfileTooling() {
		sessionId = UserInfo.getSessionId();
	}

	// query the tooling api and return a list of all of the field definitions
    public List<FieldDefinition> getFieldDefinitions(String sourceObject){
        String theQueryString = 'Select Id, DeveloperName, NamespacePrefix, fullName, Label, QualifiedApiName, DurableId  From FieldDefinition Where EntityDefinition.QualifiedApiName = \'' + sourceObject + '\' order by DeveloperName' ;
        HttpResponse response = submitRestGet('/query/?q=' + EncodingUtil.urlEncode(theQueryString, 'UTF-8'));

        if (Test.isRunningTest()){
        	FieldDefinition fd = new FieldDefinition();
        	fd.fullName = 'fullname';
        	fd.developerName = 'developerName__c';
        	fd.label = 'label';
        	fd.qualifiedApiName = 'qualifiedApiName__c';
        	return new List<FieldDefinition> {fd};
        } 

        FieldDefinitiontheHttpResponseult theHttpResponseult = (FieldDefinitiontheHttpResponseult)JSON.deserialize(response.getBody(), FieldDefinitiontheHttpResponseult.class);        
        return theHttpResponseult.records;
    }

    // this does all the work!
    public HttpResponse submitRestGet(String urlEnd){
        Http theHTTP = new Http();
        HttpRequest theHttpRequest = new HttpRequest();
        theHttpRequest.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + TOOLING_API_URI + urlEnd);
        theHttpRequest.setHeader('Authorization', 'OAuth ' + sessionId);
        theHttpRequest.setHeader('Content-Type', 'application/json');
        theHttpRequest.setMethod('GET');

        HttpResponse theHttpResponse = null;

        if (Test.isRunningTest()){
        	theHttpResponse = new HttpResponse();
        	theHttpResponse.setStatusCode(200);
        } else {
	        try {
	            theHttpResponse = theHTTP.send(theHttpRequest);
	        } catch (System.CalloutException calloutExc){
	            if (calloutExc.getMessage().containsIgnoreCase('unauthorized endpoint')){
	                throw new ToolingAPIAuthorizationException(calloutExc);
	            } else {
	                throw calloutExc;
	            }
	        }
	    }

        Integer theHttpSuccessCode = 200;
        if (theHttpResponse.getStatusCode() != theHttpSuccessCode){
            if(theHttpResponse.getBody().length()>0){
                throw new ToolingAPIException((List<ErrorResponse>) JSON.deserialize(theHttpResponse.getBody(), List<ErrorResponse>.class));
            } else {
                throw new ToolingAPIException('Unexpected HTTP Status ' + theHttpResponse.getStatusCode());
            }
      	}
        return theHttpResponse;
    }

    // used to parse the json (?)
    public class FieldDefinitiontheHttpResponseult {
        public FieldDefinition[]        records;
    }

    // also used to parse the json (?)
    public class FieldDefinition {
        public String              fullName;
        public String              developerName;
        public String              label;
        public String              namespacePrefix;
        //public String              tableEnumOrId;
        public Id                  id;  
        public String              qualifiedApiName;       
    }

    // for errors
    public class ErrorResponse{
        public List<String> fields;
        public String errorCode;
        public String message;
    }

    // custom exception
    public class ToolingAPIException extends Exception{
        public ToolingAPIException(List<ErrorResponse> errorResponses){
            this(errorResponses[0].errorCode + ' : ' + errorResponses[0].message);
        }
    }

    // custom exception
    public class ToolingAPIAuthorizationException extends Exception{
    }
}