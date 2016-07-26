author_email <- "foo@bar.com"
enc_id <- "12345"
script_file <- ".file.ext"

ty1 <- '
language: r
'

tyaml1 <- yaml::yaml.load(ty1)
cat(yaml::as.yaml(edit_travis_yml(tyaml1, author_email, enc_id, script_file)))

ty2 <- '
language: r
env:
  - FOO=foo
'

tyaml2 <- yaml::yaml.load(ty2)
cat(yaml::as.yaml(edit_travis_yml(tyaml2, author_email, enc_id, script_file)))

ty2b <- '
language: r
env:
  - secure: 12345
'

tyaml2b <- yaml::yaml.load(ty2b)
cat(yaml::as.yaml(edit_travis_yml(tyaml2b, author_email, enc_id, script_file)))

ty2c <- '
language: r
env:
  secure: 12345
'

tyaml2c <- yaml::yaml.load(ty2c)
cat(yaml::as.yaml(edit_travis_yml(tyaml2c, author_email, enc_id, script_file)))

ty3 <- '
language: r
env:
  - FOO=foo
  - BAR=bar
'

tyaml3 <- yaml::yaml.load(ty3)
cat(yaml::as.yaml(edit_travis_yml(tyaml3, author_email, enc_id, script_file)))

ty4 <- '
language: r
env:
  - FOO=foo BAR=bar
  - FOO=bar BAR=foo
'

tyaml4 <- yaml::yaml.load(ty4)
cat(yaml::as.yaml(edit_travis_yml(tyaml4, author_email, enc_id, script_file)))

ty5 <- '
language: r
env:
  global:
    - FOO=foo
'

tyaml5 <- yaml::yaml.load(ty5)
cat(yaml::as.yaml(edit_travis_yml(tyaml5, author_email, enc_id, script_file)))

ty5b <- '
language: r
env:
  global:
    - secure: 12345
'

tyaml5b <- yaml::yaml.load(ty5b)
cat(yaml::as.yaml(edit_travis_yml(tyaml5b, author_email, enc_id, script_file)))

ty5c <- '
language: r
env:
  global:
    secure: 12345
'

tyaml5c <- yaml::yaml.load(ty5c)
cat(yaml::as.yaml(edit_travis_yml(tyaml5c, author_email, enc_id, script_file)))


ty6 <- '
language: r
env:
  global:
    - FOO=foo
    - BAR=bar
'

tyaml6 <- yaml::yaml.load(ty6)
cat(yaml::as.yaml(edit_travis_yml(tyaml6, author_email, enc_id, script_file)))

ty7 <- '
language: r
env:
  global:
    - FOO=foo
    - AUTHOR_EMAIL=oof@rab.com
'

tyaml7 <- yaml::yaml.load(ty7)
cat(yaml::as.yaml(edit_travis_yml(tyaml7, author_email, enc_id, script_file)))

ty8 <- '
language: r
env:
  global:
    - FOO=foo
    - AUTHOR_EMAIL=oof@rab.com
    - BAR=bar
'

tyaml8 <- yaml::yaml.load(ty8)
cat(yaml::as.yaml(edit_travis_yml(tyaml8, author_email, enc_id, script_file)))
