import ballerinax/health.fhir.r4;
import ballerinax/health.clients.fhir;
import ballerinax/health.fhir.r4.davincihrex100 as hrex100;
import ballerinax/health.fhir.r4.uscore501;
import ballerinax/health.fhir.r4.international401;
import ballerina/log;
import ballerina/http;

public isolated class DemoFHIRMemberMatcher {
    *hrex100:MemberMatcher;
    // FHIR repository client
    private final fhir:FHIRConnector fhirClient;

    public isolated function matchMember(anydata memberMatchResources) returns hrex100:MemberIdentifier|r4:FHIRError {
        
        if memberMatchResources !is hrex100:MemberMatchResources {
            log:printError("Invalid type for \"memberMatchResources\". Expected type: MemberMatchResources.");
            return r4:createFHIRError("Internal server error", r4:ERROR,r4:PROCESSING, httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR);
        }


        // Member match resources
        uscore501:USCorePatientProfile memberPatient = memberMatchResources.memberPatient;
        hrex100:HRexConsent? consent = memberMatchResources.consent;
        hrex100:HRexCoverage coverageToMatch = memberMatchResources.coverageToMatch;
        hrex100:HRexCoverage? coverageToLink = memberMatchResources.coverageToLink;

        // Get patient resource from OLD payor
        // Search Patient from given name
        

        international401:Patient oldPatient = {};

        string? patientId = oldPatient.id;

        // Get coverage from id
        international401:Coverage oldCoverage = {payor: [], beneficiary: {}, status: "entered-in-error"};


        string? beneficiaryRef = oldCoverage.beneficiary.reference;

        if beneficiaryRef is string && beneficiaryRef is string{
            // If both beneficiaryRef and oldPatient.id are same, we can derive it as a match
            if beneficiaryRef==patientId {
                //match found
                return <hrex100:MemberIdentifier> patientId;
            }
        }

        return "patinetID";
    }
}
