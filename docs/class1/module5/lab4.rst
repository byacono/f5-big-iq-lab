Lab 5.4: Delete AS3 Tenant/Applications on BIG-IQ
-------------------------------------------------

Task 9 - Delete Task1 with its AS3 Applications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here, we empty the tenant/partition of Task1. This should remove those partitions from BOS-vBIGIP01.termmarc.com. The relevant Apps 
should also disappear from BIG-IQ. 

.. note :: We are not using the DELETE method but a POST with a declaration containing a tenant with nothing in it.

1. Using Postman, use the **BIG-IQ Token (david)** collections to authenticate you on the BIG-IQ and save the token.
   If your token expires, obtain a new token by resending the ``BIG-IQ Token (david)``.

   .. WARNING:: The token timeout is set to 5 min. If you get the 401 authorization error, request a new token.

2. Copy below example of an AS3 Declaration into the body of the **BIG-IQ AS3 Declaration** collection in order to create the service on the BIG-IP through BIG-IQ:

POST https://10.1.1.4/mgmt/shared/appsvcs/declare?async=true

.. code-block:: yaml
   :linenos:
   :emphasize-lines: 14,15,16

   {
       "class": "AS3",
       "action": "deploy",
       "persist": true,
       "declaration": {
           "class": "ADC",
           "schemaVersion": "3.7.0",
           "id": "example-declaration-01",
           "label": "Task9",
           "remark": "Task 9 - Delete Tenants",
           "target": {
               "hostname": "BOS-vBIGIP01.termmarc.com"
           },
           "Task1": {
               "class": "Tenant"
           }
       }
   }

3. Check the tenant/application(s) has been correctly removed from the BIG-IP and BIG-IQ.
