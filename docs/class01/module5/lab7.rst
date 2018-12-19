Lab 5.7: Perform lab 1 to 3 using Ansible URI module
----------------------------------------------------

Open a SSH session to *Ubuntu Lamp Server* in UDF.

Execute the playbooks for each tasks

- Task 1: HTTP Application Service::

    # cd /home/f5/f5-ansible-bigiq-as3-demo
    # ./cmd_playbook.sh as3_bigiq_task01_create_http_app.yml paula

Connect as **paula** and check on BIG-IQ the application has been correctly created.

- Task 2: HTTPS Offload::

    # cd /home/f5/f5-ansible-bigiq-as3-demo
    # ./cmd_playbook.sh as3_bigiq_task02_create_https_app.yml paula

Connect as **paula** and check on BIG-IQ the application has been correctly created.

- Task 3a: HTTPS Application with Web Application Firewall::

    # cd /home/f5/f5-ansible-bigiq-as3-demo
    # ./cmd_playbook.sh as3_bigiq_task03a_create_waf_app.yml paula

Connect as **paula** and check on BIG-IQ the application has been correctly created.

- Task 3b: HTTPS Application with Web Application Firewall using an External ASM policy::

    # cd /home/f5/f5-ansible-bigiq-as3-demo
    # ./cmd_playbook.sh as3_bigiq_task03b_create_waf_ext_policy_app.yml paula

Connect as **paula** and check on BIG-IQ the application has been correctly created.

- Task 4: Generic Services::

    # cd /home/f5/f5-ansible-bigiq-as3-demo
    # ./cmd_playbook.sh as3_bigiq_task04_create_generic_app.yml paul

Connect as **paul** and check on BIG-IQ the application has been correctly created.

- Task 5a: Add a HTTPS Application to existing HTTP AS3 Declaration (using POST)::

    # cd /home/f5/f5-ansible-bigiq-as3-demo
    # ./cmd_playbook.sh as3_bigiq_task05a_modify_post_http_app.yml paul

Connect as **paula** and check on BIG-IQ the application has been correctly created.

- Task 5b: Add a HTTPS Application to existing HTTP AS3 Declaration (using PATCH)::

    # cd /home/f5/f5-ansible-bigiq-as3-demo
    # ./cmd_playbook.sh as3_bigiq_task05b_modify_patch_http_app.yml paula

Connect as **paula** and check on BIG-IQ the application has been correctly created.

- Task 6: Create custom HTTP AS3 Template on BIG-IQ::

    # cd /home/f5/f5-ansible-bigiq-as3-demo
    # ./cmd_playbook.sh as3_bigiq_task06_create_template.yml david

Connect as **david** and check on BIG-IQ the AS3 template has been correctly created.

Logon on BIG-IQ, go to Application tab, then Application Templates. Look at the custom template created previous through the API.

|lab-3-1|

Note the AS3 Template cannot be created through BIG-IQ UI but only using the API. You can only delete a AS3 templates from the BIG-IQ UI.

You can see the Template in JSON format if you click on it.

|lab-3-2|


- Task 7: Admin set RBAC for Olivia on BIG-IQ

Let's update now Oliva's service catalog.

Logon on BIG-IQ as **david** go to the System tab, Role Management, Roles, CUSTOM ROLES, Application Roles, select **Applicator Creator AS3** 
and the custom role linked to the custom HTTP template previously created. Remove the **default** template from the allowed list. 
Click **Save & Close**.

|lab-3-3|

- Task 8: Deploy the HTTP Application Service using a Custom Template::

    # cd /home/f5/f5-ansible-bigiq-as3-demo
    # ./cmd_playbook.sh as3_bigiq_task08_create_http_app.yml olivia

Connect as **olivia** and check on BIG-IQ the application has been correctly created.

|lab-3-4|

- Task 9: Delete Task1 with their AS3 Applications::

    # cd /home/f5/f5-ansible-bigiq-as3-demo
    # ./cmd_playbook.sh as3_bigiq_task09_delete_task1_apps.yml david

Connect as **david** on BIG-IQ.

Here, we empty the tenant/partition Task1. This should remove those partitions from BOS-vBIGIP01.termmarc.com. The relevant Apps 
should also disappear from BIG-IQ. 

.. |lab-3-1| image:: images/lab-3-1.png
   :scale: 60%
.. |lab-3-2| image:: images/lab-3-2.png
   :scale: 60%
.. |lab-3-3| image:: images/lab-3-3.png
   :scale: 60%
.. |lab-3-4| image:: images/lab-3-4.png
   :scale: 60%
