## Ansible Collection - kraktorist.ansible_file

This is educational project for creating files

### Installation

```console
ansible-galaxy collection install git+https://github.com/Kraktorist/devops-netology.git,ansible_file
```

### Usage

`kraktorist.ansible_file.ansible_file` module

```yaml
---
- name: create file
  hosts: localhost
  tasks:
    - name: create file
      kraktorist.ansible_file.ansible_file:
        path: /tmp/test
        content: |
          333
          444
          555
          666
```
`kraktorist.ansible_file.ansible_file` role

```yaml
- hosts: localhost
  roles:
    - kraktorist.ansible_file.ansible_file
```