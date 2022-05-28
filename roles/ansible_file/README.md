kraktorist.ansible_file.ansible_file
=========

The role creates a file with the given content.

Role Variables
--------------

`path` - path to the file
`content` - content of the file

Example Playbook
----------------

```yaml
- hosts: localhost
  roles:
    - kraktorist.ansible_file.ansible_file
```