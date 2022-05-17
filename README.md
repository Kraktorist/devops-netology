vector-role
=========

A role for vector.dev installation and configuration

Requirements
------------

---

Role Variables
--------------

F: You can define vector sources

```yaml
sources:
  - name: dummy_logs
    config:
      type: demo_logs
      format: syslog
      interval: 1
```

F: You can define vector sinks

```yaml
sinks:
  - name: to_clickhouse
    config:
      type: clickhouse
      inputs: [ parse_logs ]
      database: "{{ database }}"
      endpoint: "{{ endpoint }}"
      auth:
        user: "{{ username }}"
        password: "{{ password }}"
        strategy: basic
      table: "{{ table }}"
      compression: gzip
```

F: You can define vector transforms

```yaml
transforms:
  - name: parse_logs
    config:
      type: remap
      inputs: [ dummy_logs ]
      source: |
        . = parse_syslog!(string!(.message))
        .timestamp = to_string(.timestamp)
        .timestamp = slice!(.timestamp, start:0, end: -1)
```
F: You can define vector installation package source url

```yaml
vector_installer_url: 
```
F: You can enable or disable vector API status

```yaml
api_enabled: true
```

F: You can set vector API listen address binding

```yaml
listen_address: 127.0.0.1:8686
```

F: You can define vector configuration path

```yaml
vector_path_configdir: "/etc/vector/"
vector_path_configfilename: "config.yaml"
``


Dependencies
------------

not required

Example Playbook
----------------

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
