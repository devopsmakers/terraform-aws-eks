# Requirements

<!-- 
All requirements to build / run / test this software should be specified in this file. 
-->


### git chglog

> Anytime, anywhere, Write your CHANGELOG.

https://github.com/git-chglog/git-chglog

```
brew tap git-chglog/git-chglog
brew install git-chglog
```

### pre commit

> Collection of git hooks for Terraform to be used with pre-commit framework

https://github.com/antonbabenko/pre-commit-terraform

Follow the quick-start here for setup instructions: https://pre-commit.com/#quick-start

```
brew install pre-commit gawk terraform-docs tflint
```

Install hooks:
```
pre-commit install
```

To have pre-commit hooks available in every cloned repo:
```
git config --global init.templateDir ~/.git-template
pre-commit init-templatedir ~/.git-template
```

### semtag

> Semantic Tagging Script for Git

https://github.com/pnikosis/semtag

 
