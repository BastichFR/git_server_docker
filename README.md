# Git Server Docker

## Usage

All commands are present in the Makefile
Root access is required

Only files in `~/git/repositories` will be saved

### Build 

```
make  build      // Build the docker 
      run        // Lunch the docker
      stop       // Stop the docker
      remove     // Remove docker in images & ps 

      kill       // := stop remove
      do         // := build run
      redo       // := kill do

      exec_root  // connect locally to the docker in root mode
      exec_user  // connect locally to the docker in git (user) mode
```

### Log in docker

Log into the server through SSH. Note the git user is restricted to
only few commands, thoses are listed in the help command :

```
IP_ADDR = "curl -4 ifconfig.me"
ssh git@<$IP_ADDR> -p 2222
```

Only people whose ssh keys are registered in authorized_keys will be able to connect.

### Basic Use Case

#### Create repositories

Create and initialise a repository at `~/repositories`:

```
git-init repositories/your-repo.git
```

This command is equivalent to 

```
mkdir -p repositories/your-repo.git
git init --bare repositories/your-repo.git
```

#### Basic git commands

```
git clone ssh://git@<$IP_ADDR>:2222/home/git/repositories/your-repo.git
```

All other git commands work normally on your computer.
The ssh server shell executes only the git-init command.

## License

This project is under MIT License.
Please respect the use of this project and it's License

## About

Thanks to [AuroreMOMYM22004066][1] for her help and inspiration with this project. If any issue occurs, do not hesitate to contact us.

[1]: https://github.com/AuroreMOMYM22004066