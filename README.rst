======
consul
======

Formula to launch and manage Consul agents.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.


Available states
================

.. contents::
    :local:

``consul``
----------

Install, configure, and start a Consul agent.

``consul.conf``
---------------

Write out configuration files from Pillar data and reload the Consul service.

``consul.dns_proxy``
--------------------

Install and configure DNSMasq to serve as a local DNS proxy to Consul so that the DNS interface can be used locally without any modification to clients.

``consul.upgrade``
------------------

Perform an in-place upgrade of Consul

Template
========

This formula was created from a cookiecutter template.

See https://github.com/mitodl/saltstack-formula-cookiecutter.
