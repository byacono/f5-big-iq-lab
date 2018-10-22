Lab 2.3: Using BIG-IQ to Make Wide-Scale Changes to AFM Device DOS Profiles
---------------------------------------------------------------------------------
Prior to BIG-IQ 6.0.1, AFM Device Dos Profile could be managed centrally using BIG-IQ.  However, BIG-IQ still required that each profile was managed and deployed individually.  In the latest release, BIG-IQ added the ability to edit device dos profiles across multiple devices from a single profile by supporting a "copy-to" functionality.  This still doesn't allow for editing of individual fields in the configuration, and then pushing to many devices.  However, does provide ability to make changes to one profile, and copy broadly to many devices.  In this lab, we will work with this new feature.

.. note:: All steps in this lab will be completed using the persona Larry.


.. note:: The multi-device device dos feature requires that source and target BIG-IP's are running the same version of TMOS.  Also, BIG-IQ will not allow you to deploy DOS configurations to an individual member of device group.  The lab environment available has only two BIG-IPs running the same version of TMOS, and they are in an HA pair.  So, in below steps, we will walk through what is required to leverage the multi-device device dos edit feature, but will not actually deploy the changes.

Lab 2.3.1: Deploy Device DOS Configurations to Multiple Systems on Single Push:
********************************************************************************

1. Under the *Configuration* > *Shared Security* > *DoS Protection, click *Device DoS Configurations*
2. Click the checkbox next to ``BOS-vBIGIP01`` and click the *Copy* button on top of page
3. Move ``BOS-vBIGIP02`` from Available box to selected box, and click *Ok*

.. image:: ../pictures/module2/device_dos_copy.png
  :align: center
  :scale: 50%

|

Once the copy has been completed.  We will still need to execute a deployment for all devices targeted via the copy operation.

4. Under *Deployment* > *Evaluate & Deploy* > *Network Security*, click the *Create* button under *Evaluations*
5. Complete the evaluation as outlined below:
 - Name: ``device_dos_copy``
 - Source: ``Current Changes``
 - Source Scope: ``All Changes``
 - Unused Objects: ``Remove Unused Objects``
 - Target Devices: ``BOS-vBIGIP01``, ``BOS-vBIGIP02``
5. Click *Create*
6. Once evaluation has completed, you can verify the Shared Security changes if desired.
7. Select completed evaluation, and click *Deploy*

