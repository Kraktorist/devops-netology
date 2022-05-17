vector-role
=========

A role for vector.dev installation and configuration

Requirements
------------

---

Role Variables
--------------

- sources
- sinks
- transforms
- vector_installer_url
- api_enabled
- listen_address
- vector_path_configdir
- vector_path_configfilename

Dependencies
------------

---

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

    - hosts: servers
      pre_tasks:
      roles:
        - role: vector-role
          vars:
            api_enabled: true
            listen_address: 127.0.0.1:8686
            sources:
              - name: dummy_logs
                config:
                  type: demo_logs
                  format: syslog
                  interval: 1
            sinks:
              - name: my_sink_id
                config:
                  type: console
                  inputs:
                  - dummy_logs
                  target: stdout
                  encoding:
                    codec: json            

License
-------

BSD

Author Information
------------------

kraktorist
