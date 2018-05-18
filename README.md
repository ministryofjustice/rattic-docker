# rattic-docker
Rattic docker image build

# Backup destination and users

This container backs up the Rattic database to the `rattic.backup` S3
bucket. The backups are GPG encrypted, and the recipients are specified
at the end of `files/rattic.conf`. At the time of writing, they are:

- A19A21B3: steve.marshal@digital.justice.gov.uk, expires 2018-11-18
- 65B16CD7: trent.greenwood@digital.justice.gov.uk, expires 2019-05-07
- B7429174: paul.wyborn@digital.justice.gov.uk
- 58B8C32D: razvan.cosma@digital.justice.gov.uk
- A435E44F: lukasz.raczylo@digital.justice.gov.uk
- 0B083386: oliver.anwyll@digital.justice.gov.uk
- 6D3AEBED: john.ojuolape@digital.justice.gov.uk
