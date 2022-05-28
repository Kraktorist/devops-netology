#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
# from turtle import width
__metaclass__ = type

DOCUMENTATION = r'''
---
module: ansible_file

short_description: Module for creating files

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This module creates files with content

options:
    path:
        description: Path to the file
        required: true
        type: str
    content:
        description:
            - Content of the file
        required: true
        type: str

author:
    - Kraktorist (@kraktorist)
'''

EXAMPLES = r'''
# Pass in a message
- name: Test the file
  kraktorist.kraktorist.ansible_file:
    path: /tmp/ansible-test
    content: hello world
'''

RETURN = r'''

'''

from ansible.module_utils.basic import AnsibleModule
from pathlib import Path

def update_content(path, content):
    with open(path, 'w') as f:
        f.write(content)
  

def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        path=dict(type='str', required=True),
        content=dict(type='str', required=True)
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    try:
        destination_path = Path(module.params['path'])
        if destination_path.is_file():
            with open(module.params['path'], 'r') as f:
                content = f.read()
            if content != module.params['content']:
                update_content(module.params['path'], module.params['content'])
                result['changed'] = True
        else:
            if destination_path.parents[0].is_dir():
                update_content(module.params['path'], module.params['content'])
                result['changed'] = True
            else:
                module.fail_json(msg=f'Parent directory { destination_path.parents[0] } doesn\'t exist')
    except (IOError, OSError) as e:
        module.fail_json(msg='Failed', exception=repr(e))



    # use whatever logic you need to determine whether or not this module
    # made any modifications to your target
    

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()