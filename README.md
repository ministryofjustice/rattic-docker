# rattic-docker
Rattic docker image build

# Backup destination and users

This container backs up the Rattic database to the `rattic.backup` S3
bucket. The backups are GPG encrypted, and the recipients are specified
at the end of `files/rattic.conf`. At the time of writing, they are:

- A19A21B3: steve.marshal@digital.justice.gov.uk, expires 2018-11-18
- 65B16CD7: trent.greenwood@digital.justice.gov.uk, expires 2019-05-07
- E4188C65: niall.creech@digital.justice.gov.uk, no expiry
- 2345602A: leonidas.tsampros@digital.justice.gov.uk, expires 2016-10-18
