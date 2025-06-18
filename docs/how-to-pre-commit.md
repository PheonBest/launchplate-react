(Optional) Pre-commit is used to ensure standards across the terraform codebase.

## How to install pre-commit

A. On Windows:

Either use **Devbox on WSL**, either do the following steps:

1. Open a Command Prompt with administrator privileges and run the following command to install Chocolatey:

```ps1
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

2. Install Python3

```ps1
choco install python -y
```

3. Install/Update pip

```ps1
python -m ensurepip --default-pip
python -m pip install --upgrade pip
```

4. Install terraform tools

```ps1
choco install tflint -y
choco install trivy -y
python -m pip install checkov
```

5. Install and run pre-commit

```ps1
py -m pip install pre-commit
py -m pre-commit
```

B. On MacOS:

Either use **Devbox**, either do the following steps:

```zsh
brew install pre-commit
brew install tflint
brew install trivy
brew install checkov
```

## Enable pre-commit

```bin/sh
pre-commit install
```

Once you run the command, any changes you commit from now will trigger all hooks

## Run pre-commit manually

If you want to trigger pre-commit manually, you can run the following command:

```bin/sh
pre-commit
```
