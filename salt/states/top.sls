base:
  '*':
    - common

  'roles:app':
    - match: grain
    - app

  'roles:lb':
    - match: grain
    - lb
