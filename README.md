lighthouse-role
=========

A role for configuring vkcom/lighthouse with nginx

Role Variables
--------------

F: You can define source path to distrib

```yaml
lighthouse_distrib: https://github.com/VKCOM/lighthouse/archive/refs/heads/master.zip
```

Dependencies
------------

not required

Example Playbook
----------------

```yaml
    - hosts: servers
      roles:
         - lighthouse-role
```

License
-------

BSD

Author Information
------------------

kraktorist