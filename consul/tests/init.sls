install_curl:
  pkg.installed:
    - pkgs: curl
    - pkg_verify: True

install_pip_executable:
  cmd.run:
    - name: |
        curl -L "https://bootstrap.pypa.io/get-pip.py" > get_pip.py
        sudo python get_pip.py
        rm get_pip.py
    - reload_modules: True
    - unless: which pip

install_testinfra_library_for_consul_testing:
  pip.installed:
    - name: testinfra
    - reload_modules: True
    - require:
        - cmd: install_pip_executable
    - order: 1

include:
  - .test_install
  - .test_service
  - .test_config
