## Ansible Collection - kraktorist.ansible-file

This is educational project for creating files

### Dependencies

```
pip install pyfiglet
```

https://github.com/pwaller/pyfiglet

### Installation

```yaml
# requirements.yaml

collections:
  - name: https://github.com/Kraktorist/ansible-figlet.git
    type: git
    version: master
```

```console
ansible-galaxy install -r requirements.yml
```

### Usage

```yaml
- name: transform the text
  kraktorist.figlet.figlet:
    name: 'Lorem Ipsum'
    font: "lean"
    width: 120
    direction: 1
    justify: left
  register: testout
- name: dump the text
  debug:
    msg: '{{ testout }}'
```

### Output

```
ok: [localhost] => 
  msg:
    changed: true
    failed: false
    message: |2-
  
          _/                                                          _/_/_/
         _/          _/_/    _/  _/_/    _/_/    _/_/_/  _/_/          _/    _/_/_/      _/_/_/  _/    _/  _/_/_/  _/_/
        _/        _/    _/  _/_/      _/_/_/_/  _/    _/    _/        _/    _/    _/  _/_/      _/    _/  _/    _/    _/
       _/        _/    _/  _/        _/        _/    _/    _/        _/    _/    _/      _/_/  _/    _/  _/    _/    _/
      _/_/_/_/    _/_/    _/          _/_/_/  _/    _/    _/      _/_/_/  _/_/_/    _/_/_/      _/_/_/  _/    _/    _/

```

### Examples

See [examples/testmod.yml](examples/testmod.yml) for another example