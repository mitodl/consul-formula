install_curl_for_consul_testing:
  pkg.installed:
    - name: curl

install_pip_executable_for_consul_testing:
  cmd.run:
    - name: |
        curl -L "https://bootstrap.pypa.io/get-pip.py" > get_pip.py
        sudo python get_pip.py 'pip<18.1'
        rm get_pip.py
    - reload_modules: True
    - unless: which pip
    - require:
        - pkg: install_curl_for_consul_testing

install_testinfra_library_for_consul_testing:
  pip.installed:
    - name: "testinfra~=1.19"
    - reload_modules: True
    - require:
        - cmd: install_pip_executable_for_consul_testing
    - order: 1

include:
  - .test_install
  - .test_service
  - .test_config
