Lab 4.1: Configure High Availability for BIG-IQ
-----------------------------------------------

**Add a peer BIG-IQ system for a high availability configuration**

Before you can set up F5 BIG-IQ Centralized Management in a high availability (HA) pair, you must have two licensed BIG-IQ systems.

For the high-availability pair to synchronize properly, each system must be running the same BIG-IQ version, 
and the clocks on each system must be synchronized to within 60 seconds. To make sure the clocks are in sync, 
take a look at the NTP settings on each system before you add a peer.

Configuring BIG-IQ in a high availability (HA) pair means that you can still manage your BIG-IP devices even if one BIG-IQ systems fails.

**Lab:**

1. Let's first add a BIG-IQ CM image in the blueprint.

- In UDF:

In the ``F5 Products`` column, click on **ADD**

.. image:: ../pictures/module4/img_module4_lab1_1a.png
  :align: center
  :scale: 70%

|

Select approriate release of BIG-IQ (same as the existing active BIG-IQ part of the blueprint) and set the following values for CPU/Memory/Disk:

    - vCPUs: 4
    - Memory: 16 GiB
    - Disk Size: 500 GiB

Click on **CREATE**.

.. image:: ../pictures/module4/img_module4_lab1_1b.png
  :align: center
  :scale: 70%

|

After few minutes, the VM is created in UDF. Click on the new VM, go to the Subnets tab and bind additional interfaces (External and Internal).

.. image:: ../pictures/module4/img_module4_lab1_1c.png
  :align: center
  :scale: 70%

|

Finally, start the new BIG-

.. image:: ../pictures/module4/img_module4_lab1_1d.png
  :align: center
  :scale: 70%

|

- In Ravello:

``Ça arrive bientôt זה בקרוב Viene pronto すぐに来る Sta arrivando presto قادم قريبا Coming soon 即將到來``

2. Connect via ``SSH`` to the system *Ubuntu Lamp Server*.

3. Request 1 BIG-IQ Evaluation license and set it in the inventory file in ``bigiq_onboard_license_key`` variable (**Ravello only**).

    ::

        # cd /home/f5/f5-bigiq-onboarding 
        # vi inventory/group_vars/udf-bigiq-cm-02.yml

.. note:: Double check the IP address of the new secondary BIG-IQ and update it in ``udf-bigiq-cm-02.yml`` if necessary (``bigiq_onboard_server``)

4. Once the new VE is full up and running, execute the following script to onboard this new secondary BIG-IQ CM.

    ::

        # cd /home/f5/f5-bigiq-onboarding
        # ./cmd_bigiq_onboard_secondary_cm.sh nopause


5. Verify the new secondary BIG-IQ CM has been correclty configured (check hostname, self IP, VLAN, NTP, DNS, license)

.. image:: ../pictures/module4/img_module4_lab1_3.png
  :align: center
  :scale: 70%

|

6. Open active BIG-IQ, go to System > BIG-IQ HA and Click the Add Secondary button.

.. image:: ../pictures/module4/img_module4_lab1_4.png
  :align: center
  :scale: 70%

|

7. Type the properties for the BIG-IQ system that you are adding and click the Add button at the bottom of the screen.

- In the IP Address field, type the IP address for the secondary BIG-IQ system.
- In the Username and Password fields, type the administrator's user name and password for the new BIG-IQ system.
- In the Root Password field, type the root password for the new BIG-IQ system.

.. image:: ../pictures/module4/img_module4_lab1_5.png
  :align: center
  :scale: 70%

|

Then, click OK.

.. image:: ../pictures/module4/img_module4_lab1_6.png
  :align: center
  :scale: 70%

|

The BIG-IQ system synchronize. Once they are finished, both appear as ready (green).

