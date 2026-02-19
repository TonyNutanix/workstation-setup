# Create Rocky 10 VMs
- Update group_vars/all.yml with the correct info
- Make any other modifications needed for the specific use case
- Run 'ansible-playbook site.yml' to build everthing
- Run 'ansbile-playbook site.yml -e "pkg_state=absent" to remove everything