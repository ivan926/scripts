#!/bin/bash


#One dependency is needed jq 
#use homebrew to install program
#brew install jq

#Teams card URL's
teamsTestingChannelURl="https://byu.webhook.office.com/webhookb2/6a657e98-5590-47ae-8c82-b2430447d22f@c6fc6e9b-51fb-48a8-b779-9ee564b40413/IncomingWebhook/d7cc4cb9e5e248a4bbdc8beac4d70d35/d80d9b1a-9a9b-4063-98b3-47b282e0ddf4"


ERROR="Something broke"


# AUTH_BODY=$(jq --null-input \
#   --arg user "$USERNAME" \
#   --arg password "$PASSWORD" \
#   '{"user": $user, "password": $password}')


#JSON skeleton for teams message
cardJsonString=$(jq --null-input \
--arg jq_error "$ERROR" \
'{
    "type":"message",
    "attachments":[
        {
            "contentType":"application/vnd.microsoft.card.adaptive",
            "contentUrl":null,
            "content":{
                "`$schema":"http://adaptivecards.io/schemas/adaptive-card.json",
                "type":"AdaptiveCard",
                "version":"1.2",
                "msTeams": { "width": "full" },
                "body": [
                     {
                          "type": "TextBlock",
                          "text": "MACManager Report:",
                          "wrap": true
                     },
                     {
                          "type": "FactSet",
                          "facts" : [
                            {
                                "name": "Description",
                                "value": "Test from Bash"
                            },
                            {
                                "name": "Description",
                                "value": $jq_error
                            }
                          ]
                     }
                ]
            }
        }
    ]
}
')



# on macOS or Linux
curl -H 'Content-Type: application/json' -d "${cardJsonString}" $teamsTestingChannelURl
