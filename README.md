### maqubes

This is an experiment to bring some QubesOS like experiences to MacOS on Apple Silicon.

### dependencies

- [`multipass`](https://multipass.run/) by Canonical
- [`X Quartz`](https://www.xquartz.org/)
    - settings: under security, need to "allow connections from network clients"

### usage

```sh
# creates a new vm
./cli.sh create vm1
# runs the "xeyes" application
./cli.sh run vm1 xeyes
```