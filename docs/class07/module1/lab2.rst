Lab 1.2: Renaming Firewall Objects:
------------------------------------
BIG-IP and BIG-IQ object models have long lacked support for renaming core configuration objects.  BIG-IQ 6.0.1 has added support for renaming various AFM objects.  In this lab, we will work with this new functionality.

.. note:: This lab uses firewall objects created on Class 7 Module 1, and also uses previously created application deployments (site36.example.com).  Please verify the application site36.example.com is a currently deployed application in your environment, and complete the steps in Module 1 before proceeding with steps below

.. note:: All steps in this lab will be completed using the persona Larry.


Lab 1.2.1: Rename Port Lists
*****************************

1. Connect to your BIG-IQ (as *Larry*)and go to : *Configuration* > *Security* > *Network Security* > *Port Lists*
2. Click the checkbox next to ``deployed_app_ports``, and click the *Rename* button in top right of UI view.
3. In the text box for New Name, enter ``deployed_web_app_ports``
4. Once rename is complete, go to *Network Security* > *Rule Lists*, and click the rule list ``deployed_app_filters``
5. Looking at the second rule, ``deployed_app_dests``, verify the rename of the port list is reflected in the existing rule.
6. Go to *Deployment* > *Evaluate & Deploy*, click *Network Security*
7. In the *Deployments* section, click the *Create* button.
8. Complete the following fieds for the deployment, and click *Create*:
 - Name: ``port_list_rename``
 - Method: ``deploy immediately``
 - Target Devices: ``move all to selected``
9. Once deployment complete, click on the deployment to view the details.  Click on the Network Security differences for one of the firewalls.
10. You should see the old port list has been removed, and the newly named port list has been added

.. image:: ../pictures/module1/port_list_rename_deployment.png
  :align: center
  :scale: 50%

11. Connect to BIG-IP (BOS-vBIGIP01), and check *Security* > *Network Firewall* > *Port Lists.  You should see the port list object has been renamed to ``deployed_web_app_ports``
12. On same BIG-IP, verify that the ``deployed_app_filters`` rule list has also been updated to reflect the name change.

In this release, BIG-IQ also supports renaming of the following objects: Firewall Rule Schedules, Address Lists, Rule Lists, and Firewall Policies not assocatied with application templates.


Lab 1.2.2: Rename Firewall Policy Associated With An Application Template:
***************************************************************************

1. Under *Configuration* > *Security* > *Network Security* > *Firewall Policies*
2. Click the checkbox next to ``f5-afm-policy_136``, the click the *More* button dropdown, and select *Rename*
3. Enter ``f5-afm-ploicy_136_updated`` in the New Name field, and click *Save*

.. image:: ../pictures/module1/policy_rename_error.png
  :align: center
  :scale: 50%

You should see that a validation error similar to above.  BIG_IQ will not allow you to rename a firewall policy that is used in a currently available application template.  To rename a firewall policy that is being used with an application template, the security administrator (e.g. Larry) will need to work with the owner of the application templates (e.g Marco) to create a new template that references the new policy name, then switch existing application deployments to the new version of the template.  We will go through a similar exercise in Class 7 Module 2.



