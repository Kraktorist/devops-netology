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

nginx and [ansible-nginx role](https://github.com/geerlingguy/ansible-role-nginx)

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