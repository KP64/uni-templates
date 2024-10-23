# University Templates 🎓

This repository contains [nix](https://nixos.org/) templates providing full support 
for modules of the university of [Bonn](https://www.uni-bonn.de/en).

## How to use a template

1. Make sure your system has nix installed and [flakes](https://nixos.wiki/wiki/flakes) enabled.
2. Go into the directory where you want to setup the template.
3. run `nix flake init -t github:KP64/uni-templates#module` where `module` is the abbreviation of the module this template is for.
4. Activate the devShell by running `direnv allow`
5. Enjoy :D

## Which modules are supported ⁉

The supported modules can be identified by the folders in the file structure of the repository.

Supported modules are for example:

- alpro
- dzi
- rdb

and many more (to come)!

> [!NOTE]
> Modules and their contents may change each semester.
>
> If a template doesn't satisfy your needs you may (and should!) contribute to this project.

## How to contribute 🧑‍💻

Q: Do you want the problem to be fixed without you having to modify code?\
A: No problem 👍. Simply open an issue explaining what didn't work/has to be changed and others will try to tackle the issue.

Q: Do you want to dirty your hands and fix the problem yourself?\
A: Submit a PR explaining the cause of the change.
